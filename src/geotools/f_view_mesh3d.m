function f_view_mesh3d(dom3D,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'id_mesh3d''id_dom3d','id_dom2d','id_layer','color'};

% --- default input value
id_mesh3d = [];
id_dom3d = [];
id_dom2d = [];
id_layer = [];
color = 'w';
% --- check and update input
for i = 1:(nargin-1)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': Check function arguments : ' strjoin(arglist,', ') ' !']);
    end
end

%--------------------------------------------------------------------------
if isempty(id_mesh3d)
    id_mesh3d = fieldnames(geo.geo2d.mesh2d);
    id_mesh3d = id_mesh3d{1};
end
if isempty(id_dom3d)
    id_dom3d = {''};
    id_elem = 1:geo.geo3d.mesh3d.(id_mesh3d).nb_elem;
    disptext = {'all-elem'};
else
    id_elem = geo.geo3d.dom3d.(id_dom3d).id_elem;
    disptext = id_dom3d;
end
%--------------------------------------------------------------------------

node = geo.geo3d.mesh3d.(id_mesh3d).node;
elem = geo.geo3d.mesh3d.(id_mesh3d).elem(:,id_elem);




face = geo.geo3d.mesh3d.(id_mesh3d).face;
face_in_elem = geo.geo3d.mesh3d.(id_mesh3d).face_in_elem;

iElem = 1:size(elem,2);
Color = 'gr';

if strcmpi(Type,'volume')

    t_f=[face_in_elem(1,iElem) face_in_elem(2,iElem) face_in_elem(3,iElem) ...
         face_in_elem(4,iElem) face_in_elem(5,iElem)] ;

    t_f=unique(t_f);

    % 1/ triangle
    ind_tria=find(face(4,t_f)==0);
    fac=[face(1,t_f(ind_tria));face(2,t_f(ind_tria));face(3,t_f(ind_tria))];
    patchinfo.Vertices = node.';
    patchinfo.Faces = fac.';
    patchinfo.FaceColor = Color;
    patch(patchinfo); hold on


    % 2/ quad
    ind_quad=setdiff(1:length(t_f),ind_tria);
    fac=[face(1,t_f(ind_quad));face(2,t_f(ind_quad));face(3,t_f(ind_quad));face(4,t_f(ind_quad))];
    patchinfo.Vertices = node.';
    patchinfo.Faces = fac.';
    patchinfo.FaceColor = Color;
    patch(patchinfo);
    alpha(0.5);
    axis equal
    axis image
    xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)');
    view(3);
    hold off

elseif strcmpi(Type,'surface')

    t_f=unique(iElem);

    % 1/ triangle
    ind_tria=find(face(4,t_f)==0);
    fac=[face(1,t_f(ind_tria));face(2,t_f(ind_tria));face(3,t_f(ind_tria))];
    patchinfo.Vertices = node.';
    patchinfo.Faces = fac.';
    patchinfo.FaceColor = Color;
    patch(patchinfo); hold on

    % 2/ quad
    ind_quad=setdiff(1:length(t_f),ind_tria);
    fac=[face(1,t_f(ind_quad));face(2,t_f(ind_quad));face(3,t_f(ind_quad));face(4,t_f(ind_quad))];
    patchinfo.Vertices = node.';
    patchinfo.Faces = fac.';
    patchinfo.FaceColor = Color;
    patch(patchinfo);
    alpha(0.5);
    axis equal
    axis image
    xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)');
    view(3);
    hold off
end


