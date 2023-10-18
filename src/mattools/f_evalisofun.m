function iso_array = f_evalisofun(c3dobj,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'phydomobj','iso_function'};

% --- default input value
phydomobj = [];
iso_function = [];

% --- default output value
iso_array = [];

% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if isfield(phydomobj,'id_emdesign3d')
    id_emdesign3d = phydomobj.id_emdesign3d;
    id_mesh3d = c3dobj.emdesign3d.(id_emdesign3d).id_mesh3d;
elseif isfield(phydomobj,'id_thdesign3d')
    id_thdesign3d = phydomobj.id_thdesign3d;
    id_mesh3d = c3dobj.thdesign3d.(id_thdesign3d).id_mesh3d;
end
%--------------------------------------------------------------------------
id_dom3d  = phydomobj.id_dom3d;
id_elem   = c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d).id_elem;
nb_elem   = length(id_elem);
%--------------------------------------------------------------------------
paramtype = f_paramtype(iso_function);
%--------------------------------------------------------------------------
if ~any(strcmpi(paramtype,{'c3d_parameter_function'}))
    fprintf([mfilename ' : this iso_function is not supported. Use f_make_parameter ! \n']);
    return
end
%--------------------------------------------------------------------------
nb_fargin = f_nargin(iso_function.f);
%--------------------------------------------------------------------------
alist = {};
for ial = 1:nb_fargin
    depon = iso_function.depend_on{ial};
    if isempty(depon)
        alist{ial} = depon;
    else
        alist{ial} = f_cargpath(c3dobj,'phydomobj',phydomobj,'arg_name',depon);
    end
end
%--------------------------------------------------------------------------
varargin_list = iso_function.varargin_list;
%--------------------------------------------------------------------------
argu = {};
for ial = 1:nb_fargin
    argu{ial} = eval([alist{ial} '(:,id_elem);']);
end
%--------------------------------------------------------------------------
if any(strcmpi(iso_function.coef_type,{'array'}))
    f = iso_function.f;
    if nb_fargin == 0
        param = f(varargin_list{:});
    elseif nb_fargin == 1
        param = f(argu{1},varargin_list{:});
    elseif nb_fargin == 2
        param = f(argu{1},argu{2},varargin_list{:});
    elseif nb_fargin == 3
        param = f(argu{1},argu{2},argu{3},varargin_list{:});
    elseif nb_fargin == 4
        param = f(argu{1},argu{2},argu{3},argu{4},varargin_list{:});
    elseif nb_fargin == 5
        param = f(argu{1},argu{2},argu{3},argu{4},argu{5},varargin_list{:});
    elseif nb_fargin == 6
        param = f(argu{1},argu{2},argu{3},argu{4},argu{5},argu{6},varargin_list{:});
    end
else
    param = f_foreach(iso_function.f,'argument_array',argu,'varargin_list',varargin_list);
end
%--------------------------------------------------------------------------
param(isnan(param)) = 0;
%--------------------------------------------------------------------------
% --- Output
if size(param,1) == 1 && size(param,2) ~= nb_elem
    iso_array = repmat(param,nb_elem,1);
elseif size(param,1) ~= nb_elem && size(param,2) == nb_elem
    iso_array = param.';
else
    iso_array = param;
end
%--------------------------------------------------------------------------

