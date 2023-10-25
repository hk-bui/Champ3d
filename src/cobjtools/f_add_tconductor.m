function c3dobj = f_add_tconductor(c3dobj,varargin)
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
arglist = {'id_thdesign3d','id_tconductor','id_dom3d','id_elem',...
           'flambda','frho','fcp','frhocp',...
           'lambda','rho','cp','rhocp'};

% --- default input value
id_thdesign3d = [];
id_dom3d = [];
flambda  = [];
frho     = [];
fcp      = [];
lambda   = [];
rho      = [];
cp       = [];
rhocp    = [];
id_tconductor = [];

%--------------------------------------------------------------------------
if nargin <= 1
    error([mfilename ': No tconductor to add!']);
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
if isempty(id_tconductor)
    error([mfilename ': id_tconductor must be defined !'])
end
%--------------------------------------------------------------------------
if isempty(id_dom3d)
    error([mfilename ': id_dom3d must be given !'])
end
%--------------------------------------------------------------------------
% --- Output
c3dobj.thdesign3d.(id_thdesign3d).tconductor.(id_tconductor).id_thdesign3d = id_thdesign3d;
c3dobj.thdesign3d.(id_thdesign3d).tconductor.(id_tconductor).id_dom3d = id_dom3d;
c3dobj.thdesign3d.(id_thdesign3d).tconductor.(id_tconductor).flambda = flambda;
c3dobj.thdesign3d.(id_thdesign3d).tconductor.(id_tconductor).lambda = lambda;
% --- status
c3dobj.thdesign3d.(id_thdesign3d).tconductor.(id_tconductor).to_be_rebuilt = 1;
% --- info message
fprintf(['Add tcon #' id_tconductor ' to thdesign3d #' id_thdesign3d '\n']);



