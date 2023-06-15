function [vecout,ivec] = f_groupsort(vecin,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

[vecin,iv] = sort(vecin);
dvec  = diff([vecin(1) vecin]);
idv   = find(dvec ~= 0);
idv   = [1 idv length(vecin)+1];

ivec = {};
vecout = {};
for i = 1 : length(idv)-1
    ivec{i} = iv(idv(i) : idv(i+1)-1);
    vecout{i} = vecin(idv(i));
end




