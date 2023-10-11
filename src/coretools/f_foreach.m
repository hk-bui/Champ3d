function vout = f_foreach(f,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'argument_array'};

% --- default input value
argument_array = {};

% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if ~isa(f,'function_handle')
    error([mfilename ': #f must be a function handle !']);
end
%--------------------------------------------------------------------------
argument_array = f_to_scellargin(argument_array);
if f_nargin(f) ~= length(argument_array)
    error([mfilename ': Check number of f arguments !']);
end
%--------------------------------------------------------------------------
nb_arg = length(argument_array);
nb_elem__ = zeros(1,nb_arg);
for i = 1:nb_arg
    nb_elem__(i) = length(argument_array{i});
end
%--------------------------------------------------------------------------
if nb_arg > 1
    if ~all(diff(nb_elem__) == 0)
        error([mfilename ': Check size of #argument_array !']);
    end
end
%--------------------------------------------------------------------------
nb_elem = nb_elem__(1);
vout = 










