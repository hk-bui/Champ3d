function validvarargin = f_validvarargin(vararginlist,validarglist)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

validvarargin = {};
k = 0;
for i = 1:length(vararginlist)/2
    if any(strcmpi(vararginlist{2*i-1},validarglist))
        k = k + 1;
        validvarargin{2*k-1} = vararginlist{2*i-1};
        validvarargin{2*k}   = vararginlist{2*i};
    end
end