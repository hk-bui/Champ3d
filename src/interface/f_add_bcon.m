function design3d = f_add_bcon(design3d,varargin)
% F_ADD_BCON ...
%--------------------------------------------------------------------------
% dom3D = F_ADD_BCON(dom3D,'defined_on','face','id_elem',':','bc_type','fixed','bc_value',0);
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'defined_on','id_bcon','id_dom3d','id_elem','bc_type','bc_value',...
           'sigma','mur'};

% --- default input value

id_dom3d = [];
id_elem  = [];
bc_type  = [];
id_bcon  = [];
defined_on = [];
bc_value = 0;
bc_coef  = 0;
sigma    = 0;
mur      = 1;
%--------------------------------------------------------------------------
if ~isfield(design3d,'bcon')
    design3d.bcon = [];
end
%--------------------------------------------------------------------------
if nargin <= 1
    error([mfilename ': No boundary condition to add!']);
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

if isempty(id_bcon)
    error([mfilename ': id_bcon must be defined !'])
end

if isempty(defined_on)
    error([mfilename ': defined_on must be specified !'])
end

if ~isfield(design3d,'dom3d')
    error([mfilename ': dom3d is not defined !']);
end

if isempty(id_dom3d) && isempty(id_elem)
    error([mfilename ': id_dom3d or id_elem must be defined !'])
end

%--------------------------------------------------------------------------
if isempty(bc_type)
    error([mfilename ': bc_type (fixed, neumann, sibc) must be defined !']);
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
% --- Output
design3d.bcon.(id_bcon).id_dom3d = id_dom3d;
design3d.bcon.(id_bcon).bc_type  = bc_type;
design3d.bcon.(id_bcon).bc_value = bc_value;
design3d.bcon.(id_bcon).bc_coef  = bc_coef;
design3d.bcon.(id_bcon).sigma    = sigma;
design3d.bcon.(id_bcon).mur      = mur;
design3d.bcon.(id_bcon).defined_on = defined_on;
design3d.bcon.(id_bcon).id_elem = id_elem;
design3d.bcon.(id_bcon).id_face = id_face;
design3d.bcon.(id_bcon).id_edge = id_edge;
design3d.bcon.(id_bcon).id_node = id_node;
design3d.bcon.(id_bcon).s_face  = s_face;

% --- info message
fprintf(['Add bcon ' id_bcon ' - done \n']);





%%
% if strcmpi(datin.bc_type,'sibc')
%     %----------------------------------------------------------------------
%     [face,id_face_sibc] = f_filterface(dom3d.mesh.face(:,id_face));
%     for i = 1:length(face)
%         id_face_sibc{i} = id_face(id_face_sibc{i});
%     end
%     dom3d.bcon(iec+1).nb_face_type = length(face);
%     %----------------------------------------------------------------------
%     for i = 1:dom3d.bcon(iec+1).nb_face_type
%         [flatnode,flatface] = f_flatface(dom3d.mesh.node,...
%                                          dom3d.mesh.face(:,id_face_sibc{i}));
%         if size(flatface,1) == 3
%             mesh_sibc = f_mdstri(dom3d.mesh.node,flatface);
%             id_ledge = [];
%             id_gedge = [];
%             for j = 1:3
%                 id_ledge = [id_ledge mesh_sibc.edge_in_elem(j,:)];
%                 id_gedge = [id_gedge dom3d.mesh.edge_in_face(j,id_face_sibc{i})];
%             end
%             idgEdge = zeros(1,mesh_sibc.nbEdge);
%             idgEdge(id_ledge) = id_gedge;
%         elseif size(flatface,1) == 4
%             mesh_sibc = f_mdsquad(dom3d.mesh.node,flatface);
%             id_ledge = [];
%             id_gedge = [];
%             for j = 1:4
%                 id_ledge = [id_ledge mesh_sibc.edge_in_elem(j,:)];
%                 id_gedge = [id_gedge dom3d.mesh.edge_in_face(j,id_face_sibc{i})];
%             end
%             idgEdge = zeros(1,mesh_sibc.nbEdge);
%             idgEdge(id_ledge) = id_gedge;
%         end
%         mesh_sibc = f_intkit2d(mesh_sibc,'flatnode',flatnode);
%         mesh_sibc.idgEdge = idgEdge;
%         dom3d.bcon(iec+1).mesh_sibc{i} = mesh_sibc;
%     end
% end




end









