%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef CplModelByDDM < CplModel

    properties
        scheme
    end

    % --- Constructor
    methods
        function obj = CplModelByDDM()
            obj = obj@CplModel;
        end
    end

    % --- Methods
    methods
        % ---
        function solve(obj)
            if f_strcmpi(obj.scheme,'s-->l')
                obj.source.solve;
                for i = 1:length(obj.loads)
                    obj.transfer(obj.source,obj.loads{i});
                end
            elseif f_strcmpi(obj.scheme,'s<-->l')
                %while not(obj.convergent)
                    obj.source.solve;
                    for i = 1:length(obj.loads)
                        obj.transfer(obj.source,obj.loads{i});
                        obj.loads{i}.solve;
                        obj.transfer(obj.loads{i},obj.source);
                    end
                %end
            end
        end
    end
    % --- Methods
    methods
        function build_timesystem(obj)
            % ---
            time_system_ = TimeSystem;
            time_system_.ltime.source = obj.source.ltime;
            % ---
            for i = 1:length(obj.loads)
                id_ = ['load_' num2str(i)];
                time_system_.ltime.(id_) = obj.loads{i}.ltime;
            end
            % ---
            obj.time_system = time_system_;
        end
        % ---
        function solve_all(obj)
            obj.build_timesystem;
            obj.time_system.init;
            % ---
            obj.time_system.t_now
            while obj.time_system.t_now < obj.time_system.t_end
                obj.solve;
                obj.time_system.increment;
                obj.time_system.t_now
            end
        end
    end
    % --- Methods
    methods (Abstract)
        transfer(source,load)
    end
end