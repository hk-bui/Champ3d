clear m1 m2;

m1 = c3dobj.mesh3d.my_mesh3d;


m2.node = c3dobj.mesh3d.my_mesh3d.node;
m2.elem = c3dobj.mesh3d.my_mesh3d.elem;

m2 = f_meshds3d(m2);
m2.cface = f_barrycenter(m2.node,m2.face);
m2 = f_get_bound_face(m2);
m2.cbface = f_barrycenter(m2.node,m2.bound_face);

id_face_text = {};
for i = 1 : size(m2.face,2)
    id_face_text{i} = num2str(i);
end

id_bface_text = {};
for i = 1 : size(m2.bound_face,2)
    id_bface_text{i} = num2str(m2.id_bound_face(i));
end

figure
subplot(121)
pinfo.Vertices = m2.node.';
pinfo.Faces = m2.face.';
pinfo.FaceColor = 'gr';
pinfo.EdgeColor = 'k';
patch(pinfo); alpha(0.5);
text(m2.cface(1,:),m2.cface(2,:),m2.cface(3,:),id_face_text);
subplot(122)
pinfo.Faces = m2.bound_face.';
patch(pinfo); alpha(0.5);
text(m2.cbface(1,:),m2.cbface(2,:),m2.cbface(3,:),id_bface_text);
