%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef LTime < Xhandle

    % --- Properties
    properties
        id
        % ---
        lit = 1
        ltime_array
    end

    % --- Dependent Properties
    properties (Dependent = true)
        
    end

    % --- Constructors
    methods
        function obj = LTime(args)
            arguments
                args.id
                args.time_array {mustBeNumeric} = []
                args.t0 {mustBeNumeric} = 0
                args.t_end {mustBeNumeric} = 0
                args.dnum {mustBeNumeric} = 1
            end
            obj = obj@Xhandle;
            % ---
            if isempty(args.time_array)
                obj.ltime_array = [args.t0, ...
                    args.t0 + cumsum((args.t_end-args.t0)/args.dnum .* ones(1,args.dnum))];
            else
                obj.ltime_array = args.time_array;
            end
        end
    end

    % --- Methods
    methods (Access = public)
        % ---
        function objx = uplus(obj)
            objx = copy(obj);
        end
        % ---
        function objx = ctranspose(obj)
            objx = copy(obj);
        end
        % ---
    end
end