%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef Sibc < PhysicalDom
    properties
        sigma = 0
        mur = 0
        r_ht = 0
        r_et = 0
        cparam = 0
    end

    % --- Contructor
    methods
        function obj = Sibc(args)
            obj = obj@PhysicalDom(args);
            obj <= args;
            if isnumeric(obj.sigma)
                obj.sigma = Parameter('f',obj.sigma);
            end
            if isnumeric(obj.mur)
                obj.mur = Parameter('f',obj.mur);
            end
            % ---
            cparam_ = 0;
            if isnumeric(args.r_ht) && isnumeric(args.r_et)
                if ~isempty(args.r_ht) && ~isempty(args.r_et)
                    cparam_ = 1/args.r_ht - 1/args.r_et;
                elseif ~isempty(args.r_ht)
                    cparam_ = 1/args.r_ht;
                elseif ~isempty(args.r_et)
                    cparam_ = - 1/args.r_et;
                end
            end
            % ---
            obj.cparam = Parameter('f',cparam_);
            % ---
        end
    end
end