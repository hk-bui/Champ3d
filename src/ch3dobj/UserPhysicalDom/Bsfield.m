%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef Bsfield < PhysicalDom
    properties
        bs
    end

    % --- Contructor
    methods
        function obj = Bsfield(args)
            obj = obj@PhysicalDom(args);
            obj <= args;
            if isnumeric(obj.bs)
                obj.bs = Parameter('f',obj.bs);
            end
        end
    end
end