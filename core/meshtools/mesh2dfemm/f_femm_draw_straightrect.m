function draw2d = f_femm_draw_straightrect(draw2d,varargin)

%--------------------------------------------------------------------------
% 'center_y_theta' : angle of the center (degree)
% 'center_x_r' : radius of the center
% 'r_size' : interior radius
% 'theta_size' : exterior radius
% 'c_xy' : xy-coordinates of the center
%--------------------------------------------------------------------------
% FEMM
% Author : David Meeker
% Copyright (C) 1998-2015
%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2023
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'id_draw2d','center_y_theta','center_x_r','len_x_r','len_y_theta','center','ref_point'};

% --- default input value
coordinate_system = 'Oxy'; % 'rtheta'
len_x_r     = [];
len_y_theta = [];
center     = [];
center_x_r        = [];
center_y_theta    = 0;
id_draw2d  = [];
ref_point  = [0 0];

% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
% -------------------------------------------------------------------------
lendr = length(draw2d);
lendr = lendr + 1;
if isempty(id_draw2d)
    id_draw2d = ['XXDraw2dNo' num2str(lendr)];
end
% -------------------------------------------------------------------------
if ~isempty(center_x_r) && ~isempty(center_y_theta)
    center(1) = center_x_r * cosd(center_y_theta);
    center(2) = center_x_r * sind(center_y_theta);
end
% ---
rsizevec = len_x_r/2 .* [cosd(center_y_theta) sind(center_y_theta)];
tsizevec = len_y_theta/2 .* [cosd(center_y_theta+90) sind(center_y_theta+90)];
diagvec1 = +rsizevec + tsizevec;
diagvec2 = -rsizevec + tsizevec;
% ---
d1 = center - diagvec1 + ref_point;
d2 = center - diagvec2 + ref_point;
d3 = center + diagvec1 + ref_point;
d4 = center + diagvec2 + ref_point;
% ---
mi_drawline(d1(1),d1(2),d2(1),d2(2));
mi_drawline(d2(1),d2(2),d3(1),d3(2));
mi_drawline(d3(1),d3(2),d4(1),d4(2));
mi_drawline(d4(1),d4(2),d1(1),d1(2));
% -------------------------------------------------------------------------
sfactor  = 1e2;
bottomright = center - diagvec1*(1-1/sfactor) + ref_point;
upperright  = center - diagvec2*(1-1/sfactor) + ref_point;
bottomleft  = center + diagvec1*(1-1/sfactor) + ref_point;
upperleft   = center + diagvec2*(1-1/sfactor) + ref_point;
% -------------------------------------------------------------------------
draw2d(lendr).id_draw2d = id_draw2d;
draw2d(lendr).type = 'straight_rectangle';
draw2d(lendr).center_y_theta = center_y_theta;
draw2d(lendr).center_x_r = center_x_r;
draw2d(lendr).ref_point = ref_point;
draw2d(lendr).center = center;
draw2d(lendr).len_x_r = len_x_r;
draw2d(lendr).len_y_theta = len_y_theta;
draw2d(lendr).c_vector = [cosd(center_y_theta) sind(center_y_theta)];
draw2d(lendr).bottomright = bottomright;
draw2d(lendr).bottomleft  = bottomleft;
draw2d(lendr).upperright  = upperright;
draw2d(lendr).upperleft   = upperleft;
% -------------------------------------------------------------------------


