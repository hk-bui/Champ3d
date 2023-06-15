function mesh3d = f_get_face(mesh3d,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'elem_type'};

% --- default input value
elem_type = [];

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
if isempty(elem_type) && isfield(mesh3d,'elem_type')
    elem_type = mesh3d.elem_type;
end
%--------------------------------------------------------------------------
if isempty(elem_type)
    nbnoinel = size(mesh3d.elem, 1);
    switch nbnoinel
        case 4
            elem_type = 'tet';
        case 6
            elem_type = 'prism';
        case 8
            elem_type = 'hex';
    end
    fprintf(['Build meshds for ' elem_type ' \n']);
end
%--------------------------------------------------------------------------
if isempty(elem_type)
    error([mfilename ' : #elem_type must be given !']);
end
%--------------------------------------------------------------------------
con = f_connexion(elem_type);
nbNo_inEl = con.nbNo_inEl;
nbNo_inFa = con.nbNo_inFa;
nbFa_inEl = con.nbFa_inEl;
FaNo_inEl = con.FaNo_inEl;
siEd_inFa = con.siEd_inFa;
EdNo_inFa = con.EdNo_inFa;
nbEd_inFa = con.nbEd_inFa;
nbNo_inEd = con.nbNo_inEd;

%--------------------------------------------------------------------------
node = mesh3d.node;
elem = mesh3d.elem;
nbElem = size(elem,2);
%--------------------------------------------------------------------------
maxnbNo_inFa = max(nbNo_inFa);
f = zeros(nbFa_inEl,maxnbNo_inFa,nbElem);
si_face_in_elem = zeros(nbFa_inEl,nbElem);
real_ori_face_in_elem = zeros(nbFa_inEl,nbElem);
%---
celem = mean(reshape(node(:,elem(1:nbNo_inEl,:)),3,nbNo_inEl,nbElem),2);
celem = squeeze(celem);
%--------------------------------------------------------------------------
for i = 1:nbFa_inEl
    ft = elem(FaNo_inEl(i,1:nbNo_inFa(i)),:);
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
edge_in_face = [];
if isfield(mesh3d,'edge')
    edge_in_face = f_findvecnd(fe,mesh3d.edge,'position',2);
    edge_in_face(isnan(edge_in_face)) = 0;
end
%--------------------------------------------------------------------------
% --- Outputs
mesh3d.face = face;
mesh3d.face_in_elem = face_in_elem;
mesh3d.si_face_in_elem = si_face_in_elem;
mesh3d.real_ori_face_in_elem = real_ori_face_in_elem;
mesh3d.nbFace = nbFace;
mesh3d.edge_in_face = edge_in_face;
mesh3d.si_edge_in_face = si_edge_in_face;

end