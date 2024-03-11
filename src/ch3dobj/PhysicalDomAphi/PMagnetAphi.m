%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef PMagnetAphi < PMagnet

    % --- computed
    properties
        build_done = 0
        matrix
    end

    % --- Contructor
    methods
        function obj = PMagnetAphi(args)
            arguments
                args.id
                args.parent_model
                args.id_dom2d
                args.id_dom3d
                args.br
            end
            % ---
            obj = obj@PMagnet;
            % ---
            if isempty(fieldnames(args))
                return
            end
            % ---
            obj <= args;
            % ---
            obj.setup_done = 0;
            obj.build_done = 0;
            % ---
            obj.setup;
        end
    end

    % --- setup
    methods
        function setup(obj)
            if obj.setup_done
                return
            end
            % ---
            setup@PMagnet(obj);
            % ---
            if isnumeric(obj.br)
                obj.br = Parameter('f',obj.br);
            end
            % ---
            obj.setup_done = 1;
            % ---
            obj.build_done = 0;
        end
    end

    % --- build
    methods
        function build(obj)
            % ---
            obj.setup;
            % ---
            if obj.build_done
                return
            end
            % ---
            dom = obj.dom;
            parent_mesh = dom.parent_mesh;
            gid_elem = dom.gid_elem;
            % ---
            br = obj.br.get_on(dom);
            wfbr = parent_mesh.cwfvf('id_elem',gid_elem,'vector_field',br);
            % ---
            obj.matrix.gid_elem = gid_elem;
            obj.matrix.wfbr = wfbr;
            % ---
            obj.build_done = 1;
        end
    end

    % --- assembly
    methods
        function assembly(obj)
            a_pmagnet = zeros(nb_edge,1);
            for iec = 1:length(id_pmagnet__)
                %----------------------------------------------------------------------
                wfbr = sparse(nb_face,1);
                %----------------------------------------------------------------------
                id_phydom = id_pmagnet__{iec};
                %----------------------------------------------------------------------
                f_fprintf(0,'--- #pmagnet',1,id_phydom,0,'\n');
                %----------------------------------------------------------------------
                id_elem = obj.pmagnet.(id_phydom).matrix.gid_elem;
                lmatrix = obj.pmagnet.(id_phydom).matrix.wfbr;
                for i = 1:nbFa_inEl
                    wfbr = wfbr + ...
                        sparse(id_face_in_elem(i,id_elem),1,lmatrix(:,i),nb_face,1);
                end
                %----------------------------------------------------------------------
                rotb = obj.parent_mesh.discrete.rot.' * wfbr;
                rotrot = obj.parent_mesh.discrete.rot.' * ...
                    obj.matrix.wfwf * ...
                    obj.parent_mesh.discrete.rot;
                %----------------------------------------------------------------------
                id_edge_a_unknown = obj.matrix.id_edge_a;
                %----------------------------------------------------------------------
                rotb = rotb(id_edge_a_unknown,1);
                rotrot = rotrot(id_edge_a_unknown,id_edge_a_unknown);
                %----------------------------------------------------------------------
                int_oned_a = zeros(nb_edge,1);
                int_oned_a(id_edge_a_unknown) = f_solve_axb(rotrot,rotb);
                clear rotb rotrot
                %----------------------------------------------------------------------
                a_pmagnet = a_pmagnet + int_oned_a;
            end
            %--------------------------------------------------------------------------
            obj.dof.a_pm = a_pmagnet;
            obj.dof.bpm  = obj.parent_mesh.discrete.rot * a_pmagnet;
        end
    end
end