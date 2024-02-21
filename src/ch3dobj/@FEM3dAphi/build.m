%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

function build(obj)
% ---
obj.build_econductor;
obj.build_mconductor;
obj.build_airbox;
obj.build_bsfield;
obj.build_pmagnet;
obj.build_sibc;
obj.build_nomesh;
obj.build_coil;








