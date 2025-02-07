%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

function ischanged = f_is_changed(v1,v2,args)
arguments
    v1
    v2
    args.tol = 1e-9
end
% ---
tol = args.tol;
% ---
ischanged = 0;
% ---
s1 = size(v1);
s2 = size(v2);
% ---
if length(s1) ~= length(s2)
    ischanged = 1;
    return
elseif any(s1 - s2)
    ischanged = 1;
    return
end
% ---
if any((v1 - v2) < -tol) || any((v1 - v2) > +tol)
    ischanged = 1;
end
