%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef PhysicalDom < Xhandle
    properties
        parent_mesh
        mesh2d_collection
        id_mesh2d
        dom2d_collection
        id_dom2d
        mesh3d_collection
        id_mesh3d
        dom3d_collection
        id_dom3d
        % ---
        to_be_rebuild
    end

    % --- Methods
    methods
        function coef_array = call_coefficient(obj,args)
            arguments
                obj
                % ---
                args.coef_name = []
            end
        end
    end
end