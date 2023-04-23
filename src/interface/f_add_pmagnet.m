function design3d = f_add_pmagnet(design3d,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'design3d','id_dom3d','id_elem','mur','br_value','br_ori','id_bcon'};

% --- default input value
id_dom3d = [];
id_elem  = [];
br_value = 0;
br_ori   = [];
id_bcon  = [];
id_pmagnet = [];
mur = 1;
%--------------------------------------------------------------------------
if ~isfield(design3d,'pmagnet')
    design3d.pmagnet = [];
end
%--------------------------------------------------------------------------
if nargin <= 1
    error([mfilename ': No permanent magnet to add!']);
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

if isempty(id_pmagnet)
    error([mfilename ': id_pmagnet must be defined !'])
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
design3d.pmagnet.(id_pmagnet).id_dom3d = id_dom3d;
design3d.pmagnet.(id_pmagnet).id_elem  = id_elem;
design3d.pmagnet.(id_pmagnet).mur      = mur;
design3d.pmagnet.(id_pmagnet).br_value = br_value;
design3d.pmagnet.(id_pmagnet).br_ori   = br_ori;
design3d.pmagnet.(id_pmagnet).id_bcon  = id_bcon;
% --- info message
fprintf(['Add pmagnet ' id_pmagnet ' - done \n']);



