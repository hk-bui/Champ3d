%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef JsCoilAphi < Xhandle
    
    % --- computed
    properties (Access = private)
        build_done = 0;
        assembly_done = 0;
    end

    % --- Contructor
    methods
        function obj = JsCoilAphi()
            obj@Xhandle;
        end
    end

    % --- build
    methods
        function build(obj)
            if obj.build_done
                return
            end
            % --- current turn density vector field
            current_turn_density  = obj.matrix.unit_current_field .* obj.nb_turn ./ obj.cs_area;
            % ---
            js_array = obj.j_coil.get_on(obj.dom);
            js_array = js_array .* obj.matrix.unit_current_field;
            % ---
            gid_elem = obj.dom.gid_elem;
            wfjs = obj.parent_mesh.cwfvf('id_elem',gid_elem,'vector_field',js_array);
            % ---
            obj.matrix.current_turn_density = current_turn_density;
            obj.matrix.wfjs = wfjs;
            % ---
            obj.build_done = 1;
            obj.assembly_done = 0;
        end
    end

    % --- assembly
    methods
        function assembly(obj)
            obj.build;
            % ---
            if obj.assembly_done
                return
            end
            % ---
            t_jsfield = zeros(nb_edge,1);
            id_node_netrode = [];
            id_node_petrode = [];
            for iec = 1:length(id_coil__)
                %----------------------------------------------------------------------
                wfjs = sparse(nb_face,1);
                %----------------------------------------------------------------------
                id_phydom = id_coil__{iec};
                coil = obj.coil.(id_phydom);
                %----------------------------------------------------------------------
                if isa(coil,'JsCoilAphi')
                    %----------------------------------------------------------------------
                    f_fprintf(0,'--- #coil/jscoil',1,id_phydom,0,'\n');
                    %----------------------------------------------------------------------
                    id_elem = coil.matrix.gid_elem;
                    lmatrix = coil.matrix.wfjs;
                    for i = 1:nbFa_inEl
                        wfjs = wfjs + ...
                            sparse(id_face_in_elem(i,id_elem),1,lmatrix(:,i),nb_face,1);
                    end
                    %----------------------------------------------------------------------
                    rotj = obj.parent_mesh.discrete.rot.' * wfjs;
                    rotrot = obj.parent_mesh.discrete.rot.' * ...
                        obj.matrix.wfwf * ...
                        obj.parent_mesh.discrete.rot;
                    %----------------------------------------------------------------------
                    id_edge_t_unknown = obj.matrix.id_edge_a;
                    %----------------------------------------------------------------------
                    rotj = rotj(id_edge_t_unknown,1);
                    rotrot = rotrot(id_edge_t_unknown,id_edge_t_unknown);
                    %----------------------------------------------------------------------
                    int_oned_t = zeros(nb_edge,1);
                    int_oned_t(id_edge_t_unknown) = f_solve_axb(rotrot,rotj);
                    clear rotj rotrot
                    %----------------------------------------------------------------------
                    t_jsfield = t_jsfield + int_oned_t;
                elseif isa(coil,'IsCoilAphi') || ...
                        isa(coil,'VsCoilAphi')
                    id_node_netrode = [id_node_netrode obj.coil.(id_phydom).gid_node_petrode];
                    id_node_petrode = [id_node_petrode obj.coil.(id_phydom).gid_node_netrode];
                end
            end
            %--------------------------------------------------------------------------
            clear wfjs
            %--------------------------------------------------------------------------
            obj.dof.t_js = t_jsfield;
            obj.dof.js   = obj.parent_mesh.discrete.rot * t_jsfield;
            obj.matrix.js  = obj.parent_mesh.field_wf('dof',obj.dof.js);
            % ---
        end
    end
end