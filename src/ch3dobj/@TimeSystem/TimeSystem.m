%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef TimeSystem < Xhandle

    % --- Properties
    properties
        git = 1
        gtime
        ltime
    end

    % --- Dependent Properties
    properties (Dependent = true)
        
    end

    % --- Constructors
    methods
        function obj = TimeSystem()
            obj = obj@Xhandle;
            % ---
        end
    end
    % --- Methods
    methods
        function add_ltime(obj,args)
            arguments
                obj
                args.id = 'no_id'
                args.time_array {mustBeNumeric} = []
                args.t0 {mustBeNumeric} = 0
                args.t_end {mustBeNumeric} = 0
                args.dnum {mustBeNumeric} = 1
            end
            % ---
            argu = f_to_namedarg(args);
            % ---
            ltime_ = LTime(argu{:});
            % ---
            obj.ltime.(args.id) = ltime_;
        end
        % -----------------------------------------------------------------
        function increment(obj)
        end
        % -----------------------------------------------------------------
        function setup(obj)
            all_ltime = fieldnames(obj.ltime);
            % ---
            gtime_ = [];
            for i = 1:length(all_ltime)
                gtime_ = [gtime_ obj.ltime.(all_ltime{i}).ltime_array];
            end
            % ---
            gtime_ = sort(unique(gtime_));
            % ---
            obj.gtime = gtime_;
        end
    end
end