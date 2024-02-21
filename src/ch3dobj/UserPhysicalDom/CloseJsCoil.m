%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef CloseJsCoil < CloseCoil
    properties
        js
    end

    % --- Contructor
    methods
        function obj = CloseJsCoil(args)
            obj = obj@CloseCoil(args);
            obj <= args;
            if isnumeric(obj.js)
                obj.js = Parameter('f',obj.js);
            end
        end
    end
end