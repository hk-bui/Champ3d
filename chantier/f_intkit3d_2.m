function mesh = f_intkit3d_2(mesh,varargin)
% F_INTKIT3D gives the integral kit.
%--------------------------------------------------------------------------
% FIXED INPUT
% mesh : mesh data structure
%--------------------------------------------------------------------------
% OPTIONAL INPUT
%--------------------------------------------------------------------------
% OUTPUT
% mesh : mesh data structure with kit added
%--------------------------------------------------------------------------
% EXAMPLE
% mesh = F_INTKIT3D(mesh);
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'id_mesh3d','id_dom3d',...
           'id_emdesign3d','id_thdesign3d', ...
           'id_econductor','id_mconducteur','id_coil','id_bc','id_nomesh',...
           'id_bsfield','id_pmagnet',...
           'id_tconductor','id_tcapacitor'};

% --- default input value
id_mesh3d  = [];
id_dom3d   = [];
id_emdesign3d  = [];
id_thdesign3d  = [];
id_econductor  = [];
id_mconducteur = [];
id_coil = [];
id_bc = [];
id_nomesh = [];
id_bsfield = [];
id_pmagnet = [];
id_tconductor = [];
id_tcapacitor = [];

% --- check and update input
for i = 1:(nargin-1)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': Check function arguments : ' strjoin(arglist,', ') ' !']);
    end
end

%--------------------------------------------------------------------------

node = mesh.node;
elem = mesh.elem;
real_ori_edge_in_elem = mesh.real_ori_edge_in_elem;
real_ori_face_in_elem = mesh.real_ori_face_in_elem;

con = f_connexion(mesh.elem_type);
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


%---------------- Jacobien ------------------------------------------------
nbElem = size(elem,2);
%--------------------------------------------------------------------------
xnode = zeros(nbNo_inEl,nbElem);
ynode = zeros(nbNo_inEl,nbElem);
znode = zeros(nbNo_inEl,nbElem);
for j = 1:nbNo_inEl
    xnode(j,:) = node(1,elem(j,:));
    ynode(j,:) = node(2,elem(j,:));
    znode(j,:) = node(3,elem(j,:));
end

%--------------------------------------------------------------------------


%                        Center


%--------------------------------------------------------------------------
u = cU.*ones(1,nbElem);
v = cV.*ones(1,nbElem);
w = cW.*ones(1,nbElem);

%--------------------------------------------------------------------------
gradNx = fgradNx(u,v,w);
gradNy = fgradNy(u,v,w);
gradNz = fgradNz(u,v,w);

J11(1,:) = sum(gradNx.*xnode);
J12(1,:) = sum(gradNx.*ynode);
J13(1,:) = sum(gradNx.*znode);

J21(1,:) = sum(gradNy.*xnode);
J22(1,:) = sum(gradNy.*ynode);
J23(1,:) = sum(gradNy.*znode);

J31(1,:) = sum(gradNz.*xnode);
J32(1,:) = sum(gradNz.*ynode);
J33(1,:) = sum(gradNz.*znode);

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

Jinv(1,1,:) = 1./detJ.*A11;
Jinv(1,2,:) = 1./detJ.*A12;
Jinv(1,3,:) = 1./detJ.*A13;
Jinv(2,1,:) = 1./detJ.*A21;
Jinv(2,2,:) = 1./detJ.*A22;
Jinv(2,3,:) = 1./detJ.*A23;
Jinv(3,1,:) = 1./detJ.*A31;
Jinv(3,2,:) = 1./detJ.*A32;
Jinv(3,3,:) = 1./detJ.*A33;

%--------------------------------------------------------------------------
Wn = zeros(nbNo_inEl,nbElem);
for j = 1:length(con.N)
    Wn(j,:) = fN{j}(u,v,w);
end

%--------------------------------------------------------------------------
% volume = 0;
% for i = 1:nbNo_inEl
%     volume = volume + cWeigh .* detJ .* Wn(i,:);
% end

%--------------------------------------------------------------------------
gradWn = zeros(3,nbNo_inEl,nbElem);
Jinv1 = squeeze([Jinv(1,1,:); Jinv(1,2,:); Jinv(1,3,:)]);
Jinv2 = squeeze([Jinv(2,1,:); Jinv(2,2,:); Jinv(2,3,:)]);
Jinv3 = squeeze([Jinv(3,1,:); Jinv(3,2,:); Jinv(3,3,:)]);
for j = 1:nbNo_inEl
    gradNxyz = [gradNx(j,:); gradNy(j,:); gradNz(j,:)];
    gradWn(1,j,:) = dot(Jinv1, gradNxyz);
    gradWn(2,j,:) = dot(Jinv2, gradNxyz);
    gradWn(3,j,:) = dot(Jinv3, gradNxyz);
end
%--------------------------------------------------------------------------
gradF = zeros(3,nbFa_inEl,nbElem); % 3 for x,y,z
for j = 1:nbFa_inEl
    nbN = length(find(FaNo_inEl(j,:)));
    gradF(:,j,:) = sum(gradWn(:,FaNo_inEl(j,1:nbN),:),2);
end
%--------------------------------------------------------------------------
We = zeros(3,nbEd_inEl,nbElem);
for j = 1:nbEd_inEl
    We(:,j,:) = - (Wn(EdNo_inEl(j,1),:).*squeeze(gradF(:,NoFa_ofEd(j,1),:)) - ...
                   Wn(EdNo_inEl(j,2),:).*squeeze(gradF(:,NoFa_ofEd(j,2),:)))...
                   .*real_ori_edge_in_elem(j,:);
end
%--------------------------------------------------------------------------
nbNodemax = max(con.nbNo_inFa);
for j = 1:nbNodemax
    gradFxgradF{j} = zeros(3,nbFa_inEl,nbElem);
end
for j = 1:con.nbFa_inEl
    for k = 1:con.nbNo_inFa(j)
        knext = mod(k + 1,con.nbNo_inFa(j));
        if knext == 0
            knext = con.nbNo_inFa(j);
        end
        %-----
        gradFk = squeeze(gradF(:,NoFa_ofFa(j,k),:));
        gradFknext = squeeze(gradF(:,NoFa_ofFa(j,knext),:));
        %-----
        gradFxgradF{k}(:,j,:) = cross(gradFk,gradFknext);
    end
end
%--------------------------------------------------------------------------
Wf = zeros(3,nbFa_inEl,nbElem);
for j = 1:con.nbFa_inEl
    Wfxyz = zeros(3,nbElem);
    for k = 1:con.nbNo_inFa(j)
        Wfxyz = Wfxyz + ...
                Wn(FaNo_inEl(j,k),:).*squeeze(gradFxgradF{k}(:,j,:));
    end
    Wf(:,j,:) = (5 - con.nbNo_inFa(j)) * Wfxyz .* real_ori_face_in_elem(j,:);
end
%--------------------------------------------------------------------------
end

