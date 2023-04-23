function design3d = f_add_tconductor(design3d,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'design3d','id_tconductor','id_dom3d','id_elem',...
           'flambda','frho','fcp','frhocp',...
           'lambda','rho','cp','rhocp'};

% --- default input value
id_dom3d = [];
id_elem  = [];
flambda  = [];
frho     = [];
fcp      = [];
lambda   = [];
rho      = [];
cp       = [];
rhocp    = [];
id_tconductor = [];
%--------------------------------------------------------------------------
if ~isfield(design3d,'tconductor')
    design3d.tconductor = [];
end
%--------------------------------------------------------------------------
if nargin <= 1
    error([mfilename ': No tconductor to add!']);
end
%--------------------------------------------------------------------------
% --- check and update input
for i = 1:(nargin-1)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': Check function arguments : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if isempty(id_tconductor)
    error([mfilename ': id_tconductor must be defined !'])
end

if ~isfield(design3d,'dom3d')
    error([mfilename ': dom3d is not defined !']);
end

if isempty(id_dom3d) && isempty(id_elem)
    error([mfilename ': id_dom3d or id_elem must be defined !'])
end

%--------------------------------------------------------------------------
if ~isempty(id_dom3d)
    id_elem = design3d.dom3d.(id_dom3d).id_elem;
end
%--------------------------------------------------------------------------
% --- Output
design3d.tconductor.(id_tconductor).id_dom3d = id_dom3d;
design3d.tconductor.(id_tconductor).id_elem = id_elem;
design3d.tconductor.(id_tconductor).flambda = flambda;
design3d.tconductor.(id_tconductor).frho = frho;
design3d.tconductor.(id_tconductor).fcp = fcp;
design3d.tconductor.(id_tconductor).lambda = lambda;
design3d.tconductor.(id_tconductor).rho = rho;
design3d.tconductor.(id_tconductor).cp = cp;
design3d.tconductor.(id_tconductor).rhocp = rhocp;
% --- info message
fprintf(['Add tcon ' id_tconductor ' - done \n']);



