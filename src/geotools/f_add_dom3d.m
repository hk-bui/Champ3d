function geo = f_add_dom3d(geo,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'id_mesh3d','id_dom3d','id_dom2d','id_layer','elem_code'};

% --- default input value
id_mesh3d = [];
id_dom3d = [];
id_dom2d = [];
id_layer = [];
elem_code = [];

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
    id_mesh3d = fieldnames(geo.geo3d.mesh3d);
    id_mesh3d = id_mesh3d{1};
end

if isempty(id_dom3d)
    error([mfilename ' : #id_dom3d must be given !']);
end

%--------------------------------------------------------------------------
switch geo.geo3d.mesh3d.(id_mesh3d).mesher
    case 'champ3d_hexa'
        tic;
        fprintf(['Define dom3d #' id_dom3d ' in mesh3d #' id_mesh3d ' ... ']);
        %------------------------------------------------------------------
        if isempty(id_dom2d) || isempty(id_layer)
            error([mfilename ' : #id_dom2d and #id_layer must be given !']);
        end
        %------------------------------------------------------------------
        id_dom2d = f_to_dcellargin(id_dom2d);
        id_layer = f_to_dcellargin(id_layer);
        [id_dom2d, id_layer] = f_pairing_cellargin(id_dom2d, id_layer);
        %------------------------------------------------------------------
        id_all_elem = 1:geo.geo3d.mesh3d.(id_mesh3d).nb_elem;
        elem_code = geo.geo3d.mesh3d.(id_mesh3d).elem_code;
        id_elem = [];
        for i = 1:length(id_dom2d)
            for j = 1:length(id_dom2d{i})
                codeidd2d = f_str2code(id_dom2d{i}{j});
                for k = 1:length(id_layer{i})
                    codeidlay = f_str2code(id_layer{i}{k});
                    id_elem = [id_elem ...
                               id_all_elem(elem_code == codeidd2d * codeidlay)];
                end
            end
        end
        id_elem = unique(id_elem);
        %------------------------------------------------------------------
        geo.geo3d.dom3d.(id_dom3d).id_elem = id_elem;
        %------------------------------------------------------------------
        % --- Log message
        fprintf('done ----- in %.2f s \n',toc);
        %------------------------------------------------------------------
    case 'champ3d_prism'
    case 'gmsh'
end


