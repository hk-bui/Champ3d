
clear
clc
close all

%load('data_test_light.mat')
%load('data_test_medium.mat')
load('data_test_dense.mat')
%--------------------------------------------------------------------------
node = mesh.node;
elem = mesh.elem;
con  = f_connexion('hex');
%--------------------------------------------------------------------------
mesh_0 = f_mdshexa(node,elem);
% mesh_2 = f_mdshexa_2(node,elem);
%--------------------------------------------------------------------------
% mesh_1 = f_intkit3d(mesh_0);
mesh_2 = f_intkit3d_2(mesh_0);