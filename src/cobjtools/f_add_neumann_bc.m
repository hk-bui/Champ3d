function c3dobj = f_add_neumann_bc(c3dobj,varargin)
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
arglist = {'id_emdesign3d','id_thdesign3d','id_bc','id_dom3d','defined_on','bc_coef'};

% --- default input value
id_emdesign3d = [];
id_thdesign3d = [];
id_dom3d      = [];
id_bc         = [];
defined_on    = []; % 'edge_bound', 'face_bound', 'edge', 'face'
bc_coef       = 0;
%--------------------------------------------------------------------------
if nargin <= 1
    error([mfilename ': No bc to add!']);
end
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
if isempty(id_emdesign3d) && isempty(id_thdesign3d)
    error([mfilename ': id_emdesign3d or id_thdesign3d must be given !'])
end
%--------------------------------------------------------------------------
if isempty(id_bc)
    error([mfilename ': id_bc must be defined !'])
end
%--------------------------------------------------------------------------
if isempty(id_dom3d)
    error([mfilename ': id_dom3d must be given !'])
end
%--------------------------------------------------------------------------
% --- Output
if ~isempty(id_emdesign3d)
    design3d = 'emdesign3d';
    id_design3d = id_emdesign3d;
elseif ~isempty(id_thdesign3d)
    design3d = 'thdesign3d';
    id_design3d = id_thdesign3d;
end
%--------------------------------------------------------------------------
id_mesh3d = c3dobj.(design3d).(id_design3d).id_mesh3d;
%--------------------------------------------------------------------------
% --- Output
c3dobj.(design3d).(id_design3d).bc.(id_bc).id_emdesign3d = id_emdesign3d;
c3dobj.(design3d).(id_design3d).bc.(id_bc).id_dom3d = id_dom3d;
c3dobj.(design3d).(id_design3d).bc.(id_bc).bc_type = 'neumann';
c3dobj.(design3d).(id_design3d).bc.(id_bc).defined_on = defined_on;
c3dobj.(design3d).(id_design3d).bc.(id_bc).bc_value = bc_coef;
% --- status
c3dobj.(design3d).(id_design3d).bc.(id_bc).to_be_rebuilt = 1;
% --- info message
fprintf(['Add neumann boundary condition #' id_bc ' to ' design3d ' #' id_design3d '\n']);

