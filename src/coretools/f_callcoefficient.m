function coef = f_callcoefficient(c3dobj,varargin)
% F_CALLPARAMETER calculates and returns parameter value according to its dependency.
% p_value : array of values of the parameter computed for each element
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'design3d','id_design3d','dom_type','id_dom',...
           'phydomobj','coefficient'};

% --- default input value
design3d = [];
id_design3d = [];
dom_type  = [];
id_dom    = [];
phydomobj = [];
coefficient = [];

% --- valid coefficient type
valid_coeftype = {'numeric_iso_value','numeric_iso_array','numeric_gtensor_value', ...
                  'numeric_gtensor_array','numeric_ltensor_value',...
                  'function_ltensor_array','function_iso_array'};

% --- default output value
coef = [];

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
    if ~isempty(design3d) && ~isempty(id_design3d) && ~isempty(dom_type) && ~isempty(id_dom)
        phydomobj = c3dobj.(design3d).(id_design3d).(dom_type).(id_dom);
    else
        return;
    end
end
%--------------------------------------------------------------------------
coef = phydomobj.(coefficient);
%--------------------------------------------------------------------------
id_mesh3d = phydomobj.id_mesh3d;
id_dom3d  = phydomobj.id_dom3d;
id_elem   = c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d).id_elem;
nbElem    = length(id_elem);
%--------------------------------------------------------------------------
coeftype = f_coeftype(coef);
%--------------------------------------------------------------------------
switch coeftype
    case {'numeric_iso_value'}
    case {'numeric_iso_array'}
    case {'numeric_gtensor_value'}
    case {'numeric_gtensor_array'}
    case {'numeric_ltensor_value'}
    case {'function_ltensor_array'}
    case {'function_iso_array'}
    otherwise
        
end





return
%--------------------------------------------------------------------------
paramfields = fieldnames(phydomobj.(coefficient));
%--------------------------------------------------------------------------
%for ipf = 1:length(paramfields)
%--------------------------------------------------------------------------
if nargin(param.f) == 0
    coef = ones(1,nbElem) .* param.f();
else
    %----------------------------------------------------------------------
    nb_fargin = nargin(param.f);
    %----------------------------------------------------------------------
    alist = {};
    for ial = 1:nb_fargin
        alist{ial} = ['c3dobj' ...
                      '.' param.design3d{ial} ...
                      '.' param.id_design3d{ial} ...
                      '.' param.field{ial}];
    end
    %----------------------------------------------------------------------
    for ial = 1:nb_fargin
        argu{ial} = eval([alist{ial} '(:,id_elem);']);
    end
    %----------------------------------------------------------------------
    if nb_fargin == 1
        coef = feval(param.f,argu{1});
    elseif nb_fargin == 2
        coef = feval(param.f,argu{1},argu{2});
    elseif nb_fargin == 3
        coef = feval(param.f,argu{1},argu{2},argu{3});
    elseif nb_fargin == 4
        coef = feval(param.f,argu{1},argu{2},argu{3},argu{4});
    elseif nb_fargin == 5
        coef = feval(param.f,argu{1},argu{2},argu{3},argu{4},argu{5});
    end
end
%--------------------------------------------------------------------------
if iscolumn(coef)
    coef = coef.';
end
%--------------------------------------------------------------------------
%if isrow(eval(alist{ial}))
%    argu = [alist{ial} '(:,id_elem)'];
%elseif iscolumn(eval(alist{ial}))
%    argu = [alist{ial} '(id_elem,:)'];
%else
%    argu = [alist{ial} '(:,id_elem)'];
%end
%fform = 'feval(parameter.f';
%for ial = 1:nargin(param.f)
%    fform = [fform ',' argu];
%end
%fform = [fform ');'];
%--------------------------------------------------------------------------
% switch param_type
%     case {'num_iso_coef'}
%     case {'num_iso_array'}
%     case {'fun_iso_array'}
%     case {'num_tensor_coef'}
%     case {'fun_tensor_array'}
%         ltensor = f_callparameter(c3dobj,'phydomobj',phydomobj,...
%                       'parameter',parameter,'param_type',param_type);
%         gtensor = f_gtensor(ltensor);
% end

