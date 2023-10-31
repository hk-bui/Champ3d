function mesh3d = f_mdshexa(node,elem,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------
if nargin > 2
    for i = 1:nargin-2
        datin.(lower(varargin{i})) = 1;
    end
else
    datin.full = 1;
end
%--------------------------------------------------------------------------
con       = f_connexion('hex');
nbNo_inEl = con.nbNo_inEl;
nbNo_inEd = con.nbNo_inEd;
nbNo_inFa = con.nbNo_inFa;
nbEd_inFa = con.nbEd_inFa;
nbEd_inEl = con.nbEd_inEl;
nbFa_inEl = con.nbFa_inEl;
EdNo_inEl = con.EdNo_inEl;
siNo_inEd = con.siNo_inEd;
FaNo_inEl = con.FaNo_inEl;
EdNo_inFa = con.EdNo_inFa;
FaEd_inEl = con.FaEd_inEl;
siFa_inEl = con.siFa_inEl;
siEd_inFa = con.siEd_inFa;

%--------------------------------------------------------------------------
nbNode = size(node,2);
nbElem = size(elem,2);
%--------------------------------------------------------------------------
mesh3d.elem_type = 'hex';
mesh3d.node   = node;
mesh3d.elem   = elem;
mesh3d.nbNode = nbNode;
mesh3d.nbElem = nbElem;

%----- barrycenter
mesh3d.cnode(1,:) = mean(reshape(mesh3d.node(1,mesh3d.elem(1:nbNo_inEl,:)),nbNo_inEl,nbElem));
mesh3d.cnode(2,:) = mean(reshape(mesh3d.node(2,mesh3d.elem(1:nbNo_inEl,:)),nbNo_inEl,nbElem));
mesh3d.cnode(3,:) = mean(reshape(mesh3d.node(3,mesh3d.elem(1:nbNo_inEl,:)),nbNo_inEl,nbElem));

%% EDGE
%----- edges
e = reshape([elem(EdNo_inEl(:,1),:); elem(EdNo_inEl(:,2),:)], ...
              nbEd_inEl, nbNo_inEd, nbElem);
real_ori_edge_in_elem = squeeze(sign(diff(e, 1, 2)));
e = sort(e, 2);
%--------------------------------------------------------------------------
edge = reshape(permute(e,[2 1 3]), nbNo_inEd, []);
edge = f_unique(edge);
nbEdge = length(edge(1,:));
%--------------------------------------------------------------------------
edge_in_elem = f_findvecnd(e,edge,'position',2);
%--------------------------------------------------------------------------

%% FACE
%----- faces
maxnbNo_inFa = max(nbNo_inFa);
f = zeros(nbFa_inEl,maxnbNo_inFa,nbElem);
si_face_in_elem = zeros(nbFa_inEl,nbElem);
%---
celem = mean(reshape(node(:,elem(1:nbNo_inEl,:)),3,nbNo_inEl,nbElem),2);
celem = squeeze(celem);
%--------------------------------------------------------------------------
for i = 1:nbFa_inEl
    ft = elem(FaNo_inEl(i,:),:);
    % ---
    [ft,si_ori] = f_sortori(ft);
    ft = [ft; zeros(maxnbNo_inFa-nbNo_inFa(i),nbElem)];
    f(i,:,:) = ft;
    % ---
    cface = mean(reshape(node(1:3,ft(1:nbNo_inFa(i),:)),3,nbNo_inFa(i),[]),2);
    cface = squeeze(cface);
    % ---
    si_face_in_elem(i,:) = sign(dot(cface-celem,f_chavec(node,ft,'face')));
    real_ori_face_in_elem(i,:) = si_ori;
end
%--------------------------------------------------------------------------
face = reshape(permute(f,[2 3 1]), maxnbNo_inFa, []);
face = f_unique(face);
nbFace = length(face(1,:));
%--------------------------------------------------------------------------
face_in_elem = f_findvecnd(f,face,'position',2);
%--------------------------------------------------------------------------
%----- face_edge
maxnbEd_inFa = max(cell2mat(nbEd_inFa));
fe = zeros(maxnbEd_inFa,nbNo_inEd,nbFace);
si_edge_in_face = zeros(maxnbEd_inFa,nbFace);

itria = find(face(4,:) == 0);
iquad = setdiff(1:nbFace,itria);

for k = 1:2 %---- 2 faceType
    switch k
        case 1
            iface = itria;
        case 2
            iface = iquad;
    end
    for i = 1:nbEd_inFa{k}
        fet = [];
        for j = 1:nbNo_inEd
            fet = [fet; face(EdNo_inFa{k}(i,j),iface)];
        end
        fe(i,:,iface) = fet;
        si_edge_in_face(i,iface) = siEd_inFa{k}(i) .* sign(fet(2,:)-fet(1,:));
    end
end
%--------------------------------------------------------------------------
edge_in_face = f_findvecnd(fe,edge,'position',2);
edge_in_face(isnan(edge_in_face)) = 0;

%% D, R, G
%----- D
D = sparse(nbElem,nbFace);
for i = 1:nbFa_inEl
    D = D + sparse(1:nbElem,face_in_elem(i,:),si_face_in_elem(i,:),nbElem,nbFace);
end

%----- R
itria = find(face(4,:) == 0);
iquad = setdiff(1:nbFace,itria);

R = sparse(nbFace,nbEdge);
for k = 1:2 %---- 2 faceType
    switch k
        case 1
            iface = itria;
        case 2
            iface = iquad;
    end
    for i = 1:nbEd_inFa{k}
        R = R + sparse(iface,edge_in_face(i,iface),si_edge_in_face(i,iface),nbFace,nbEdge);
    end
end

%----- G
G = sparse(nbEdge,nbNode);
for i = 1:nbNo_inEd
    G = G + sparse(1:nbEdge,edge(i,:),siNo_inEd(i),nbEdge,nbNode);
end





mesh3d.edge = edge;
mesh3d.real_ori_edge_in_elem = real_ori_edge_in_elem;
mesh3d.edge_in_elem = edge_in_elem;
mesh3d.nbEdge = nbEdge;
mesh3d.face = face;
mesh3d.face_in_elem = face_in_elem;
mesh3d.si_face_in_elem = si_face_in_elem;
mesh3d.real_ori_face_in_elem = real_ori_face_in_elem;
mesh3d.nbFace = nbFace;
mesh3d.edge_in_face = edge_in_face;
mesh3d.si_edge_in_face = si_edge_in_face;
mesh3d.D = D;
mesh3d.R = R;
mesh3d.G = G;





end