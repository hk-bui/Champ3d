
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
mesh_2 = f_meshds3d(mesh,'elem_type','hex','get','_all');
%--------------------------------------------------------------------------
f_comparestruct(mesh_0,mesh_2,'field_name','all_fields');












