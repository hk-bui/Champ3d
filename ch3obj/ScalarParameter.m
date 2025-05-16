%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
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

classdef ScalarParameter < Xhandle
    properties
        parent_model
        f
        depend_on
        from
        varargin_list
        fvectorized
        % ---
        constant_parameter_type
    end
    
    % --- Valid args list
    methods (Static)
        function argslist = validargs()
            argslist = {'parent_model','f','depend_on','from','varargin_list','fvectorized'};
        end
    end
    % --- Contructor
    methods
        function obj = ScalarParameter(args)
            arguments
                args.parent_model {mustBeA(args.parent_model,{'PhysicalModel','CplModel'})}
                args.f = []
                args.depend_on {mustBeMember(args.depend_on,...
                    {'celem','cface','velem','sface','ledge',...
                     'J','V','I','Z','T','B','E','H','A','P','Phi',...
                     'ltime'})}
                args.from = []
                args.varargin_list = []
                args.fvectorized = 0
            end
            % ---
            obj = obj@Xhandle;
            % ---
            if ~isfield(args,'parent_model')
                error('#parent_model must be given !');
            end
            % ---
            if isempty(args.f)
                error('#f must be given ! Give a function handle or numeric value');
            end
            % ---
            if ~isfield(args,'depend_on')
                args.depend_on = '';
            end
            % ---
            if isnumeric(args.f)
                constant_parameter = args.f;
                % ---
                sizeconst = size(constant_parameter);
                % ---
                if numel(constant_parameter) == 1
                    obj.constant_parameter_type = 'scalar';
                elseif numel(constant_parameter) == 2 || numel(constant_parameter) == 3
                    constant_parameter = f_tocolv(constant_parameter);
                    obj.constant_parameter_type = 'vector';
                elseif isequal(sizeconst,[2 2]) || isequal(sizeconst,[3 3])
                    obj.constant_parameter_type = 'tensor';
                else
                    obj.constant_parameter_type = 'standardTensorArray';
                end
                % ---
                args.f = @()(constant_parameter);
                % ---
            elseif isa(args.f,'function_handle')
                if isempty(args.from)
                    error('#from must be given ! Give EMModel, THModel, ... ');
                else
                    args.from = f_to_scellargin(args.from);
                end
            else
                error('#f must be function handle or numeric value');
            end
            % ---
            obj.parent_model = args.parent_model;
            obj.f = args.f;
            obj.depend_on = f_to_scellargin(args.depend_on);
            obj.from = f_to_scellargin(args.from);
            obj.varargin_list = f_to_scellargin(args.varargin_list);
            obj.fvectorized = args.fvectorized;
            % --- check
            nb_fargin = f_nargin(obj.f);
            if nb_fargin > 0
                if nb_fargin ~= length(obj.depend_on)
                    error('Number of input arguments of #f must corresponds to #depend_on');
                elseif nb_fargin ~= length(obj.from)
                    error('Number of input arguments of #f must corresponds to #from');
                elseif length(obj.depend_on) ~= length(obj.from)
                    error('Number of elements in #depend_on must corresponds to #from');
                end
            end
            % -------------------------------------------------------------
        end
    end

    % --- Methods
    methods
        %------------------------------------------------------------------
        function vout = getvalue(obj,args)
            arguments
                obj
                args.in_dom = []
            end

        end
        %------------------------------------------------------------------
        function vout = get_inverse(obj,args)
            arguments
                obj
                args.in_dom = []
                args.parameter_type {mustBeMember(args.parameter_type,{'auto','vector'})} = 'vector'
            end
        end
    end
end