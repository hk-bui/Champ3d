%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2025
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef BHSingleCurve < Xhandle
    properties
        b
        h
        % --- added for interpolation
        hlarge = 200e3
        % --- Steinmetz coef in harmonic
        alpha
        beta
        k
        % ---
        fBH
    end
    properties (Hidden)
        

    end
    % --- Constructor
    methods
        function obj = BHSingleCurve(args)
            arguments
                args.b
                args.h
                args.alpha = 0
                args.beta = 0
                args.k = 0
            end
            % ---
            obj@Xhandle;
            % ---
            obj <= args;
            % ---
        end
    end
    % --- Methods/public
    methods (Access = public)
    end
end