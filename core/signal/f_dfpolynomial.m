%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2025
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

function dfx = f_dfpolynomial(fx)

% --- keeped data for the derivative of piece-wise polynomial
dfx.form = fx.form;
dfx.breaks = fx.breaks;
dfx.pieces = fx.pieces;
dfx.dim = fx.dim;
% --- derivative -> lower order
dfx.order = fx.order - 1;
% --- coef
ofxt = fx.order;
nbpt = size(fx.coefs, 1);
dfx.coefs = zeros(nbpt, ofxt-1);
for i = 1 : ofxt-1
    % --- highest order first
    dfx.coefs(:,i) = (ofxt-i) * fx.coefs(:,i);
end
% ---

end