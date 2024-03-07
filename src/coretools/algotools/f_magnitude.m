function VM = f_magnitude(V,varargin)
% F_NORM returns the norm of vectors in an array of column vectors.
%--------------------------------------------------------------------------
% VM = F_NORM(V);
%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2023
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

MV  = abs(V);
ang = angle(V);

VM  = MV .* cos(ang);
VM  = sqrt(sum(VM.^2));

% VM = sqrt(sum(V .* conj(V)));
% if ~isreal(V)
%     VM = abs(VM);
% end
