%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2025
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef NodeDof < MeshDof
    properties
        
    end
    % --- Contructor
    methods
        function obj = NodeDof(args)
            arguments
                args.parent_mesh {mustBeA(args.parent_mesh,'Mesh')}
                args.value
            end
            % ---
            obj = obj@MeshDof;
            % ---
            if isfield(args,'parent_mesh') && ~isfield(args,'value')
                obj <= args;
                obj.setup;
            end
            % ---
        end
    end
    % --- Methods/public
    methods
        % -----------------------------------------------------------------
        function setup(obj)
            nb_node = obj.parent_mesh.nb_node;
            if numel(obj.value) == 1
                obj.value = obj.value .* ones(1,nb_node);
            else
                if numel(obj.value) ~= nb_node
                    error('#value must correspond to mesh node, check size !');
                end
            end
        end
    end
end