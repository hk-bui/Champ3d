%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef EmModel < Xhandle
    properties
        id
        % ---
        fr = 0
        jome
        % ---
        id_mesh2d
        id_mesh3d
        % ---
        geo_model
        mesh2d
        mesh3d
        % ---
        econductor
        mconductor
        pmagnet
        airbox
        nomesh
        coil
        bsfield
        sibc
        % ---
        matrix
        field
    end

    % --- Constructor
    methods
        function obj = EmModel(args)
            arguments
                args.id = 'no_id'
                % ---
                args.geo_model = []
                args.id_mesh2d = []
                args.id_mesh3d = []
                % ---
                args.mesh2d = []
                args.mesh3d = []
            end
            % ---
            args = obj.getargs(args);
            % ---
            obj <= args;
            % ---
            obj.jome = 1j*2*pi*obj.fr;
        end
    end

    % --- Methods
    methods
        % -----------------------------------------------------------------
        function add_econductor(obj,args)
            arguments
                obj
                % ---
                args.id = 'no_id'
                args.id_dom2d = []
                args.id_dom3d = []
                args.sigma = 0
            end
            % ---
            args.parent_model = obj;
            % ---
            args = obj.getargs(args);
            phydom = Econductor(args);
            obj.econductor.(args.id) = phydom;
        end
        % -----------------------------------------------------------------
        function add_airbox(obj) 
        end
        % -----------------------------------------------------------------
        function add_nomesh(obj) 
        end
        % -----------------------------------------------------------------
        function add_sibc(obj) 
        end
        % -----------------------------------------------------------------
        function add_bsfield(obj) 
        end
        % -----------------------------------------------------------------
        function add_embc(obj) 
        end
        % -----------------------------------------------------------------
        function add_open_iscoil(obj) 
        end
        % -----------------------------------------------------------------
        function add_close_iscoil(obj) 
        end
        % -----------------------------------------------------------------
        function add_open_jscoil(obj) 
        end
        % -----------------------------------------------------------------
        function add_close_jscoil(obj) 
        end
        % -----------------------------------------------------------------
        function add_open_vscoil(obj) 
        end
        % -----------------------------------------------------------------
        function add_close_vscoil(obj) 
        end
        % -----------------------------------------------------------------
        function add_mconductor(obj) 
        end
        % -----------------------------------------------------------------
        function add_pmagnet(obj) 
        end
        % -----------------------------------------------------------------
    end

    % --- Methods/Abs
    methods
        function build(obj)
        end
        function solve(obj)
        end
        function postpro(obj)
        end
    end
end