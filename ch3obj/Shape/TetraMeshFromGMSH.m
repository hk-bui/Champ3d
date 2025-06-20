%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2025
% as a contribution to Champ3d code.
%--------------------------------------------------------------------------
% Champ3d is copyright (c) 2023-2025 H-K. Bui.
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% See LICENSE and CREDITS files for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef TetraMeshFromGMSH < TetraMesh
    properties
        physical_volume = []
        mesh_file = ''
    end
    properties (Access = private)
        build_from
    end
    % --- Constructors
    methods
        function obj = TetraMeshFromGMSH(args)
            arguments
                args.physical_volume {mustBeA(args.physical_volume,'PhysicalVolume')}
                args.mesh_file char = ''
            end
            % ---
            obj = obj@TetraMesh;
            % ---
            if isempty(fieldnames(args))
                return
            end
            % ---
            if isfield(args,'physical_volume')
                args.physical_volume = f_to_scellargin(args.physical_volume);
                obj.build_from = 'physical_volume';
            else
                args.physical_volume = [];
                obj.build_from = 'mesh_file';
            end
            % ---
            obj <= args;
            % ---
            TetraMeshFromGMSH.setup(obj);
            % ---
        end
    end
    % --- setup/reset
    methods (Static)
        function setup(obj)
            % ---
            if strcmpi(obj.build_from,'mesh_file')
                mesh_file_ = which(obj.mesh_file);
                if isfile(mesh_file_)
                    if contains(mesh_file_,'.m')
                        % ---
                        run(mesh_file_);
                        % ---
                        node_ = msh.POS.';
                        elem_ = msh.TETS(:,1:4).';
                        elem_code_ = f_torowv(msh.TETS(:,5));
                        %--------------------------------------------------------------
                        nb_elem = length(elem_code_);
                        celem_ = mean(reshape(node_(:,elem_(1:4,:)),3,4,nb_elem),2);
                        celem_ = squeeze(celem_);
                        %--------------------------------------------------------------
                        face_ = f_face(elem_,'elem_type','tetra');
                        nb_face = size(face_,2);
                        cface_ = mean(reshape(node_(:,face_(1:3,:)),3,3,nb_face),2);
                        cface_ = squeeze(cface_);
                        %--------------------------------------------------------------
                        edge_ = f_edge(elem_,'elem_type','tetra');
                        nb_edge = size(edge_,2);
                        cedge_ = mean(reshape(node_(:,edge_(1:2,:)),3,2,nb_edge),2);
                        cedge_ = squeeze(cedge_);
                        %--------------------------------------------------------------
                        obj.node = node_;
                        obj.elem = elem_;
                        obj.elem_code = elem_code_;
                        obj.edge = edge_;
                        obj.face = face_;
                        obj.celem = celem_;
                        obj.cedge = cedge_;
                        obj.cface = cface_;
                        % ---
                        obj.velem = f_volume(node_,elem_,'elem_type',obj.elem_type);
                        obj.sface = f_area(node_,face_);
                        obj.ledge = f_ledge(node_,edge_);
                        % ---
                    else
                        f_fprintf(1,'/!\\',0,'Only .m mesh file is acceptable !\n');
                        error(['Can not run #mesh_file ' obj.mesh_file]);
                    end
                else
                    error(['#mesh_file ' obj.mesh_file ' not found !']);
                end
                % ---
                return
            end
            % ---
            if strcmpi(obj.build_from,'physical_volume')
                % ---
                if isempty(obj.mesh_file)
                    obj.mesh_file = [f_uqid() '.m'];
                end
                % ---
                obj.physical_volume = f_to_scellargin(obj.physical_volume);
                % ---
                for i = 1:length(obj.physical_volume)
                    phyvol = obj.physical_volume{i};
                    id_phyvol = f_str2code(phyvol.id,'code_type','integer');
                    
                end
            end
        end
    end
    methods (Access = public)
        function reset(obj)
            TetraMeshFromGMSH.setup(obj);
            % --- reset dependent obj
            obj.reset_dependent_obj;
        end
    end
    % --- Methods
    methods
        %------------------------------------------------------------------
        function build(obj)

        end
        %------------------------------------------------------------------
        %------------------------------------------------------------------
    end
end