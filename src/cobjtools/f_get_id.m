function phydomobj = f_get_id(c3dobj,phydomobj,varargin)
%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2023
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {''};

% --- default output value
id_elem = [];
id_face = [];
id_edge = [];
id_node = [];

%--------------------------------------------------------------------------
% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if isempty(phydomobj)
    error([mfilename ' : #phydomobj must be given !']);
end
%--------------------------------------------------------------------------
if ~all(isfield(phydomobj,{'id_dom3d','id_emdesign'}))
    error([mfilename ' : phydomobj must contains #id_dom3d and #id_emdesign!']);
end
%--------------------------------------------------------------------------
if isfield(phydomobj,'id_emdesign')
    id_emdesign = phydomobj.id_emdesign;
    id_mesh3d = c3dobj.emdesign.(id_emdesign).id_mesh3d;
elseif isfield(phydomobj,'id_thdesign3d')
    id_thdesign3d = phydomobj.id_thdesign3d;
    id_mesh3d = c3dobj.thdesign3d.(id_thdesign3d).id_mesh3d;
end
id_dom3d = phydomobj.id_dom3d;
id_dom3d = f_to_scellargin(id_dom3d);
%--------------------------------------------------------------------------
for i = 1:length(id_dom3d)
    defined_on = c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d{i}).defined_on;
    if any(f_strcmpi(defined_on,'elem'))
        id_elem = [id_elem ...
            c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d{i}).id_elem];
        defined_on = 'elem';
    elseif any(f_strcmpi(defined_on,'face'))
        id_face = [id_face ...
            c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d{i}).id_face];
        defined_on = 'face';
    elseif any(f_strcmpi(defined_on,'edge'))
        id_edge = [id_edge ...
            c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d{i}).id_edge];
        defined_on = 'edge';
    elseif any(f_strcmpi(defined_on,'node'))
        id_node = [id_node ...
            c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d{i}).id_node];
        defined_on = 'node';
    end
end
%--------------------------------------------------------------------------
% --- Output
phydomobj.defined_on = defined_on;
phydomobj.id_elem = id_elem;
phydomobj.id_face = id_face;
phydomobj.id_edge = id_edge;
phydomobj.id_node = id_node;



