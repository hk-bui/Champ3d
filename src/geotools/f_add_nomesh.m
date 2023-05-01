function design3d = f_add_nomesh(design3d,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'design3d','id_dom3d','id_elem','id_nomesh'};

% --- default input value
id_nomesh = [];
id_dom3d = [];
id_elem  = [];
%--------------------------------------------------------------------------
if ~isfield(design3d,'mconductor')
    design3d.mconductor = [];
end
%--------------------------------------------------------------------------
if nargin <= 1
    error('No no-mesh to add!');
end
%--------------------------------------------------------------------------
% --- check and update input
for i = 1:(nargin-1)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': Check function arguments : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------

if isempty(id_nomesh)
    error([mfilename ': id_nomesh must be defined !'])
end

if ~isfield(design3d,'dom3d')
    error([mfilename ': dom3d is not defined !']);
end

if isempty(id_dom3d) && isempty(id_elem)
    error([mfilename ': id_dom3d or id_elem must be defined !'])
end

%--------------------------------------------------------------------------
if ~isempty(id_dom3d)
    id_elem = design3d.dom3d.(id_dom3d).id_elem;
end
%--------------------------------------------------------------------------
bcmesh = f_make_mds(design3d.mesh.node,...
                    design3d.mesh.elem(:,id_elem),...
                    design3d.mesh.elem_type);
% ---
con = f_connexion(design3d.mesh.elem_type);
nbNo_inFa_max = max(con.nbNo_inFa);
id_face = f_findvec(bcmesh.bound(1:nbNo_inFa_max,:),...
                    design3d.mesh.face(1:nbNo_inFa_max,:));
s_face  = f_measure(design3d.mesh.node,design3d.mesh.face(:,id_face),'face');
%--------------------------------------------------------------------------
nbEd_inFa_max = 0;
for i = 1:length(con.nbEd_inFa)
    nbEd_inFa_max = max([nbEd_inFa_max con.nbEd_inFa{i}]);
end
%--------------------------------------------------------------------------
id_edge = reshape(design3d.mesh.edge_in_face(1:nbEd_inFa_max,id_face),...
                  1,nbEd_inFa_max*length(id_face));
id_edge = unique(id_edge);
id_edge(id_edge == 0) = [];
%--------------------------------------------------------------------------
id_node = reshape(design3d.mesh.edge(1:2,id_edge),...
                  1,2*length(id_edge));
id_node = unique(id_node);
id_node(id_node == 0) = [];
%--------------------------------------------------------------------------
all_edge = design3d.mesh.edge_in_elem(1:con.nbEd_inEl,id_elem);
id_inside_edge = setdiff(all_edge, id_edge);
id_inside_edge = unique(id_inside_edge);
id_inside_edge(id_inside_edge == 0) = [];
%--------------------------------------------------------------------------
% --- Output
design3d.nomesh.(id_nomesh).id_dom3d = id_dom3d;
design3d.nomesh.(id_nomesh).id_elem  = id_elem;
design3d.nomesh.(id_nomesh).id_face  = id_face;
design3d.nomesh.(id_nomesh).id_edge  = id_edge;
design3d.nomesh.(id_nomesh).id_node  = id_node;
design3d.nomesh.(id_nomesh).s_face   = s_face;
design3d.nomesh.(id_nomesh).id_inside_edge = id_inside_edge;
% --- info message
fprintf(['Add nomesh ' id_nomesh '\n']);
