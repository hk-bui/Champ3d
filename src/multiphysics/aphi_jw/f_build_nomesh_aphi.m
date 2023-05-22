function design3d = f_build_nomesh_aphi(design3d,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
id_mesh3d = c3dobj.design3d.(id_design3d).id_mesh3d;
nomesh    = c3dobj.mesh3d.(id_mesh3d);
id_elem   = c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d).id_elem;
%--------------------------------------------------------------------------
bcmesh = f_make_mds(nomesh.node,...
                    nomesh.elem(:,id_elem),...
                    nomesh.elem_type);
% ---
con = f_connexion(nomesh.elem_type);
nbNo_inFa_max = max(con.nbNo_inFa);
id_face = f_findvec(bcmesh.bound(1:nbNo_inFa_max,:),...
                    nomesh.face(1:nbNo_inFa_max,:));
s_face  = f_measure(nomesh.node,nomesh.face(:,id_face),'face');
%--------------------------------------------------------------------------
nbEd_inFa_max = 0;
for i = 1:length(con.nbEd_inFa)
    nbEd_inFa_max = max([nbEd_inFa_max con.nbEd_inFa{i}]);
end
%--------------------------------------------------------------------------
id_edge = reshape(nomesh.edge_in_face(1:nbEd_inFa_max,id_face),...
                  1,nbEd_inFa_max*length(id_face));
id_edge = unique(id_edge);
id_edge(id_edge == 0) = [];
%--------------------------------------------------------------------------
id_node = reshape(nomesh.edge(1:2,id_edge),...
                  1,2*length(id_edge));
id_node = unique(id_node);
id_node(id_node == 0) = [];
%--------------------------------------------------------------------------
all_edge = nomesh.edge_in_elem(1:con.nbEd_inEl,id_elem);
id_inside_edge = setdiff(all_edge, id_edge);
id_inside_edge = unique(id_inside_edge);
id_inside_edge(id_inside_edge == 0) = [];
%--------------------------------------------------------------------------
% --- Output
c3dobj.nomesh.(id_nomesh).id_dom3d = id_dom3d;
c3dobj.nomesh.(id_nomesh).id_elem  = id_elem;
c3dobj.nomesh.(id_nomesh).id_face  = id_face;
c3dobj.nomesh.(id_nomesh).id_edge  = id_edge;
c3dobj.nomesh.(id_nomesh).id_node  = id_node;
c3dobj.nomesh.(id_nomesh).s_face   = s_face;
c3dobj.nomesh.(id_nomesh).id_inside_edge = id_inside_edge;
%--------------------------------------------------------------------------
if isfield(design3d,'nomesh')
    nb_nomesh = length(design3d.nomesh);
    for i = 1:nb_nomesh
        design3d.aphi.id_edge_a = unique(setdiff(...
            design3d.aphi.id_edge_a,design3d.nomesh(i).id_inside_edge));
    end
end


