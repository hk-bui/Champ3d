function [inter_face, lid_inter_face, info] = f_interface(elem1,elem2,node,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'elem_type','of_dom3d','get','n_component','n_direction'};

% --- default input value
elem_type = [];
get = []; % 'ndecomposition' = 'ndec' = 'n-decomposition'
n_direction = 'outward'; % 'outward' = 'out' = 'o', 'inward' = 'in' = 'i'
                         % otherwise : 'automatic' = 'natural' = 'auto'
n_component = []; % 1, 2 or 3
%--------------------------------------------------------------------------
% --- check and update input
for i = 1:(nargin-3)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': Check function arguments : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if isempty(elem_type)
    error([mfilename ' : #elem_type must be given !']);
end
%--------------------------------------------------------------------------
bface1 = f_boundface(elem1,node,'elem_type',elem_type,n_direction',n_direction);
bface2 = [];
if ~isempty(elem2)
    bface2 = f_boundface(elem2,node,'elem_type',elem_type);
end
%--------------------------------------------------------------------------
if ~isempty(bface2)
    inter_face = f_intersectvec(bface1,bface2); % with bface{1} as ref
else
    inter_face = bface1; % with bface{1} as ref
end
%--------------------------------------------------------------------------
lid_inter_face = [];
id_bf = [];
if any(strcmpi(get,{'local_id'}))
    elem_type = f_elemtype(elem,'defined_on','elem');
    face = f_face(elem,'elem_type',elem_type);
    lid_inter_face = f_findvecnd(inter_face,bface1{1}); % with bface{1} as ref
    id_bf = lid_inter_face;
end
%--------------------------------------------------------------------------
% Add information
info = [];
if any(strcmpi(get,{'info'}))
    info = ['inter_face with ' n_direction '-normal'];
end
%--------------------------------------------------------------------------
% --- bound with n-decomposition
if any(strcmpi(get,{'nd','ndec','ndecomposition','n-decomposition'}))
    bf = inter_face;
    nface = f_chavec(mesh3d.node,inter_face);
    if isempty(n_component)
        [~,~,inface] = f_unique(nface,'by','strict_value','get','groupsort');
    elseif isnumeric(n_component)
        [~,inface] = f_groupsort(nface,'group_component',n_component);
    end
    nb_gr = length(inface);
    inter_face = {};
    lid_inter_face = {};
    for i = 1:nb_gr
        inter_face{i} = bf(:,inface{i});
        lid_inter_face{i} = id_bf(inface{i});
    end
end

