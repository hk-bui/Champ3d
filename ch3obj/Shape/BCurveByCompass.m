%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2025
% as a contribution to Champ3d code.
%--------------------------------------------------------------------------
% Champ3d is copyright (c) 2023-2025 H-K. Bui.
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% See LICENSE and CREDITS files for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef BCurveByCompass < CurveShape
    properties
        start_point = [0 0]
        go = {}
        x
        y
    end
    % --- Constructors
    methods
        function obj = BCurveByCompass(args)
            arguments
                args.start_point = []
            end
            % ---
            obj = obj@CurveShape;
            % ---
            if isempty(args.start_point)
                error('#start_point must be given !');
            elseif length(args.start_point) ~= 2
                error('#start_point must have dim 2 !');
            end
            % ---
            obj <= args;
        end
    end
    % --- setup/reset
    methods (Static)
        function setup(obj)
            obj.set_parameter;
        end
    end
    methods (Access = public)
        function reset(obj)
            BCurveByCompass.setup(obj);
            % --- reset dependent obj
            obj.reset_dependent_obj;
        end
    end
    % --- Methods
    methods
        %------------------------------------------------------------------
        function xgo(obj,args)
            arguments
                obj
                args.len (1,1) = 0
            end
            % ---
            obj.go{end + 1} = struct('type','xgo','len',args.len);
            % ---
        end
        %------------------------------------------------------------------
        function ygo(obj,args)
            arguments
                obj
                args.len (1,1) = 0
            end
            % ---
            obj.go{end + 1} = struct('type','ygo','len',args.len);
            % ---
        end
        %------------------------------------------------------------------
        function xygo(obj,args)
            arguments
                obj
                args.lenx (1,1) = 0
                args.leny (1,1) = 0
            end
            % ---
            obj.go{end + 1} = struct('type','xygo','lenx',args.lenx,'leny',args.leny);
            % ---
        end
        %------------------------------------------------------------------
        function ago(obj,args)
            arguments
                obj
                args.angle (1,1) = 180
                args.center
                args.dnum (1,1) = 5
            end
            % ---
            obj.go{end + 1} = struct('type','ago','angle',args.angle, ...
                'center',args.center,'dnum',args.dnum);
            % ---
        end
        %------------------------------------------------------------------
        function geocode = geocode(obj)
            obj.get_curve;
            % ---
            c = obj.center.getvalue;
            r = obj.r.getvalue;
            hei = obj.hei.getvalue;
            opening_angle = obj.opening_angle.getvalue;
            orientation = obj.orientation.getvalue;
            % ---
            geocode = GMSHWriter.bcylinder(c,r,hei,opening_angle,orientation);
            % ---
            geocode = obj.transformgeocode(geocode);
            % ---
        end
        %------------------------------------------------------------------
    end
    % --- 
    methods (Access = private)
        function get_curve(obj)
            x_{1} = obj.start_point(1);
            y_{1} = obj.start_point(2);
            for i = 1:length(obj.go)
                go_ = obj.go{i};
                switch go_.type
                    case 'xgo'
                        % --- XTODO for Parameter
                        len = go_.len;
                        if len ~= 0
                            x_{end + 1} = x_{end} + len;
                            y_{end + 1} = y_{end};
                        end
                    case 'ygo'
                        len = go_.len;
                        if len ~= 0
                            x_{end + 1} = x_{end};
                            y_{end + 1} = y_{end} + len;
                        end
                    case 'xygo'
                        lenx = go_.lenx;
                        leny = go_.leny;
                        if lenx ~= 0 || leny ~= 0
                            x_{end + 1} = x_{end} + lenx;
                            y_{end + 1} = y_{end} + leny;
                        end
                    case 'ago'
                        angle = go_.angle;
                        dnum  = go_.dnum;
                        da    = angle/dnum;
                        center = f_torowv(go_.center);
                        if angle ~= 0 && ~isequal(center,[x_{end} y_{end}])
                            p0 = [x_{end} y_{end}];
                            for ida = 1:dnum
                                r = norm(p0 - center);
                                lOx = (p0 - center);
                                % ---
                                lvmove = [0 0];
                                lvmove(1) = r * cosd(i*da);
                                lvmove(2) = r * sind(i*da);
                                % ---
                                dv = lvmove - [r 0];
                                % ---
                                rot_axis = cross([1 0 0],[lOx 0]);
                                rot_angle = acosd(lOx(1) / r);
                                dv = f_rotaroundaxis(dv.','rot_angle',rot_angle, ...
                                    'rot_axis',rot_axis,'axis_origin',[center 0]);
                                dx = dv(1);
                                dy = dv(2);
                                % ---
                                x_{end + 1} = p0 + dx;
                                y_{end + 1} = p0 + dy;
                            end
                        end
                end
            end
            % ---
            obj.x = cell2mat(x_);
            obj.y = cell2mat(y_);
            % ---
        end
    end
    % --- Plot
    methods
        function plot(obj)
            obj.get_curve;
            plot(obj.x,obj.y,'-c','LineWidth',3);
        end
    end
end
