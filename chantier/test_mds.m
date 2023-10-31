
clear
clc
close all

load('data_test_light.mat')
%load('data_test_medium.mat')
%load('data_test_dense.mat')
%--------------------------------------------------------------------------
node = mesh.node;
elem = mesh.elem;
con  = f_connexion('hex');
%--------------------------------------------------------------------------
mesh_0 = f_mdshexa(node,elem);
mesh_2 = f_mdshexa_2(node,elem);
%--------------------------------------------------------------------------


return
% draft
n1 = 2; n2 = 3; n3 = 4;
a1 = 1 : n1*n2*n3;
a2 = reshape(a1,n1*n2,n3);
a3 = reshape(a1,n1,n2,n3);














