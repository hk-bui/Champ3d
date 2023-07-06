function cinfo = f_femm_getcircuitproperties(id_circuit)
%--------------------------------------------------------------------------
% Call mo_getcircuitproperties
% FEMM
% Author : David Meeker
% Copyright (C) 1998-2015
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

zinfo = mo_getcircuitproperties(id_circuit);

cinfo.i = zinfo(1);
cinfo.v = zinfo(2);
cinfo.flux = zinfo(3);
cinfo.L = cinfo.flux/cinfo.i;


