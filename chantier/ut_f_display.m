
p4 = f_make_parameter('f',@sigBT,'depend_on',{'b','temp'},'from',{'emdesign3d','thdesign3d'},...
               'id_cobj',{'bm_01_3d','bm_01_3d'});
f_display(p4,'is a tensor');
f_display([1 2 3],'is a vector',1,'is a number');