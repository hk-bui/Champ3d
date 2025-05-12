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

classdef GlobalQuantityDof < Xhandle
    properties
        parent_model
        % ---
        value
    end
    % --- Contructor
    methods
        function obj = GlobalQuantityDof(args)
            arguments
                args.parent_model {mustBeA(args.parent_model,'PhysicalModel')}
                args.value = []
            end
            % ---
            obj = obj@Xhandle;
            % ---
            if ~isfield(args,'parent_model')
                error('#parent_model must be given');
            end
            % ---
            obj.parent_model = args.parent_model;
            obj.value = args.value;
            % ---
        end
    end
    % --- set/check
    methods
        % -----------------------------------------------------------------
        function set.value(obj,value)
            if isempty(value)
                obj.value = 0;
            elseif numel(value) == 1
                obj.value = value;
            else
                % --- XTODO : may cause bug ?
                obj.value = sum(value(:));
            end
        end
    end
end