%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef MconductorAphi < Mconductor

    % --- computed
    properties
        matrix
    end

    % --- computed
    properties (Access = private)
        build_done = 0
    end

    % --- Contructor
    methods
        function obj = MconductorAphi(args)
            arguments
                args.id
                args.parent_model
                args.id_dom2d
                args.id_dom3d
                args.mur
            end
            % ---
            obj = obj@Mconductor;
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
            setup@Mconductor(obj);
            % ---
            if isnumeric(obj.mur)
                obj.mur = Parameter('f',obj.mur);
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
            mu0 = 4 * pi * 1e-7;
            nu0 = 1/mu0;
            nu0nur = nu0 .* obj.mur.get_inverse_on(dom);
            % ---
            nu0nurwfwf = parent_mesh.cwfwf('id_elem',gid_elem,'coefficient',nu0nur);
            % ---
            obj.matrix.gid_elem = gid_elem;
            obj.matrix.nu0nurwfwf = nu0nurwfwf;
            % ---
            obj.build_done = 1;
        end
    end

    % --- assembly
    methods
        function assembly(obj)
            id_elem_mcon = obj.matrix.id_elem_mcon;
            nu0nurwfwf = sparse(nb_face,nb_face);
            % ---
            for iec = 1:length(id_mconductor__)
                %----------------------------------------------------------------------
                id_phydom = id_mconductor__{iec};
                %----------------------------------------------------------------------
                f_fprintf(0,'--- #mcon',1,id_phydom,0,'\n');
                %----------------------------------------------------------------------
                id_elem = obj.mconductor.(id_phydom).matrix.gid_elem;
                lmatrix = obj.mconductor.(id_phydom).matrix.nu0nurwfwf;
                %----------------------------------------------------------------------
                [~,id_] = intersect(id_elem,id_elem_nomesh);
                id_elem(id_) = [];
                lmatrix(id_,:,:) = [];
                %----------------------------------------------------------------------
                for i = 1:nbFa_inEl
                    for j = i+1 : nbFa_inEl
                        nu0nurwfwf = nu0nurwfwf + ...
                            sparse(id_face_in_elem(i,id_elem),id_face_in_elem(j,id_elem),...
                            lmatrix(:,i,j),nb_face,nb_face);
                    end
                end
                %----------------------------------------------------------------------
            end
            % ---
            nu0nurwfwf = nu0nurwfwf + nu0nurwfwf.';
            % ---
            for iec = 1:length(id_mconductor__)
                %----------------------------------------------------------------------
                id_phydom = id_mconductor__{iec};
                %----------------------------------------------------------------------
                id_elem = obj.mconductor.(id_phydom).matrix.gid_elem;
                lmatrix = obj.mconductor.(id_phydom).matrix.nu0nurwfwf;
                %----------------------------------------------------------------------
                [~,id_] = intersect(id_elem,id_elem_nomesh);
                id_elem(id_) = [];
                lmatrix(id_,:,:) = [];
                %----------------------------------------------------------------------
                for i = 1:nbFa_inEl
                    nu0nurwfwf = nu0nurwfwf + ...
                        sparse(id_face_in_elem(i,id_elem),id_face_in_elem(i,id_elem),...
                        lmatrix(:,i,i),nb_face,nb_face);
                end
            end
        end
    end
end