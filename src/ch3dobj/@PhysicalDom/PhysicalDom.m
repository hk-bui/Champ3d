%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef PhysicalDom < Xhandle
    properties
        dom
        to_be_rebuild
    end
    % ---
    properties (Hidden)
        parent_model
        parent_mesh
        dom2d_collection
        id_dom2d
        dom3d_collection
        id_dom3d
    end
    % ---
    properties(Access = private, Hidden)
        id
        sigma
        mur
        Br
        lambda
        rho
        Cp
    end
    % ---

    % --- Contructor
    methods
        function obj = PhysicalDom(args)
            arguments
                args.parent_model = []
                % ---
                args.dom2d_collection = []
                args.id_dom2d = []
                args.dom3d_collection = []
                args.id_dom3d = []
                % ---
                args.id = []
                args.sigma = []
                args.mur = []
                args.Br = []
                args.lambda = []
                args.rho = []
                args.Cp = []
            end
            % ---
            if ~isempty(args.parent_model)
                if ~isempty(args.parent_model.dom2d_collection)
                    args.dom2d_collection = args.parent_model.dom2d_collection;
                end
                if ~isempty(args.parent_model.dom3d_collection)
                    args.dom3d_collection = args.parent_model.dom3d_collection;
                end
            end
            % ---
            if ~isempty(args.dom2d_collection)
                if ~isempty(args.id_dom2d)
                    obj.dom = args.dom2d_collection.(args.id_dom2d);
                end
            end
            if ~isempty(args.dom3d_collection)
                if ~isempty(args.id_dom3d)
                    obj.dom = args.dom3d_collection.(args.id_dom3d);
                end
            end
        end
    end

    % --- Methods
    methods
        function coef_array = call_coefficient(obj,args)
            arguments
                obj
                % ---
                args.coef_name = []
            end
        end
    end
end