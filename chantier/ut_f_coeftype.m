clc

% --- parameter
clear p1 p2 p3 p4 p5 p6
p1 = f_make_parameter('f',@sigB,'depend_on','b','from','emdesign3d',...
               'id_cobj','bm_01_3d')
p2 = f_make_parameter('f',@sigBJ,'depend_on',{'b','j'},'from','emdesign3d',...
               'id_cobj','bm_01_3d')
p3 = f_make_parameter('f',@sigB,'depend_on',{'b'},'from','emdesign3d',...
               'id_cobj',{'bm_01_3d','bm_02_3d'})
p4 = f_make_parameter('f',@sigBT,'depend_on',{'b','temp'},'from',{'emdesign3d','thdesign3d'},...
               'id_cobj',{'bm_01_3d','bm_01_3d'})
p5 = f_make_parameter('f',50)
p6 = f_make_parameter('f',@(x,y,z)(x+y+z),'depend_on',{'x','y','z'},...
                          'from','mesh3d','id_cobj','my_mesh3d')

% --- ltensor
clear lt1 lt2 lt3 lt4 lt5
lt1 = f_make_ltensor('type','gtensor',...
    'main_value',p1,'ort1_value',sig_plate,'ort2_value',sig_plate,...
    'main_dir',p6,'ort1_dir',[1 0 0],'ort2_dir',[0 1 0]);

lt2 = 1;
lt3 = [1 2 3; 4 5 6; 7 8 9];

lt4 = f_make_ltensor('type','gtensor',...
    'main_value',1,'ort1_value',2,'ort2_value',4,...
    'main_dir',[0 0 1],'ort1_dir',[1 0 0],'ort2_dir',[0 1 0]);

% --- coef type
for i = 1:4
    coef = ['lt' num2str(i)];
    eval(['ctype = f_coeftype(' coef ')']);
end






