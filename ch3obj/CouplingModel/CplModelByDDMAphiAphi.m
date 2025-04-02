%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef CplModelByDDMAphiAphi < CplModelByDDM

    properties
        source
        loads
    end

    % --- Constructor
    methods
        function obj = CplModelByDDMAphiAphi(args)
            arguments
                args.source {mustBeA(args.source,'FEM3dAphi')}
                args.loads
                args.scheme {mustBeMember(args.scheme,{'s-->l','s<-->l'})} = 's-->l'
            end
            % ---
            obj = obj@CplModelByDDM;
            % ---
            obj.scheme = args.scheme;
            % ---
            if isfield(args,'source')
                obj.source = args.source;
            end
            % ---
            if isfield(args,'loads')
                if ~iscell(args.loads)
                    if isa(args.loads,'FEM3dAphi')
                        obj.loads{1} = args.loads;
                    end
                else
                    for i = 1:length(args.loads)
                        if isa(args.loads{i},'FEM3dAphi')
                            obj.loads{i} = args.loads{i};
                        end
                    end
                end
            end
            % ---
        end
    end

    % --- Methods / set
    methods
        % ---
        function set.source(obj,smodel)
            arguments
                obj
                smodel {mustBeA(smodel,'FEM3dAphi')}
            end
            obj.source = smodel;
        end
        % ---
        function set.loads(obj,lmodel)
            arguments
                obj
                lmodel = []
            end
            % ---
            if isempty(lmodel)
                f_fprintf(1,'No load added !');
                return
            end
            % ---
            if ~iscell(lmodel)
                if isa(lmodel,'FEM3dAphi')
                    obj.loads{1} = lmodel;
                end
            else
                for i = 1:length(lmodel)
                    if isa(lmodel{i},'FEM3dAphi')
                        obj.loads{i} = lmodel{i};
                    end
                end
            end
            % ---
        end
        % ---
    end
    
    
    
    % --- Methods
    methods
        % ---
        function transfer(obj,smodel,lmodel)
            
        end
        % ---
    end
end