%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef CloseJsCoil < CloseCoil
    properties
        js
        nb_turn = 1
        cs_area = 1
    end

    % --- Contructor
    methods
        function obj = CloseJsCoil(args)
            obj = obj@CloseCoil(args);
            obj <= args;
            % ---
            if isnumeric(obj.js)
                obj.js = Parameter('f',obj.js);
            end
            if ~isnumeric(obj.nb_turn)
                obj.nb_turn = 1;
            end
            if ~isnumeric(obj.cs_area)
                obj.cs_area = 1;
            end
        end
    end
    
    methods
        function plotjv(obj,args)
            arguments
                obj
                args.show_dom = 1
                args.field_name = []
            end
            % ---
            if args.show_dom
                obj.plot('alpha',0.5,'edge_color',[0.9 0.9 0.9],'face_color','none')
            end
            % ---
            if isa(obj.dom,'VolumeDom3d')
                id_elem = obj.dom.gid_elem;
                fv = obj.parent_model.matrix.js(:,id_elem);
                no = obj.parent_model.parent_mesh.celem(:,id_elem);
                if isreal(fv)
                    f_quiver(no,fv);
                else
                    subplot(121);
                    f_quiver(no,real(fv)); title('Real part')
                    subplot(122);
                    f_quiver(no,imag(fv)); title('Imag part')
                end
            end
        end
        % -----------------------------------------------------------------
    end
end