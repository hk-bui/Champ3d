

node = c3dobj.mesh3d.mesh3d_coil_test.node;
elem = c3dobj.mesh3d.mesh3d_coil_test.elem;
mesh = f_mdshexa(node,elem);
mesh = f_intkit3d(mesh);