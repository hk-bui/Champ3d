%--------------------------------------------------------------------------
clear mesh3d
node = c3dobj.mesh3d.my_mesh3d.node;
elem = c3dobj.mesh3d.my_mesh3d.elem(:,...
                [c3dobj.mesh3d.my_mesh3d.dom3d.coil.id_elem ...
                 c3dobj.mesh3d.my_mesh3d.dom3d.plate.id_elem]);
[bound_face, lid_bound_face, info] = ...
    f_boundface(elem,node,'elem_type','hex','get','ndec','n_component',1);
%mesh3d = f_boundface(mesh3d,'get','ndec','n_component',1);
nb_bf  = length(bound_face);

figure
for i = 1:nb_bf
    f_view_face(node,bound_face{i},'face_color',f_color(i)); hold on
end