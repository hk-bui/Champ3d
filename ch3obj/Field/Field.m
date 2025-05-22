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

classdef Field < Xhandle
    % --- Contructor
    methods
        function obj = Field()
            obj = obj@Xhandle;
        end
    end
    % --- Utilily Methods
    methods
        function field_array = subsref(obj,gid)
            if iscell(gid)
                gid = gid{1};
                if iscell(gid)
                    % --- gvalue
                    gid = gid{1};
                    field_array = obj.gvalue(gid);
                elseif isnumeric(gid)
                    % --- ivalue
                    field_array = obj.ivalue(gid);
                end
            elseif isnumeric(gid)
                % --- cvalue
                field_array = obj.cvalue(gid);
            end
        end
    end
end