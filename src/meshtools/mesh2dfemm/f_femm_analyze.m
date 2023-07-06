function f_femm_analyze(n)
%--------------------------------------------------------------------------
% Call mi_analyze
% FEMM
% Author : David Meeker
% Copyright (C) 1998-2015
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

tic;
fprintf('Solving 2d problem with FEMM');
% ---
mi_analyze(n);
% --- Log message
fprintf(' --- in %.2f s \n',toc);