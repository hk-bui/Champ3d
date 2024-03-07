%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef StrandedCoil < Coil
    properties
        cs_area
        nb_turn
        fill_factor
    end

    % --- Contructor
    methods
        function obj = StrandedCoil(args)
            obj = obj@Coil(args);
            obj <= args;
        end
    end

    % --- Methods

end