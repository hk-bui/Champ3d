%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef EconductorAphi < Econductor

    % --- computed
    properties
        matrix
    end

    % --- computed
    properties (Access = private)
        setup_done = 0
        build_done = 0
        assembly_done = 0
    end

    % --- Contructor
    methods
        function obj = EconductorAphi(args)
            arguments
                args.id
                args.parent_model
                args.id_dom2d
                args.id_dom3d
                args.sigma
            end
            % ---
            obj = obj@Econductor;
            % ---
            if isempty(fieldnames(args))
                return
            end
            % ---
            obj <= args;
            % ---
            obj.setup_done = 0;
            obj.build_done = 0;
            obj.assembly_done = 0;
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
            setup@Econductor(obj);
            % ---
            if isnumeric(obj.sigma)
                obj.sigma = Parameter('f',obj.sigma);
            end
            % ---
            obj.setup_done = 1;
            % ---
            obj.build_done = 0;
            obj.assembly_done = 0;
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
            elem = parent_mesh.elem(:,gid_elem);
            % ---
            gid_node_phi = f_uniquenode(elem);
            % ---
            sigma_array = obj.sigma.get_on(dom);
            % ---
            sigmawewe = parent_mesh.cwewe('id_elem',gid_elem,'coefficient',sigma_array);
            % ---
            obj.matrix.gid_elem = gid_elem;
            obj.matrix.gid_node_phi = gid_node_phi;
            obj.matrix.sigmawewe = sigmawewe;
            obj.matrix.sigma_array = sigma_array;
            % ---
            obj.build_done = 1;
        end
    end

    % --- assembly
    methods
        function assembly(obj)
            % ---
            obj.build;
            % ---
            if obj.assembly_done
                return
            end
            % ---
            dom = obj.dom;
            parent_mesh = dom.parent_mesh;
            gid_elem = dom.gid_elem;
            % ---
            elem = parent_mesh.elem(:,gid_elem);
            sigmawewe = sparse(nb_edge,nb_edge);
            % ---
            id_node_phi = [];
            % ---
            for iec = 1:length(id_econductor__)
                %----------------------------------------------------------------------
                id_phydom = id_econductor__{iec};
                %----------------------------------------------------------------------
                f_fprintf(0,'--- #econ',1,id_phydom,0,'\n');
                %----------------------------------------------------------------------
                id_elem = obj.econductor.(id_phydom).matrix.gid_elem;
                lmatrix = obj.econductor.(id_phydom).matrix.sigmawewe;
                %----------------------------------------------------------------------
                [~,id_] = intersect(id_elem,id_elem_nomesh);
                id_elem(id_) = [];
                lmatrix(id_,:,:) = [];
                %----------------------------------------------------------------------
                for i = 1:nbEd_inEl
                    for j = i+1 : nbEd_inEl
                        sigmawewe = sigmawewe + ...
                            sparse(id_edge_in_elem(i,id_elem),id_edge_in_elem(j,id_elem),...
                            lmatrix(:,i,j),nb_edge,nb_edge);
                    end
                end
                %----------------------------------------------------------------------
                id_node_phi = [id_node_phi ...
                    obj.econductor.(id_phydom).matrix.gid_node_phi];
                %----------------------------------------------------------------------
            end
            % ---
            sigmawewe = sigmawewe + sigmawewe.';
            % ---
            for iec = 1:length(id_econductor__)
                %----------------------------------------------------------------------
                id_phydom = id_econductor__{iec};
                %----------------------------------------------------------------------
                id_elem = obj.econductor.(id_phydom).matrix.gid_elem;
                lmatrix = obj.econductor.(id_phydom).matrix.sigmawewe;
                %----------------------------------------------------------------------
                [~,id_] = intersect(id_elem,id_elem_nomesh);
                id_elem(id_) = [];
                lmatrix(id_,:,:) = [];
                %----------------------------------------------------------------------
                for i = 1:nbEd_inEl
                    sigmawewe = sigmawewe + ...
                        sparse(id_edge_in_elem(i,id_elem),id_edge_in_elem(i,id_elem),...
                        lmatrix(:,i,i),nb_edge,nb_edge);
                end
            end
            % ---
            obj.assembly_done = 1;
        end
    end
end