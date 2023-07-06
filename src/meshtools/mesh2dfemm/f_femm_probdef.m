function f_femm_probdef(varargin)
%--------------------------------------------------------------------------
% Call mi_probdef
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
arglist = {'fr','unit','problem_type','precision','depth','min_angle','acsolver'};

% --- default input value
fr = 0;
unit = 'meters';
problem_type = 'planar'; % 'planar', 'axi
precision = 1E-08;
depth = 0;
min_angle = 10;
acsolver = 'newton'; % 'newton', 'successive_approximation'
%--------------------------------------------------------------------------
% --- check and update input
for i = 1:(nargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': Check function arguments : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if strcmpi(acsolver,'newton')
    acsolver = 1;
else
    acsolver = 0;
end
%--------------------------------------------------------------------------
mi_probdef(fr, unit, problem_type, precision, depth, min_angle, acsolver);
%--------------------------------------------------------------------------


