%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------


% ---
close all
clear
clc
% --- add femm path
addpath(genpath('C:\femm42'));


%% main parameters
x_plate   = 100e-3;
y_plate   = 3e-3;
sig_plate = 40e3;
mur_plate = 1;
l_plate   = 50e-3;
msize     = 5;
x_coil    = 10e-3;
y_coil    = 5e-3;
sig_coil  = 58e6;
agap      = 2e-3;
x_airbox  = x_plate * 2;
y_airbox  = x_plate * 2;
Imax      = 1000;
nb_turns  = 1;
fr        = 200e3;
Iphase    = 'IA'; 
Isign     = +1;

%% FEMM preparation
closefemm
openfemm
newdocument(0) 
%main_maximize;
file2save = 'Inf_line_current_over_plate';
femfile   = [file2save '.fem'];
meshfile  = [file2save '.ans'];
f_femm_saveas(femfile);
meshsize = 2e-3;
minAngle = 10; % fine : 30, big : 10
f_femm_probdef('fr',fr,'min_angle',minAngle);


%% Material list

f_femm_addmaterial('material_name','air');
f_femm_addmaterial('material_name','compos','mur',mur_plate,'sigma',sig_plate);
f_femm_addmaterial('material_name','copper','mur',1,'sigma',sig_coil);

%% Trace out the domains

draw2d = [];
draw2d = f_femm_draw_straightrect(draw2d,'id_draw2d','plate',...
            'center',[0 -y_plate/2],...
            'r_len',x_plate,'theta_len',y_plate);
draw2d = f_femm_draw_straightrect(draw2d,'id_draw2d','agap',...
            'center',[0 agap/2],...
            'r_len',x_plate,'theta_len',agap);
draw2d = f_femm_draw_straightrect(draw2d,'id_draw2d','coil',...
            'center',[0 agap+y_coil/2],...
            'r_len',x_coil,'theta_len',y_coil);
draw2d = f_femm_draw_straightrect(draw2d,'id_draw2d','air',...
            'center',[0 0],...
            'r_len',x_airbox,'theta_len',y_airbox);

%% domain attribution
f_femm_set_block(draw2d,'id_draw2d','air'  ,'method','bottomleft','block_name','air'  ,'meshsize',20*meshsize);
f_femm_set_block(draw2d,'id_draw2d','agap' ,'method','center','block_name','air'  ,'meshsize',meshsize);
f_femm_set_block(draw2d,'id_draw2d','plate','method','center','block_name','compos','meshsize',meshsize, ...
                        'in_circuit','I0','nb_turns',1);
f_femm_set_block(draw2d,'id_draw2d','coil' ,'method','center','block_name','copper' ,'meshsize',meshsize, ...
                        'in_circuit',Iphase,'nb_turns',nb_turns);

%% Boundary conditions
f_femm_setbc_rect([0 0],[x_airbox y_airbox],'A=0');


%% Properties of boundary conditions and circuit

f_femm_addboundprop('id_bc','A=0','bc_type','a=0');
f_femm_addcircprop('id_circuit','IA','imax',Imax,'circuit_type','series');
f_femm_addcircprop('id_circuit','I0','imax',0   ,'circuit_type','series');

%% Mailler
f_femm_createmesh;
f_femm_zoomnatural;

%% Solve

f_femm_analyze(1);
f_femm_loadsolution;
f_femm_zoomnatural;



%%
c3dobj = [];

c3dobj = f_add_layer(c3dobj,'id_layer','lplate' ,'d',l_plate,'dnum',msize,'dtype','lin');

c3dobj = f_add_mesh2d(c3dobj,'id_mesh2d','femm_mesh','build_from','femm','mesh_file',meshfile);

c3dobj = f_add_dom2d(c3dobj,'id_mesh2d','femm_mesh','id_dom2d','coil', ...
                            'elem_code',4);
c3dobj = f_add_dom2d(c3dobj,'id_mesh2d','femm_mesh','id_dom2d','agap', ...
                            'elem_code',2);
c3dobj = f_add_dom2d(c3dobj,'id_mesh2d','femm_mesh','id_dom2d','plate', ...
                            'elem_code',3);
c3dobj = f_add_dom2d(c3dobj,'id_mesh2d','femm_mesh','id_dom2d','air', ...
                            'elem_code',1);

figure;
f_view_c3dobj(c3dobj,'id_mesh2d','femm_mesh','id_dom2d','coil','face_color',f_color(1)); hold on
f_view_c3dobj(c3dobj,'id_mesh2d','femm_mesh','id_dom2d','agap','face_color',f_color(2)); hold on
f_view_c3dobj(c3dobj,'id_mesh2d','femm_mesh','id_dom2d','plate','face_color',f_color(3)); hold on
f_view_c3dobj(c3dobj,'id_mesh2d','femm_mesh','id_dom2d','air','face_color',f_color(4)); hold on


c3dobj = f_add_mesh3d(c3dobj,'mesher','c3d_prismmesh','id_mesh3d','mesh3d_femm', ...
                             'id_layer','lplate','id_mesh2d','femm_mesh');


c3dobj = f_add_dom3d(c3dobj,'id_mesh3d','mesh3d_femm','id_dom3d','coil', ...
                            'id_dom2d','coil','id_layer','lplate');
c3dobj = f_add_dom3d(c3dobj,'id_mesh3d','mesh3d_femm','id_dom3d','agap', ...
                            'id_dom2d','agap','id_layer','lplate');
c3dobj = f_add_dom3d(c3dobj,'id_mesh3d','mesh3d_femm','id_dom3d','plate', ...
                            'id_dom2d','plate','id_layer','lplate');
c3dobj = f_add_dom3d(c3dobj,'id_mesh3d','mesh3d_femm','id_dom3d','air', ...
                            'id_dom2d','air','id_layer','lplate');


figure;
f_view_c3dobj(c3dobj,'id_mesh3d','mesh3d_femm','id_dom3d','coil','face_color',f_color(1)); hold on
f_view_c3dobj(c3dobj,'id_mesh3d','mesh3d_femm','id_dom3d','agap','face_color',f_color(2)); hold on
f_view_c3dobj(c3dobj,'id_mesh3d','mesh3d_femm','id_dom3d','plate','face_color',f_color(3)); hold on
f_view_c3dobj(c3dobj,'id_mesh3d','mesh3d_femm','id_dom3d','air','face_color',f_color(4)); hold on


%% 


%   Post-processing



%--- J surface plate
nbp = 100;
esurf  = 1e-4; 
x_line = linspace(-x_plate/2+1e-6,x_plate/2-1e-6,nbp);
y_line = -(esurf/2) .* ones(1,nbp);
J_co1 = zeros(1,nbp);
for i = 1:nbp
     J_co1(i) = f_femm_getj(x_line(i),y_line(i)) * 1e6;
end
figure
plot(x_line,-real(J_co1),'-or','DisplayName','real(J) sim2D-surface-plate'); hold on
plot(x_line,-imag(J_co1),'-xr','DisplayName','imag(J) sim2D-surface-plate'); hold on

%% circuit properties

cirpro  = f_femm_getcircuitproperties('IA');



