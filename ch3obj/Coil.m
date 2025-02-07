%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef Coil < PhysicalDom
    
    % --- Valid args list
    methods (Static)
        function argslist = validargs(fname)
            if nargin < 1
                argslist = {'parent_model','id_dom2d','id_dom3d'};
            elseif ischar(fname)
                if f_strcmpi(fname,'plot')
                    argslist = {'edge_color','face_color','alpha'};
                end
            end
        end
    end
    % --- Contructor
    methods
        function obj = Coil(args)
            arguments
                args.parent_model
                args.id_dom2d
                args.id_dom3d
            end
            % ---
            obj@PhysicalDom;
            % ---
            if isempty(fieldnames(args))
                return
            end
            % ---
            obj <= args;
            % ---
            obj.setup;
        end
    end
    
    % --- setup
    methods
        function setup(obj)
            setup@PhysicalDom(obj);
        end
    end

end