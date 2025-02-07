%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef TimeVaryingModel < Xhandle

    % --- Properties
    properties
        model
        time_system
    end

    % --- Constructors
    methods
        function obj = TimeVaryingModel(model)
            obj = obj@Xhandle;
            % ---
            if nargin > 0
                if iscell(model)
                    model = f_to_scellargin(model);
                    for i = 1:length(model)
                        mname = ['model_' num2str(i)];
                        obj.model.(mname) = model{i};
                    end
                else
                    obj.model.mymodel = model;
                end
            end
        end
    end

    % --- Methods
    methods
        function add_model(obj,args)
            arguments
                obj
                args.id
                args.model
            end
            % ---
            if ~isempty(args)
                if ~isempty(args.id) && ~isempty(args.model)
                    obj.model.(args.id) = args.model;
                end
            end
        end
        % ---
    end

    % --- Methods
    methods
        function build_timesystem(obj)
            % ---
            time_system_ = TimeSystem;
            model_ = fieldnames(obj.model);
            % ---
            for i = 1:length(model_)
                id_ = model_{i};
                ltime_ = obj.model.(model_{i}).ltime;
                time_system_.ltime.(id_) = ltime_;
            end
            % ---
            obj.time_system = time_system_;
        end
        % -----------------------------------------------------------------
        function solve(obj)
            obj.build_timesystem;
            obj.time_system.init;
            % ---
            idmodel = fieldnames(obj.model);
            % ---
            while obj.time_system.gtime_now <= obj.time_system.gt_end
                for i = 1:length(idmodel)
                    obj.model.(idmodel{i}).solve;
                end
                obj.time_system.increment;
            end
        end
    end
end