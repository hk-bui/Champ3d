

[edge_in_elem, ori_edge_in_elem, sign_edge_in_elem] = f_get_edge_in_elem(c3dobj);

tic
c3dobj.mesh3d.my_mesh3d = f_intkit3d(c3dobj.mesh3d.my_mesh3d);
toc

tic
c3dobj = f_build_econductor(c3dobj);
toc