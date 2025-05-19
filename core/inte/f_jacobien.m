function [detJ, Jinv] = f_jacobien(node,elem,args)
%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2023
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
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

arguments
    node
    elem
    args.u = []
    args.v = []
    args.w = []
    args.flat_node = []
    args.elem_type {mustBeMember(args.elem_type,{'','tri','triangle','quad','tet','tetra','prism','hex','hexa'})} = ''
end

% -------------------------------------------------------------------------
u = args.u;
v = args.v;
w = args.w;
flat_node = args.flat_node;
elem_type = args.elem_type;
%--------------------------------------------------------------------------
if isempty(elem_type)
    elem_type = f_elemtype(elem,'defined_on','elem');
end
%--------------------------------------------------------------------------
if ~isempty(w)
    if (numel(u) ~= numel(v)) || (numel(u) ~= numel(w))
        error([mfilename ': u, v, w do not have same size !']);
    end
else
    if (numel(u) ~= numel(v))
        error([mfilename ': u, v do not have same size !']);
    end
end
%--------------------------------------------------------------------------
refelem = f_refelem(elem_type);
nbNo_inEl = refelem.nbNo_inEl;
%--------------------------------------------------------------------------
if any(f_strcmpi(elem_type,{'tri','triangle','quad'}))
    dim = 2;
    fgradNx = refelem.gradNx;
    fgradNy = refelem.gradNy;
    %----------------------------------------------------------------------
    nb_elem = size(elem,2);
    %----------------------------------------------------------------------
    if isempty(flat_node)
        x = reshape(node(1,elem(:,:)),nbNo_inEl,nb_elem);
        y = reshape(node(2,elem(:,:)),nbNo_inEl,nb_elem);
    else
        x = squeeze(flat_node(1,:,:));
        y = squeeze(flat_node(2,:,:));
    end
    %----------------------------------------------------------------------
    lenu = length(u);
    detJ = cell(1,lenu);
    Jinv = cell(1,lenu);
    for i = 1:length(u)
        detJ{i} = zeros(1,nb_elem);
        Jinv{i} = zeros(dim,dim,nb_elem);
    end
    %----------------------------------------------------------------------
    for i = 1:lenu
        u_ = u(i).*ones(1,nb_elem);
        v_ = v(i).*ones(1,nb_elem);
        %------------------------------------------------------------------
        gradNx = fgradNx(u_,v_);
        gradNy = fgradNy(u_,v_);
        % ---
        J11 = sum(gradNx.*x);
        J12 = sum(gradNx.*y);
        % ---
        J21 = sum(gradNy.*x);
        J22 = sum(gradNy.*y);
        % ---
        dJ = J11.*J22 - J21.*J12;
        % ---
        Ji = zeros(dim,dim,nb_elem);
        Ji(1,1,:) =  1./dJ.*J22;
        Ji(1,2,:) = -1./dJ.*J12;
        Ji(2,1,:) = -1./dJ.*J21;
        Ji(2,2,:) =  1./dJ.*J11;
        % ---
        detJ{i} = dJ;
        Jinv{i} = Ji;
    end
    %----------------------------------------------------------------------
elseif any(f_strcmpi(elem_type,{'tet','tetra','prism','hex','hexa'}))
    dim = 3;
    fgradNx = refelem.gradNx;
    fgradNy = refelem.gradNy;
    fgradNz = refelem.gradNz;
    %----------------------------------------------------------------------
    nb_elem = size(elem,2);
    %----------------------------------------------------------------------
    x = reshape(node(1,elem(:,:)),nbNo_inEl,nb_elem);
    y = reshape(node(2,elem(:,:)),nbNo_inEl,nb_elem);
    z = reshape(node(3,elem(:,:)),nbNo_inEl,nb_elem);
    %----------------------------------------------------------------------
    lenu = length(u);
    detJ = cell(1,lenu);
    Jinv = cell(1,lenu);
    for i = 1:lenu
        detJ{i} = zeros(1,nb_elem);
        Jinv{i} = zeros(dim,dim,nb_elem);
    end
    %----------------------------------------------------------------------
    for i = 1:lenu
        u_ = u(i).*ones(1,nb_elem);
        v_ = v(i).*ones(1,nb_elem);
        w_ = w(i).*ones(1,nb_elem);
        %------------------------------------------------------------------
        gradNx = fgradNx(u_,v_,w_);
        gradNy = fgradNy(u_,v_,w_);
        gradNz = fgradNz(u_,v_,w_);
        % ---
        J11 = sum(gradNx.*x);
        J12 = sum(gradNx.*y);
        J13 = sum(gradNx.*z);
        % ---
        J21 = sum(gradNy.*x);
        J22 = sum(gradNy.*y);
        J23 = sum(gradNy.*z);
        % ---
        J31 = sum(gradNz.*x);
        J32 = sum(gradNz.*y);
        J33 = sum(gradNz.*z);
        % ---
        A11 = J22.*J33 - J23.*J32;
        A12 = J32.*J13 - J12.*J33;
        A13 = J12.*J23 - J13.*J22;
        A21 = J23.*J31 - J21.*J33;
        A22 = J33.*J11 - J31.*J13;
        A23 = J13.*J21 - J23.*J11;
        A31 = J21.*J32 - J31.*J22;
        A32 = J31.*J12 - J32.*J11;
        A33 = J11.*J22 - J12.*J21;
        % ---
        dJ = J11.*J22.*J33 + J21.*J32.*J13 + J31.*J12.*J23 - ...
             J11.*J32.*J23 - J31.*J22.*J13 - J21.*J12.*J33;
        % ---
        Ji = zeros(dim,dim,nb_elem);
        Ji(1,1,:) = 1./dJ.*A11;
        Ji(1,2,:) = 1./dJ.*A12;
        Ji(1,3,:) = 1./dJ.*A13;
        Ji(2,1,:) = 1./dJ.*A21;
        Ji(2,2,:) = 1./dJ.*A22;
        Ji(2,3,:) = 1./dJ.*A23;
        Ji(3,1,:) = 1./dJ.*A31;
        Ji(3,2,:) = 1./dJ.*A32;
        Ji(3,3,:) = 1./dJ.*A33;
        % ---
        detJ{i} = dJ;
        Jinv{i} = Ji;
    end
    %----------------------------------------------------------------------
end

