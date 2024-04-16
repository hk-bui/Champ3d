%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef Mesh3d < Mesh

    % --- Constructors
    methods
        function obj = Mesh3d()
            obj@Mesh;
            % --- for cartesian/cylindrical
            obj.gcoor.origin = [0 0 0];
            % --- for cylindrical only
            obj.gcoor.otheta = [1 0 0]; % w/ counterclockwise convention
        end
    end

    % --- Methods
    methods
        % ---
        function add_vdom(obj,args)
            arguments
                obj
                % ---
                args.id char
                % ---
                args.id_dom2d = []
                args.id_zline = []
                args.elem_code = []
                args.gid_elem = []
                args.condition char = []
                % ---
                args.id_dom3d = [];
                args.cut_equation = [];
            end
            % ---
            args.parent_mesh = obj;
            % ---
            if isempty(args.id_dom3d) && isempty(args.cut_equation)
                argu = f_to_namedarg(args,'with_only',...
                    {'parent_mesh','id_dom2d','id_zline',...
                     'elem_code','gid_elem','condition'});
                vdom = VolumeDom3d(argu{:});
            else
                argu = f_to_namedarg(args,'with_only',...
                    {'parent_mesh','id_dom3d','cut_equation'});
                vdom = CutVolumeDom3d(argu{:});
            end
            obj.dom.(args.id) = vdom;
            % ---
        end
        % -----------------------------------------------------------------
        function add_sdom(obj,args)
            arguments
                obj
                % ---
                args.id char
                % ---
                args.defined_on char = []
                args.id_dom3d = []
                % ---
                args.elem_code = []
                args.gid_face = []
                args.condition char = []
            end
            % ---
            args.parent_mesh = obj;
            % ---
            argu = f_to_namedarg(args,'with_only',...
                {'parent_mesh','id_dom3d','defined_on',...
                 'gid_face','condition'});
            sdom = SurfaceDom3d(argu{:});
            obj.dom.(args.id) = sdom;
            % ---
        end
    end
    % --- Methods for coordinates
    methods
        % ---
        function gnode_xyz = get_gnode_cartesian(obj)
            % --- lock to gcoor
            if any(obj.gcoor.origin ~= [0 0 0])
                gnode_xyz = obj.node - obj.gcoor.origin.';
            else
                gnode_xyz = obj.node;
            end
            % ---
        end
        % ---
        function gnode_xyz = get_gnode_cylindrical(obj)
            % --- lock to gcoor
            if any(obj.gcoor.origin ~= [0 0 0])
                gnode_xyz = obj.node - obj.gcoor.origin.';
            else
                gnode_xyz = obj.node;
            end
            % ---
            if any(obj.gcoor.otheta ~= [1 0 0])
                otheta0 = [1 0 0];
                otheta1 = obj.gcoor.otheta;
                rot_axis  = cross(otheta0,otheta1);
                rot_angle = acosd(dot(otheta0,otheta1)/(norm(otheta0)*norm(otheta1)));
                % ---
                gnode_xyz = f_rotaroundaxis(gnode_xyz.','rot_axis',rot_axis,'angle',rot_angle);
                % ---
                gnode_xyz = gnode_xyz.';
            end
            % ---
        end
    end
end




