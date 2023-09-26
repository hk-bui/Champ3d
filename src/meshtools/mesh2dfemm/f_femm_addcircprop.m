function f_femm_addcircprop(varargin)

%--------------------------------------------------------------------------
% Call mi_addcircprop
% FEMM
% Author : David Meeker
% Copyright (C) 1998-2015
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'id_circuit','imax','circuit_type'};

% --- default input value
id_circuit = 'circuit';
imax = 0;
circuit_type = 'parallel'; % 'parallel', 'series'


%--------------------------------------------------------------------------
% --- check and update input
for i = 1:(nargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
switch circuit_type
    case {'par', 'parallel'}
        circuit_type = 0;
    case {'ser', 'series'}
        circuit_type = 1;
end

%--------------------------------------------------------------------------
mi_addcircprop(id_circuit,imax,circuit_type);
%--------------------------------------------------------------------------


