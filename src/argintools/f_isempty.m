function flag = f_isempty(argin)
%F_TO_SCELLARGIN : returns a single cell argin from double cell or string
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

flag = true;
argin = f_to_scellargin(argin);

for i = 1:length(argin)
    if ~isempty(argin{i})
        flag = false;
        break;
    end
end
