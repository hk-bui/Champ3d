function c3dobj = f_add_tcapacitor(c3dobj,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'id_thdesign3d','id_tcapacitor','id_dom3d','id_elem',...
           'flambda','frho','fcp','frhocp',...
           'lambda','rho','cp','rhocp'};

% --- default input value
id_thdesign3d = [];
id_dom3d = [];
frho     = [];
fcp      = [];
rho      = [];
cp       = [];
rhocp    = [];
id_tcapacitor = [];

%--------------------------------------------------------------------------
if nargin <= 1
    error([mfilename ': No tcapacitor to add!']);
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
if isempty(id_thdesign3d)
    id_thdesign3d = fieldnames(c3dobj.thdesign3d);
    id_thdesign3d = id_thdesign3d{1};
end
%--------------------------------------------------------------------------
if isempty(id_tcapacitor)
    error([mfilename ': id_tcapacitor must be defined !'])
end
%--------------------------------------------------------------------------
if isempty(id_dom3d)
    error([mfilename ': id_dom3d must be given !'])
end
%--------------------------------------------------------------------------
% --- Output
c3dobj.thdesign3d.(id_thdesign3d).tcapacitor.(id_tcapacitor).id_thdesign3d = id_thdesign3d;
c3dobj.thdesign3d.(id_thdesign3d).tcapacitor.(id_tcapacitor).id_dom3d = id_dom3d;
c3dobj.thdesign3d.(id_thdesign3d).tcapacitor.(id_tcapacitor).frho = frho;
c3dobj.thdesign3d.(id_thdesign3d).tcapacitor.(id_tcapacitor).fcp = fcp;
c3dobj.thdesign3d.(id_thdesign3d).tcapacitor.(id_tcapacitor).rho = rho;
c3dobj.thdesign3d.(id_thdesign3d).tcapacitor.(id_tcapacitor).cp = cp;
c3dobj.thdesign3d.(id_thdesign3d).tcapacitor.(id_tcapacitor).rhocp = rhocp;
% --- status
c3dobj.thdesign3d.(id_thdesign3d).tcapacitor.(id_tcapacitor).to_be_rebuilt = 1;
% --- info message
fprintf(['Add tcon #' id_tcapacitor ' to thdesign3d #' id_thdesign3d '\n']);



