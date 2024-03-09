%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef SolidCloseVsCoil < SolidCoil & CloseCoil
    properties
        coil_mode = 'tx'
    end

    % --- Contructor
    methods
        function obj = SolidCloseVsCoil(args)
            arguments
                args.id
                args.parent_model
                args.id_dom2d
                args.id_dom3d
                args.connexion
                args.cs_area
                args.nb_turn
                args.fill_factor
                args.etrode_equation
                % ---
                args.v_coil
                args.coil_mode {mustBeMember(args.coil_mode,{'tx','rx'})}
            end
            % ---
            obj@SolidCoil;
            obj@CloseCoil;
            % ---
            if isempty(fieldnames(args))
                return
            end
            % ---
            obj <= args;
            % ---
            obj.setup_done = 0;
            % ---
            obj.setup;
        end
    end

    % --- setup
    methods
        function setup(obj)
            if ~obj.setup_done
                % ---
                setup@SolidCoil(obj);
                obj.setup_done = 0;
                setup@CloseCoil(obj);
                % ---
                if isempty(obj.v_coil)
                    obj.coil_mode = 'rx';
                elseif isnumeric(obj.v_coil)
                    if obj.v_coil == 0
                        obj.coil_mode = 'rx';
                    end
                    % ---
                    obj.v_coil = Parameter('f',obj.v_coil);
                end
                % ---
                obj.setup_done = 1;
            end
        end
    end

    % --- Methods
    methods
        function plot(obj)
            plot@CloseCoil(obj);
        end
    end

end