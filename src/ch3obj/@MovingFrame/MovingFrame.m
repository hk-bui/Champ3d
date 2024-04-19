%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef MovingFrame < Xhandle
    
    properties
        lin_step
        rot_origin    % rot around o-->axis
        rot_axis      % rot around o-->axis
        rot_angle     % deg, counterclockwise convention
    end

    % --- Contructor
    methods
        function obj = MovingFrame(args)
            arguments
                args.lin_step = []
                args.rot_origin = []
                args.rot_axis = []
                args.rot_angle = []
            end
            % ---
            obj <= args;
            % ---
        end
    end

    % --- Methods
    methods

    end

end