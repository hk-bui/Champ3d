%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef PhysicalModel < Xhandle
    properties
        ltime
        moving_frame
        matrix
        fields
        dof
    end
    
    % --- Valid args list
    methods (Static)
        function argslist = validargs()
            argslist = {};
        end
    end
    % --- Constructor
    methods
        function obj = PhysicalModel()
            % ---
            obj@Xhandle;
            % ---
            obj.ltime = LTime;
        end
    end
    % --- Methods
    methods
        function solve_all(obj)
            timemodel = TimeVaryingModel(obj);
            timemodel.solve;
        end
    end
end