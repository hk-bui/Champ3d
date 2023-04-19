function design3d = f_build_nomesh_aphi(design3d,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

if isfield(design3d,'nomesh')
    nb_nomesh = length(design3d.nomesh);
    for i = 1:nb_nomesh
        design3d.aphi.id_edge_a = unique(setdiff(...
            design3d.aphi.id_edge_a,design3d.nomesh.id_inside_edge));
    end
end


