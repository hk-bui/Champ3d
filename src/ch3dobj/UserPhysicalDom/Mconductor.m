%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef Mconductor < PhysicalDom
    properties
        mur = 1
    end

    % --- Contructor
    methods
        function obj = Mconductor(args)
            obj = obj@PhysicalDom(args);
            obj <= args;
            if isnumeric(obj.mur)
                obj.mur = Parameter('f',obj.mur);
            end
        end
    end
end