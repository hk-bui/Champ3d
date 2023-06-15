function mesh3d = f_getboundface(mesh3d,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'elem_type','get'};

% --- default input value
elem_type = [];
get = []; % 'ndecomposition'

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
    fprintf(['Get boundface for ' elem_type ' element \n']);
end
%--------------------------------------------------------------------------
if isempty(elem_type)
    error([mfilename ' : #elem_type must be given !']);
end
%--------------------------------------------------------------------------
con = f_connexion(elem_type);
nbFa_inEl = con.nbFa_inEl;
%--------------------------------------------------------------------------
if ~isfield(mesh3d,'face_in_elem') || ~isfield(mesh3d,'si_face_in_elem')
    mesh3d = f_getface(mesh3d,'elem_type',elem_type);
end
%--------------------------------------------------------------------------
face = mesh3d.face;
face_in_elem = mesh3d.face_in_elem;
si_face_in_elem = mesh3d.si_face_in_elem;
nb_face = size(face,2);
%--------------------------------------------------------------------------

%-----
elem_left_of_face = zeros(1,nb_face); % !!! convention
for i = 1:nbFa_inEl
    elem_left_of_face(face_in_elem(i,si_face_in_elem(i,:) > 0)) = find(si_face_in_elem(i,:) > 0);
end
%-----
dom_left_of_face = zeros(1,nb_face);
dom_left_of_face(elem_left_of_face > 0) = 1 ;%elem_code(elem_left_of_face(elem_left_of_face > 0));
%-----
elem_right_of_face = zeros(1,nb_face);
for i = 1:nbFa_inEl
    elem_right_of_face(face_in_elem(i,si_face_in_elem(i,:) < 0)) = find(si_face_in_elem(i,:) < 0);
end
%-----
dom_right_of_face = zeros(1,nb_face);
dom_right_of_face(elem_right_of_face > 0) = 1 ;%elem_code(elem_right_of_face(elem_right_of_face > 0));
%--------------------------------------------------------------------------
% --- bound with outward normal
ibO = find(dom_left_of_face  == 1 & dom_right_of_face == 0);
ibI = find(dom_right_of_face == 1 & dom_left_of_face  == 0);
bound_face = [face(:,ibO) f_invori(face(:,ibI))];
%--------------------------------------------------------------------------
id_bound_face = [ibO ibI];
%--------------------------------------------------------------------------
% --- bound with n-decomposition
if any(strcmpi(get,{'nd','ndec','ndecomposition','n-decomposition'}))
    bf = bound_face;
    id_bf = id_bound_face;
    nface = f_chavec(mesh3d.node,bound_face);
    [~,~,inface] = f_unique(nface,'by','strict_value','get','groupsort');
    nb_gr = length(inface);
    bound_face = {};
    id_bound_face = {};
    for i = 1:nb_gr
        bound_face{i} = bf(:,inface{i});
        id_bound_face{i} = id_bf(inface{i});
    end
end

%--------------------------------------------------------------------------
% --- Outputs
mesh3d.bound_face = bound_face;
mesh3d.id_bound_face = id_bound_face;







%----- interface
% if nargin == 2 | isfield(datin,'full') | isfield(datin,'interface') 
%     iDom = unique(elem(nbNo_inEl+1,:));
%     iDom = combnk(iDom,2);
%     nb2D = size(iDom,1);
%     iinf = [];
%     for i = 1:nb2D
%         iinf = [iinf find((domL_of_face == iDom(i,1) & domR_of_face == iDom(i,2)) | ...
%                           (domR_of_face == iDom(i,1) & domL_of_face == iDom(i,2)))];
%     end
%     nbInt = length(iinf);
%     if ~isempty(iinf)
%         interface = zeros(maxnbNo_inFa+3,nbInt);
%         interface(1:maxnbNo_inFa,:) = face(1:maxnbNo_inFa,iinf);
%         interface(maxnbNo_inFa+1,:) = domL_of_face(iinf);
%         interface(maxnbNo_inFa+2,:) = domR_of_face(iinf);
%         interface(maxnbNo_inFa+3,:) = iinf;
%         %----- out
%         mesh.interface = interface;
%     else
%         mesh.interface = [];
%     end
% end