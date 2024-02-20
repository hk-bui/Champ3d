%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef FEM3dAphi < EmModel
    
    % --- Contructor
    methods
        function obj = FEM3dAphi(args)
            arguments
                args.id = 'no_id'
                args.parent_mesh = []
            end
            % ---
            argu = f_to_namedarg(args);
            obj = obj@EmModel(argu{:});
            % ---
            obj <= args;
        end
    end

    % --- Methods
    methods
        % -----------------------------------------------------------------
        function build_econductor(obj)
            phydom_type = 'econductor';
            % ---
            allphydom = fieldnames(obj.(phydom_type));
            % ---
            for i = 1:length(allphydom)
                % ---
                id_phydom = allphydom{i};
                % ---
                phydom = obj.(phydom_type).(id_phydom);
                dom__ = phydom.dom;
                for j = 1:length(dom__)
                    dom = dom__{j};
                    parent_mesh = dom.parent_mesh;
                    gid_elem    = dom.gid_elem;
                    %------------------------------------------------------
                    elem = parent_mesh.elem(:,gid_elem);
                    %------------------------------------------------------
                    id_node_phi = f_uniquenode(elem);
                    %------------------------------------------------------
                    sigma_array = obj.(phydom_type).(id_phydom).sigma.get_on(dom);
                    %------------------------------------------------------
                    sigmawewe = parent_mesh.cwewe('id_elem',gid_elem,'coefficient',sigma_array);
                    %------------------------------------------------------
                    obj.(phydom_type).(id_phydom).matrix.id_node_phi = id_node_phi;
                    obj.(phydom_type).(id_phydom).matrix.sigmawewe = sigmawewe;
                    %------------------------------------------------------
                end
            end
        end
        % -----------------------------------------------------------------
        function build_mconductor(obj)
            phydom_type = 'mconductor';
            % ---
            allphydom = fieldnames(obj.(phydom_type));
            % ---
            for i = 1:length(allphydom)
                % ---
                id_phydom = allphydom{i};
                % ---
                phydom = obj.(phydom_type).(id_phydom);
                dom__ = phydom.dom;
                for j = 1:length(dom__)
                    dom = dom__{j};
                    parent_mesh = dom.parent_mesh;
                    gid_elem    = dom.gid_elem;
                    %------------------------------------------------------
                    elem = parent_mesh.elem(:,gid_elem);
                    %------------------------------------------------------
                    mu0 = 4 * pi * 1e-7;
                    nu0 = 1/mu0;
                    nu0nur = nu0 .* obj.(phydom_type).(id_phydom).mur.get_inverse_on(dom);
                    %------------------------------------------------------
                    nu0nurwfwf = parent_mesh.cwfwf('id_elem',gid_elem,'coefficient',nu0nur);
                    %------------------------------------------------------
                    obj.(phydom_type).(id_phydom).matrix.nu0nurwfwf = nu0nurwfwf;
                    %------------------------------------------------------
                end
            end
        end
        % -----------------------------------------------------------------
        function build_airbox(obj)
            % ---
            if isempty(obj.airbox)
                if ~isfield(obj.parent_mesh.dom,'default_domain')
                    obj.parent_mesh.add_default_domain;
                end
                obj.add_airbox('id','default_airbox','id_dom3d','default_domain');
            end
            % ---
            phydom_type = 'airbox';
            % ---
            allphydom = fieldnames(obj.(phydom_type));
            % ---
            for i = 1:length(allphydom)
                % ---
                id_phydom = allphydom{i};
                % ---
                phydom = obj.(phydom_type).(id_phydom);
                dom__ = phydom.dom;
                for j = 1:length(dom__)
                    dom = dom__{j};
                    parent_mesh = dom.parent_mesh;
                    gid_elem    = dom.gid_elem;
                    %------------------------------------------------------
                    elem = parent_mesh.elem(:,gid_elem);
                    %------------------------------------------------------
                    mu0 = 4 * pi * 1e-7;
                    nu0 = 1/mu0;
                    nu0nur = nu0 .* obj.(phydom_type).(id_phydom).mur.get_inverse_on(dom);
                    %------------------------------------------------------
                    nu0nurwfwf = parent_mesh.cwfwf('id_elem',gid_elem,'coefficient',nu0nur);
                    %------------------------------------------------------
                    obj.(phydom_type).(id_phydom).matrix.nu0nurwfwf = nu0nurwfwf;
                    %------------------------------------------------------
                end
            end
        end
        % -----------------------------------------------------------------
        % -----------------------------------------------------------------
        % -----------------------------------------------------------------
        % -----------------------------------------------------------------
        % -----------------------------------------------------------------
        % -----------------------------------------------------------------
        % -----------------------------------------------------------------
    end
end