function design3d = f_add_bcon_em(design3d,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'defined_on','id_bcon','id_dom3d','bc_type','bc_value',...
           'sigma','mur'};

% --- default input value

id_dom3d = [];
id_elem  = [];
bc_type  = [];
id_bcon  = [];
defined_on = [];
bc_value = 0;
bc_coef  = 0;
sigma    = 0;
mur      = 1;
%--------------------------------------------------------------------------
if ~isfield(design3d,'bcon')
    design3d.bcon = [];
end
%--------------------------------------------------------------------------
if nargin <= 1
    error([mfilename ': No boundary condition to add!']);
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

if isempty(id_bcon)
    error([mfilename ': id_bcon must be defined !'])
end

if isempty(defined_on)
    error([mfilename ': defined_on must be specified !'])
end

if ~isfield(design3d,'dom3d')
    error([mfilename ': dom3d is not defined !']);
end

if isempty(id_dom3d) && isempty(id_elem)
    error([mfilename ': id_dom3d or id_elem must be defined !'])
end

%--------------------------------------------------------------------------
if isempty(bc_type)
    error([mfilename ': bc_type (fixed, neumann, sibc) must be defined !']);
end
%--------------------------------------------------------------------------
if ~isempty(id_dom3d)
    id_elem = design3d.dom3d.(id_dom3d).id_elem;
end

% --- info message
fprintf(['Add bcon ' id_bcon ' - done \n']);




