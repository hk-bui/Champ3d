function VM = f_norm(V,varargin)
% F_NORM returns the norm of vectors in an array of column vectors.
%--------------------------------------------------------------------------
% VM = F_NORM(V);
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

ntype = 2;

if nargin > 1
    ntype = varargin{1};
end

switch ntype
    case 2
        VM = sqrt(sum(V.^2));
    otherwise
        VM = sqrt(sum(V.^2));
end


end