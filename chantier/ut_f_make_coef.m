% ut_f_make_coef

% ---
clc
clear p1 p2 p3 p4 p5 p6
% ---
id_mesh3d = c3dobj.emdesign3d.em_test_open_js.id_mesh3d;
nb_elem   = size(c3dobj.mesh3d.(id_mesh3d).elem, 2);
nb_face   = size(c3dobj.mesh3d.(id_mesh3d).face, 2);
% ---
% id_mesh3d = 'my_mesh3d';
% nb_elem   = 100;
% nb_face   = 400;
% ---
c3dobj.emdesign3d.em_test_open_js.fields.bv    = sparse(1,nb_elem);
c3dobj.emdesign3d.em_test_open_js.fields.jv    = sparse(1,nb_elem);
c3dobj.emdesign3d.em_test_open_js.fields.hv    = sparse(1,nb_elem);
c3dobj.emdesign3d.em_test_open_js.fields.pv    = sparse(1,nb_elem);
c3dobj.emdesign3d.em_test_open_js.fields.av    = sparse(1,nb_elem);
c3dobj.emdesign3d.em_test_open_js.fields.phiv  = sparse(1,nb_elem);
c3dobj.emdesign3d.em_test_open_js.fields.tv    = sparse(1,nb_elem);
c3dobj.emdesign3d.em_test_open_js.fields.omev  = sparse(1,nb_elem);
c3dobj.thdesign3d.th_test_open_js.fields.tempv = sparse(1,nb_elem);
% ---
c3dobj.emdesign3d.em_test_open_js.fields.bs    = sparse(1,nb_face);
c3dobj.emdesign3d.em_test_open_js.fields.js    = sparse(1,nb_face);
c3dobj.emdesign3d.em_test_open_js.fields.hs    = sparse(1,nb_face);
c3dobj.emdesign3d.em_test_open_js.fields.ps    = sparse(1,nb_face);
c3dobj.emdesign3d.em_test_open_js.fields.as    = sparse(1,nb_face);
c3dobj.emdesign3d.em_test_open_js.fields.phis  = sparse(1,nb_face);
c3dobj.emdesign3d.em_test_open_js.fields.ts    = sparse(1,nb_face);
c3dobj.emdesign3d.em_test_open_js.fields.omes  = sparse(1,nb_face);
c3dobj.thdesign3d.th_test_open_js.fields.temps = sparse(1,nb_face);
% ---
%c3dobj.mesh3d.my_mesh3d.cnode = zeros(1,nb_elem);
% ---
%c3dobj = f_add_timesystem(c3dobj,'id_timesystem','em_time','time_array',[0 1 2]);

B(1:3,1:5) = ones(3,5) + 1j .* ones(3,5);

% ---
p1 = f_make_coef('f',@fmurB,...
           'depend_on',{'c3dobj.emdesign3d.em_test_open_js.fields.bv'});
p2 = f_make_coef('f',@fmurB,'depend_on','c3dobj.emdesign3d.em_test_open_js.fields.bv');
p3 = f_make_coef('f',@fmurBT,'depend_on',...
                       {'c3dobj.emdesign3d.em_test_open_js.fields.bv',...
                        'c3dobj.emdesign3d.em_test_open_js.fields.tempv'});
p4 = f_make_coef('f',@fsigT,'depend_on',...
                       {'c3dobj.thdesign3d.th_test_open_js.fields.tempv'});
p5 = f_make_coef('f',50);
p6 = f_make_coef('f',@fdirxyz1,'depend_on','c3dobj.mesh3d.my_mesh3d.cnode');


% ---
c3dobj = f_build_econductor(c3dobj,'id_emdesign3d','em_test_open_js');
% ---
phydomobj = c3dobj.emdesign3d.em_test_open_js.econductor.plate_b;
coef_array1 = f_evalisofun(c3dobj,'phydomobj',phydomobj,'iso_function',p1);
coef_array2 = f_evalisofun(c3dobj,'phydomobj',phydomobj,'iso_function',p2);
coef_array3 = f_evalisofun(c3dobj,'phydomobj',phydomobj,'iso_function',p3);
coef_array4 = f_evalisofun(c3dobj,'phydomobj',phydomobj,'iso_function',p4);
coef_array5 = f_evalisofun(c3dobj,'phydomobj',phydomobj,'iso_function',p5);
coef_array6 = f_evalisofun(c3dobj,'phydomobj',phydomobj,'iso_function',p6);

% ---
for i = 1:6
    param = ['p' num2str(i)]
    eval(['ptype = f_paramtype(' param ')'])
end

% ---
for i = 1:6
    coef = ['coef_array' num2str(i)]
    eval(['ctype = f_coeftype(' coef ')'])
end

return



clc
clear p1 p2 p3 p4 p5 p6
% ---
p1 = f_make_coef('f',@sigB,'depend_on','b','from','emdesign3d',...
               'id_cobj','bm_01_3d')
p2 = f_make_coef('f',@sigBJ,'depend_on',{'b','j'},'from','emdesign3d',...
               'id_cobj','bm_01_3d')
p3 = f_make_coef('f',@sigB,'depend_on',{'b'},'from','emdesign3d',...
               'id_cobj',{'bm_01_3d','bm_02_3d'})
p4 = f_make_coef('f',@sigBT,'depend_on',{'b','temp'},'from',{'emdesign3d','thdesign3d'},...
               'id_cobj',{'bm_01_3d','bm_01_3d'})
p5 = f_make_coef('f',50)
p6 = f_make_coef('f',@dirxyz1,'depend_on','cnode','from','mesh3d',...
                      'id_cobj',{'my_mesh3d'})

% ---
for i = 1:5
    param = ['p' num2str(i)]
    eval(['ptype = f_paramtype(' param ')'])
end
% ---
all(isfield(p5,{'from','id_cobj','field'}))

node = rand(3,10);
aaa1 = feval(@dirxyz1,node);
aaa2 = feval(@dirxyz2,node);




