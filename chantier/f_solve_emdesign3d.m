function c3dobj = f_solve_emdesign3d(c3dobj,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'id_emdesign3d','options'};

% --- default input value
id_emdesign3d = [];
options = []; % 'with_updated_mesh'

% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if isempty(id_emdesign3d)
    id_emdesign3d = fieldnames(c3dobj.emdesign3d);
end
%--------------------------------------------------------------------------
id_emdesign3d = f_to_scellargin(id_emdesign3d);
%--------------------------------------------------------------------------
for iem = 1:length(id_emdesign3d)
    %--------------------------------------------------------------------------
    em_model = c3dobj.emdesign3d.(id_emdesign3d{iem}).em_model;
    %--------------------------------------------------------------------------
    switch em_model
        case {'fem_aphijw'}
            c3dobj = ...
               f_solve_fem_aphijw(c3dobj,'id_emdesign3d',id_emdesign3d{iem});
        case {'fem_aphits'}
            c3dobj = ...
               f_solve_fem_aphits(c3dobj,'id_emdesign3d',id_emdesign3d{iem});
        case {'fem_tomejw'}
            c3dobj = ...
               f_solve_fem_tomejw(c3dobj,'id_emdesign3d',id_emdesign3d{iem});
        case {'fem_tomets'}
            c3dobj = ...
               f_solve_fem_tomets(c3dobj,'id_emdesign3d',id_emdesign3d{iem});
    end
end





