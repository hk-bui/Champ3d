function design3d = f_build_tconductor(design3d,varargin)
% F_BUILD_TCONDUCTOR returns the matrix system
% related to ...
%--------------------------------------------------------------------------
% design3d = f_build_tconductor(design3d,options)
%--------------------------------------------------------------------------
% Questions and inquiries can be addressed to the author:
% Dr. H-K. Bui
% Lab. IREENA
% Dep. Mesures Physiques, IUT of Saint Nazaire
% University of Nantes, France
% Email : huu-kien.bui@univ-nantes.fr
% Copyright (c) 2019 Huu-Kien Bui. All Rights Reserved.
%--------------------------------------------------------------------------



% --- valid argument list (to be updated each time modifying function)
arglist = {'id_dom3d'};

% --- default input value
id_dom3d = [];

% --- check and update input
for i = 1:(nargin-1)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': Check function arguments : ' strjoin(arglist,', ') ' !']);
    end
end





