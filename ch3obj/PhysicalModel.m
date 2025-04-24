%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef PhysicalModel < Xhandle
    % --- computed
    properties
        matrix
        field
        dof
    end
    % --- subfields to build
    properties
        parent_mesh
        ltime
        moving_frame
    end

    % --- Constructor
    methods
        function obj = PhysicalModel()
            % ---
            obj@Xhandle;
            % --- initializations
            obj.ltime = LTime;
        end
    end
    % --- Utility Methods
    methods
        function build(obj)
            obj.parent_mesh.build;
        end
    end
end