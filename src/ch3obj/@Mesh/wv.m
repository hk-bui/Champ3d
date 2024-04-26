%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

function Wv = wv(obj,args)

arguments
    obj
    args.cdetJ = [];
end

% ---
cdetJ = args.cdetJ;
%--------------------------------------------------------------------------
elem_type = obj.elem_type;
%--------------------------------------------------------------------------
node = obj.node;
elem = obj.elem;
%--------------------------------------------------------------------------
if any(f_strcmpi(elem_type,{'tri','triangle','quad'}))
    Wv{1} = 1./f_area(node,elem,'elem_type',elem_type,'cdetJ',cdetJ);
elseif any(f_strcmpi(elem_type,{'tet','tetra','prism','hex','hexa'}))
    Wv{1} = 1./f_volume(node,elem,'elem_type',elem_type,'cdetJ',cdetJ);
end
%--------------------------------------------------------------------------