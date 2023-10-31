clear
clc

% ----
% hex
elem = [3 2 4 9; 8 12 7 1; 3 2 12 8; 2 4 7 12; 9 4 7 1; 3 9 1 8].'
% prism
%elem = [3 2 9; 8 7 1].'
%elem = [3 2 7 8; 3 9 1 8; 2 9 1 7].'
%---
flag = ones(1,size(elem,2));
dim = size(elem,1); len = size(elem,2);
[~,imin] = sort(elem); ormin = mod(imin(1,:),dim); ormin(ormin==0) = dim;
ornex = mod(ormin + 1, dim); ornex(ornex==0) = dim;
orpre = mod(ormin - 1, dim); orpre(orpre==0) = dim;
ornex = sub2ind(size(elem),ornex,1:len);
orpre = sub2ind(size(elem),orpre,1:len);
ori = elem(orpre) - elem(ornex);
ie2sort = find(ori < 0);
elem(:,ie2sort) = elem(end:-1:1,ie2sort)
flag(ie2sort) = -1;
flag