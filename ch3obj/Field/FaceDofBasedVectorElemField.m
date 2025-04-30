%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2025
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef FaceDofBasedVectorElemField < VectorElemField
    properties
        parent_model
        dof
        reference_potential = 0
    end
    properties (Dependent)
        cvalue
        ivalue
        gvalue
        node
    end
    % --- Contructor
    methods
        function obj = FaceDofBasedVectorElemField(args)
            arguments
                args.parent_model {mustBeA(args.parent_model,'PhysicalModel')}
                args.dof {mustBeA(args.dof,'FaceDof')}
                args.reference_potential = 0
            end
            % ---
            obj = obj@VectorElemField;
            % ---
            if nargin >1
                if ~isfield(args,'parent_model') || ~isfield(args,'dof')
                    error('#parent_model and #dof must be given !');
                end
            end
            % ---
            obj <= args;
            % ---
        end
    end
    % --- get
    methods
        % -----------------------------------------------------------------
        function val = get.cvalue(obj)
            val = obj.parent_model.parent_mesh.field_wf('dof',obj.dof.value,'on','center') ...
                  + obj.reference_potential;
        end
        % -----------------------------------------------------------------
        function val = get.node(obj)
            val = obj.parent_model.parent_mesh.celem;
        end
    end
end