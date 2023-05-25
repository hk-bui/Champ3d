

% PMSM
% for validation of champ3d


% close all
clear
clc
thisPath = pwd; % this actual path

addpath(genpath('C:\femm42'));

%% main parameters
lPlate     = 100e-3;
hPlateUp   = 3e-3;
hPlateDo   = 1e-3;
sigPlateUp = 40e3;
sigPlateDo = 58e6;
murPlate = 1;
lCoil    = 10e-3;
hCoil    = 5e-3;
sigCoil  = 58e6;
agap     = 2e-3;
abox     = lPlate * 2;
Imax     = 1000;
nb_turns = 1;
fr       = 200e3;
Iphase   = 'IA'; 
Isign    = +1;

%% FEMM preparation
closefemm
openfemm
newdocument(0) 
%main_maximize;
file2save = 'Inf_line_current_over_plate';
femfile   = [file2save '.fem'];
meshfile  = [file2save '.ans'];
mi_saveas(femfile);
meshsize = 0.2e-3;
minAngle = 10; % fine : 30, big : 10
mi_probdef(fr,'meters','planar',1E-08,0,minAngle,1);


%% Material list

f_femm_addmaterial('material_name','air');
f_femm_addmaterial('material_name','compos','mur',murPlate,'sigma',sigPlateUp);
f_femm_addmaterial('material_name','lsp','mur',murPlate,'sigma',sigPlateDo);
f_femm_addmaterial('material_name','copper','mur',1,'sigma',sigCoil);

%% Trace out the domains

draw2d = [];
draw2d = f_femm_draw_straightrect(draw2d,'id_draw2d','plateDo',...
            'center',[0 -hPlateUp-hPlateDo/2],...
            'r_len',lPlate,'theta_len',hPlateDo);
draw2d = f_femm_draw_straightrect(draw2d,'id_draw2d','plateUp',...
            'center',[0 -hPlateUp/2],...
            'r_len',lPlate,'theta_len',hPlateUp);
draw2d = f_femm_draw_straightrect(draw2d,'id_draw2d','agap',...
            'center',[0 agap/2],...
            'r_len',lPlate,'theta_len',agap);
draw2d = f_femm_draw_straightrect(draw2d,'id_draw2d','coil',...
            'center',[0 agap+hCoil/2],...
            'r_len',lCoil,'theta_len',hCoil);
draw2d = f_femm_draw_straightrect(draw2d,'id_draw2d','air',...
            'center',[0 0],...
            'r_len',abox,'theta_len',abox);

%% domain attribution
f_femm_set_block(draw2d,'id_draw2d','air'  ,'method','bottomleft','block_name','air'  ,'meshsize',20*meshsize);
f_femm_set_block(draw2d,'id_draw2d','agap' ,'method','center','block_name','air'  ,'meshsize',meshsize);
f_femm_set_block(draw2d,'id_draw2d','plateUp','method','center','block_name','compos','meshsize',meshsize, ...
                        'in_circuit','I01','nb_turns',1);
f_femm_set_block(draw2d,'id_draw2d','plateDo','method','center','block_name','lsp','meshsize',meshsize, ...
                        'in_circuit','I02','nb_turns',1);
f_femm_set_block(draw2d,'id_draw2d','coil' ,'method','center','block_name','copper' ,'meshsize',meshsize, ...
                        'in_circuit',Iphase,'nb_turns',nb_turns);

%% Boundary conditions
f_femm_setbc_rect([0 0],[abox abox],'A=0');


%% Properties of boundary conditions and circuit

mi_addboundprop('A=0',0,0,0,0,0,0,0,0,0);
mi_addcircprop('IA',Imax,1);
mi_addcircprop('I01',0,1);
mi_addcircprop('I02',0,1);
%% Mailler
mi_createmesh;
mi_zoomnatural;

%% Solve
tic
mi_analyze(1);
mi_loadsolution;
mi_zoomnatural;
toc



%%
dom2d = [];
dom2d = f_load_femm_mesh(dom2d,'meshfile',meshfile);
% figure; f_view_mesh_2d(dom2d,'plotter','champ3d');

%% 


%   Post-processing



%--- J surface plate
nbp = 100;
esurf  = 1e-4; 
x_line = linspace(-lPlate/2+1e-6,lPlate/2-1e-6,nbp);
y_line = -(esurf/2) .* ones(1,nbp);
J_co1 = zeros(1,nbp);
for i = 1:nbp
     J_co1(i) = mo_getj(x_line(i),y_line(i)) * 1e6;
end
figure
plot(x_line,-real(J_co1),'-or','DisplayName','real(J) sim2D-surface-plate'); hold on
plot(x_line,-imag(J_co1),'-xr','DisplayName','imag(J) sim2D-surface-plate'); hold on

%% circuit properties

cirpro  = mo_getcircuitproperties('IA');
Current = cirpro(1);
Voltage = cirpro(2);
Flux    = cirpro(3);
Lind    = Flux/Current;








