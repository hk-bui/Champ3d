%% view 2d mesh
figure
f_view_c3dobj(c3dobj,'id_mesh2d','my_mesh2d','face_color','w'); hold on
f_view_c3dobj(c3dobj,'id_dom2d','plate','face_color',f_color(1));
f_view_c3dobj(c3dobj,'id_dom2d','coil','face_color',f_color(2));
f_view_c3dobj(c3dobj,'id_dom2d','agap','face_color',f_color(3));

%% view 3d mesh

figure
f_view_c3dobj(c3dobj,'id_mesh3d','my_mesh3d','face_color','none','edge_color','k'); hold on
f_view_c3dobj(c3dobj,'id_dom3d','plate','face_color',f_color(1)); hold on
f_view_c3dobj(c3dobj,'id_dom3d','coil','face_color',f_color(2));  hold on
f_view_c3dobj(c3dobj,'id_dom3d','coil_surface','face_color',f_color(4));  hold on
f_view_c3dobj(c3dobj,'id_dom3d','agap','face_color',f_color(5));  hold on

%--------------------------------------------------------------------------
figure
f_view_c3dobj(c3dobj,'id_mesh3d','my_mesh3d','face_color','none','edge_color','k'); hold on
f_view_c3dobj(c3dobj,'id_emdesign3d','bm_01_3d',...
              'id_econductor','plate','face_color',f_color(1),'alpha_value',0.5); hold on
f_view_c3dobj(c3dobj,'id_emdesign3d','bm_01_3d',...
              'id_coil','coil01','face_color',f_color(2),'alpha_value',0.5);  hold on
