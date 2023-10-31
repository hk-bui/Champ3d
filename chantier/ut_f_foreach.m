clear
close all
clc

% -------------------------------------------------------------------------
B = [];
T = [];
nb_elem = 5;
B(1:3,1:nb_elem) = ones(3,nb_elem) + 1j .* ones(3,nb_elem);
T(1:nb_elem,1) = linspace(25,100,nb_elem);
f = @fmurBT;
% ---
vout = f_foreach(f,'argument_array',{B, T})

% -------------------------------------------------------------------------
cnode = [];
nb_elem = 5;
cnode(1,1:nb_elem) = 1 .* ones(1,nb_elem);
cnode(2,1:nb_elem) = 2 .* ones(1,nb_elem);
cnode(3,1:nb_elem) = 3 .* ones(1,nb_elem);

f = @fbr_dir;
% ---
vout = f_foreach(f,'argument_array',cnode)