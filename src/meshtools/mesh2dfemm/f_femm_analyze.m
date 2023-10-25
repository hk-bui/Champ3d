function f_femm_analyze(n)
%--------------------------------------------------------------------------
% Call mi_analyze
% FEMM
% Author : David Meeker
% Copyright (C) 1998-2015
%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2023
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

tic;
fprintf('Solving 2d problem with FEMM');
% ---
mi_analyze(n);
% --- Log message
fprintf(' --- in %.2f s \n',toc);