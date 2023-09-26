function c3dobj = f_add_timesystem(c3dobj,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'id_timesystem','time_array'};

% --- default input value
id_timesystem = [];
time_array = [];

% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if isempty(id_timesystem)
    id_timesystem = 'timesystem_01';
    %error([mfilename ' : #id_timesystem must be given !']);
end
%--------------------------------------------------------------------------
c3dobj.timesystem.(id_timesystem).time_array   = time_array;

% --- Log message
fprintf(['Add timesystem #' id_timesystem '\n']);





