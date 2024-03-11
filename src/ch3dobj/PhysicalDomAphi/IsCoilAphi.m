%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef IsCoilAphi < Xhandle

    % --- computed
    properties (Access = private)
        setup_done = 0
        build_done = 0
    end
    
    % --- Contructor
    methods
        function obj = IsCoilAphi()
            obj@Xhandle;
        end
    end

    % --- setup
    methods
        function setup(obj)
            if obj.setup_done
                return
            end
            % ---
            obj.setup_done = 1;
        end
    end

    % --- build
    methods
        function build(obj)
            % ---
            dom = obj.dom;
            obj.matrix.i_coil = obj.i_coil.get_on(dom);
            % ---
        end
    end

    % --- assembly
    methods
        function assembly(obj)

        end
    end
end