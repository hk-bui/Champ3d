%function mesh3d = f_intkit3d_3(mesh3d,varargin)


clear
clc

%load data_test_light.mat
%load data_test_medium.mat
load data_test_dense.mat

mesh3d = mesh;


% F_INTKIT3D gives the integral kit.
%--------------------------------------------------------------------------
% FIXED INPUT
% mesh3d : mesh data structure
%--------------------------------------------------------------------------
% OPTIONAL INPUT
%--------------------------------------------------------------------------
% OUTPUT
% mesh3d : mesh data structure with kit added
%--------------------------------------------------------------------------
% EXAMPLE
% mesh3d = F_INTKIT3D(mesh3d);
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
%arglist = {'get'};

% --- default input value
get = '_all';

% --- check and update input
% for i = 1:length(varargin)/2
%     if any(strcmpi(arglist,varargin{2*i-1}))
%         eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
%     else
%         error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
%     end
% end
%--------------------------------------------------------------------------
if ~isfield(mesh3d,'node') || ~isfield(mesh3d,'elem')
    error([mfilename ' : #mesh3d struct must contain at least .node and .elem']);
end
%--------------------------------------------------------------------------
node = mesh3d.node;
elem = mesh3d.elem;
%--------------------------------------------------------------------------
if isfield(mesh3d,'elem_type')
    elem_type = mesh3d.elem_type;
else
    elem_type = f_elemtype(elem,'defined_on','elem');
end
%--------------------------------------------------------------------------
if isfield(mesh3d,'ori_edge_in_elem')
    ori_edge_in_elem = mesh3d.ori_edge_in_elem;
else
    [~, ori_edge_in_elem, ~] = ...
        f_edgeinelem(elem,[],'elem_type',elem_type,'get','ori');
end
%--------------------------------------------------------------------------
if isfield(mesh3d,'ori_face_in_elem')
    ori_face_in_elem = mesh3d.ori_face_in_elem;
else
    [~, ori_face_in_elem, ~] = ...
        f_faceinelem(elem,node,[],'elem_type',elem_type,'get','ori');
end
%--------------------------------------------------------------------------
con = f_connexion(elem_type);
nbNo_inEl = con.nbNo_inEl;
nbG = con.nbG;
U = con.U;
V = con.V;
W = con.W;
Weigh = con.Weigh;
cU = con.cU;
cV = con.cV;
cW = con.cW;
cWeigh = con.cWeigh;
fN = con.N;
fgradNx = con.gradNx;
fgradNy = con.gradNy;
fgradNz = con.gradNz;
EdNo_inEl = con.EdNo_inEl;
NoFa_ofEd = con.NoFa_ofEd;
FaNo_inEl = con.FaNo_inEl;
NoFa_ofFa = con.NoFa_ofFa;
nbFa_inEl = con.nbFa_inEl;
nbEd_inEl = con.nbEd_inEl;

%--------------------------------------------------------------------------
%---------------- Jacobien ------------------------------------------------

nb_elem = size(elem,2);
%--------------------------------------------------------------------------
x = permute(reshape(node(1,elem(:,:)),nbNo_inEl,nb_elem),[2 1]);
y = permute(reshape(node(2,elem(:,:)),nbNo_inEl,nb_elem),[2 1]);
z = permute(reshape(node(3,elem(:,:)),nbNo_inEl,nb_elem),[2 1]);
%--------------------------------------------------------------------------


%                        Center


%--------------------------------------------------------------------------
u = cU.*ones(1,nb_elem);
v = cV.*ones(1,nb_elem);
w = cW.*ones(1,nb_elem);
%--------------------------------------------------------------------------
gradNx = fgradNx(u,v,w); gradNx = gradNx.';
gradNy = fgradNy(u,v,w); gradNy = gradNy.';
gradNz = fgradNz(u,v,w); gradNz = gradNz.';

J11 = sum(gradNx.*x,2);
J12 = sum(gradNx.*y,2);
J13 = sum(gradNx.*z,2);

J21 = sum(gradNy.*x,2);
J22 = sum(gradNy.*y,2);
J23 = sum(gradNy.*z,2);

J31 = sum(gradNz.*x,2);
J32 = sum(gradNz.*y,2);
J33 = sum(gradNz.*z,2);

A11 = J22.*J33 - J23.*J32;
A12 = J32.*J13 - J12.*J33;
A13 = J12.*J23 - J13.*J22;
A21 = J23.*J31 - J21.*J33;
A22 = J33.*J11 - J31.*J13;
A23 = J13.*J21 - J23.*J11;
A31 = J21.*J32 - J31.*J22;
A32 = J31.*J12 - J32.*J11;
A33 = J11.*J22 - J12.*J21;

detJ = J11.*J22.*J33 + J21.*J32.*J13 + J31.*J12.*J23 - ...
       J11.*J32.*J23 - J31.*J22.*J13 - J21.*J12.*J33;

% Jinv(1,1,:) = 1./detJ.*A11;
% Jinv(1,2,:) = 1./detJ.*A12;
% Jinv(1,3,:) = 1./detJ.*A13;
% Jinv(2,1,:) = 1./detJ.*A21;
% Jinv(2,2,:) = 1./detJ.*A22;
% Jinv(2,3,:) = 1./detJ.*A23;
% Jinv(3,1,:) = 1./detJ.*A31;
% Jinv(3,2,:) = 1./detJ.*A32;
% Jinv(3,3,:) = 1./detJ.*A33;

Jinv = zeros(nb_elem,3,3);
Jinv(:,1,1) = 1./detJ.*A11;
Jinv(:,1,2) = 1./detJ.*A12;
Jinv(:,1,3) = 1./detJ.*A13;
Jinv(:,2,1) = 1./detJ.*A21;
Jinv(:,2,2) = 1./detJ.*A22;
Jinv(:,2,3) = 1./detJ.*A23;
Jinv(:,3,1) = 1./detJ.*A31;
Jinv(:,3,2) = 1./detJ.*A32;
Jinv(:,3,3) = 1./detJ.*A33;

%--------------------------------------------------------------------------
Wn = zeros(nb_elem,nbNo_inEl);
for j = 1:length(con.N)
    Wn(:,j) = fN{j}(u,v,w);
end

%--------------------------------------------------------------------------
% volume = 0;
% for i = 1:nbNo_inEl
%     volume = volume + cWeigh .* detJ .* Wn(i,:);
% end

%--------------------------------------------------------------------------
gradWn = zeros(nb_elem,3,nbNo_inEl);
Jinv1 = [Jinv(:,1,1), Jinv(:,1,2), Jinv(:,1,3)];
Jinv2 = [Jinv(:,2,1), Jinv(:,2,2), Jinv(:,2,3)];
Jinv3 = [Jinv(:,3,1), Jinv(:,3,2), Jinv(:,3,3)];
for j = 1:nbNo_inEl
    gradNxyz = [gradNx(:,j), gradNy(:,j), gradNz(:,j)];
    gradWn(:,1,j) = dot(Jinv1, gradNxyz, 2);
    gradWn(:,2,j) = dot(Jinv2, gradNxyz, 2);
    gradWn(:,3,j) = dot(Jinv3, gradNxyz, 2);
end
%--------------------------------------------------------------------------
gradF = zeros(nb_elem,3,nbFa_inEl); % 3 for x,y,z
for j = 1:nbFa_inEl
    nbN = length(find(FaNo_inEl(j,:)));
    gradF(:,:,j) = sum(gradWn(:,:,FaNo_inEl(j,1:nbN)),3);
end
%--------------------------------------------------------------------------
We = zeros(nb_elem,3,nbEd_inEl);
for j = 1:nbEd_inEl
    We(:,:,j) = - (Wn(:,EdNo_inEl(j,1)).*gradF(:,:,NoFa_ofEd(j,1)) - ...
                   Wn(:,EdNo_inEl(j,2)).*gradF(:,:,NoFa_ofEd(j,2)))...
                   .*ori_edge_in_elem(j,:).';
end
%--------------------------------------------------------------------------
nbNodemax = max(con.nbNo_inFa);
for j = 1:nbNodemax
    gradFxgradF{j} = zeros(nb_elem,3,nbFa_inEl);
end
for j = 1:con.nbFa_inEl
    for k = 1:con.nbNo_inFa(j)
        knext = mod(k + 1,con.nbNo_inFa(j));
        if knext == 0
            knext = con.nbNo_inFa(j);
        end
        %-----
        gradFk = gradF(:,:,NoFa_ofFa(j,k));
        gradFknext = gradF(:,:,NoFa_ofFa(j,knext));
        %-----
        gradFxgradF{k}(:,:,j) = cross(gradFk,gradFknext,2);
    end
end
%--------------------------------------------------------------------------
Wf = zeros(nb_elem,3,nbFa_inEl);
for j = 1:con.nbFa_inEl
    Wfxyz = zeros(nb_elem,3);
    for k = 1:con.nbNo_inFa(j)
        Wfxyz = Wfxyz + ...
                Wn(:,FaNo_inEl(j,k)).*gradFxgradF{k}(:,:,j);
    end
    Wf(:,:,j) = (5 - con.nbNo_inFa(j)) .* Wfxyz .* ori_face_in_elem(j,:).';
end
%--------------------------------------------------------------------------