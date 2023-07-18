function ltensor = f_evalltensor(c3dobj,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'phydomobj','ltensor'};

% --- default input value
phydomobj = [];
ltensor = [];

% --- valid depend_on
valid_ltensor = {'main_value','ort1_value','ort2_value',...
                 'main_dir','ort1_dir','ort2_dir'};

% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
id_mesh3d = phydomobj.id_mesh3d;
id_dom3d  = phydomobj.id_dom3d;
id_elem   = c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d).id_elem;
nbElem    = length(id_elem);
%--------------------------------------------------------------------------
ltfield__ = fieldnames(ltensor);
%--------------------------------------------------------------------------
for iltf = 1:length(ltfield__)
    %----------------------------------------------------------------------
    ltfield = ltensor.(ltfield__{iltf});
    paramtype = f_paramtype(ltfield);
    %----------------------------------------------------------------------
    if any(strcmpi(paramtype,{'c3d_parameter_function'}))
        %----------------------------------------------------------------------
        nb_fargin = nargin(ltfield.f);
        %----------------------------------------------------------------------
        alist = {};
        for ial = 1:nb_fargin
            alist{ial} = ['c3dobj' ...
                          '.' ltfield.from{ial} ...
                          '.' ltfield.id_cobj{ial} ...
                          '.' ltfield.field{ial}];
        end
        %----------------------------------------------------------------------
        for ial = 1:nb_fargin
            argu{ial} = eval([alist{ial} '(:,id_elem);']);
        end
        %----------------------------------------------------------------------
        if nb_fargin == 1
            coef = feval(ltfield.f,argu{1});
        elseif nb_fargin == 2
            coef = feval(ltfield.f,argu{1},argu{2});
        elseif nb_fargin == 3
            coef = feval(ltfield.f,argu{1},argu{2},argu{3});
        elseif nb_fargin == 4
            coef = feval(ltfield.f,argu{1},argu{2},argu{3},argu{4});
        elseif nb_fargin == 5
            coef = feval(ltfield.f,argu{1},argu{2},argu{3},argu{4},argu{5});
        elseif nb_fargin == 6
            coef = feval(ltfield.f,argu{1},argu{2},argu{3},argu{4},argu{5},argu{6});
        end
    end
end