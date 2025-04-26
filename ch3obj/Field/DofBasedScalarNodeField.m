%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2025
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef DofBasedScalarNodeField < DofBaseMeshField
    properties
        reference_potential = 0
    end
    properties (Dependent)
        value
        node
    end
    % --- Contructor
    methods
        function obj = DofBasedScalarNodeField(args)
            arguments
                args.parent_model {mustBeA(args.parent_model,'PhysicalModel')}
                args.dof {mustBeA(args.dof,'NodeDof')}
                args.reference_potential = 0;
            end
            % ---
            obj = obj@DofBaseMeshField;
            % ---
            if ~isfield(args,'parent_model') || ~isfield(args,'dof')
                error('#parent_model and #dof must be given !');
            end
            obj <= args;
        end
    end
    % --- Get
    methods
        % -----------------------------------------------------------------
        function val = get.value(obj)
            val = obj.dof.value + obj.reference_potential;
        end
        % -----------------------------------------------------------------
        function val = get.node(obj)
            val = obj.parent_model.parent_mesh.node;
        end
    end
    % --- Plot
    methods
        % -----------------------------------------------------------------
        function plot(obj,args)
            arguments
                obj
                args.mesh_dom {mustBeA(args.mesh_dom,{'VolumeDom','SurfaceDom'})}
                args.id_elem = []
                args.show_dom = 1
            end
            % ---
            if isfield(args,'mesh_dom')
                dom = args.mesh_dom;
            end
            % ---
            if args.show_dom
                dom.plot('alpha',0.5,'edge_color',[0.9 0.9 0.9],'face_color','none')
            end
            % ---
            if isa(dom,'VolumeDom3d')
                node = obj.parent_model.parent_mesh.node;
                elem = obj.parent_model.parent_mesh.elem(:,dom.gid_elem);
                elem_type = f_elemtype(elem);
                face = f_boundface(elem,node,'elem_type',elem_type);
                % ---
                it = obj.dof.parent_model.ltime.it;
                fs = obj.dof.parent_model.field{it}.(args.field_name).node.value;
                % ---
                f_patch(node,face,'defined_on','face','scalar_field',fs);
            end
            % ---
            if isa(obj.dom,'SurfaceDom3d')
                node = obj.parent_model.parent_mesh.node;
                face = obj.parent_model.parent_mesh.face(:,dom.gid_face);
                % ---
                it = obj.parent_model.ltime.it;
                fs = obj.parent_model.field{it}.(args.field_name).node.value;
                %fs = fs(obj.dom.gid_face);
                % ---
                f_patch(node,face,'defined_on','face','scalar_field',fs);
            end
        end
        % -----------------------------------------------------------------
    end
end