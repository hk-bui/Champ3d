
clear
clc

load data_c3dobj_test

m1 = f_get_bound_face(c3dobj);
m1b = f_get_bound_face(c3dobj,'of_dom3d',{'coil','plate'});

m2 = f_get_edge(c3dobj);

m2b = f_get_edge(c3dobj,'of_dom3d',{'coil'});

m3 = f_get_edge_in_elem(c3dobj);

m3b = f_get_edge_in_elem(c3dobj,'of_dom3d',{'coil','plate'});

m4 = f_get_edge_in_face(c3dobj);

m5 = f_get_face(c3dobj);

m6 = f_get_face_in_elem(c3dobj);

return

lhs_rhs = combnk([1:6],2);

for i = 1:length(lhs_rhs(:,1))
    mlhs = ['m' num2str(lhs_rhs(i,1))];
    mrhs = ['m' num2str(lhs_rhs(i,2))];
    fprintf([mlhs ' vs ' mrhs '\n'])
    eval(['lhs = ' mlhs ';'])
    eval(['rhs = ' mrhs ';'])
    f_comparestruct(lhs,rhs);
end

mx = c3dobj.mesh3d.my_mesh3d;
mx = f_meshds3d(mx,'elem_type','hex','get','all');

for i = 1:6
    mlhs = ['m' num2str(i)];
    mrhs = ['mx'];
    fprintf([mlhs ' vs ' mrhs '\n'])
    eval(['lhs = ' mlhs ';'])
    eval(['rhs = ' mrhs ';'])
    f_comparestruct(lhs,rhs);
end




