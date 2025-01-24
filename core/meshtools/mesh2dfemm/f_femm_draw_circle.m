function draw2d = f_femm_draw_circle(draw2d,varargin)

%--------------------------------------------------------------------------
% 'ref_point' : coordinates of the center
% 'c_r' : radius
% 'max_angle_len' : maximal angle of segment (default = 2 deg)
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
arglist = {'id_draw2d','c_r','max_angle_len','ref_point'};

% --- default input value
c_r = [];
max_angle_len = []; % in degree
id_draw2d = [];
ref_point = [0 0];

% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
% -------------------------------------------------------------------------
if isempty(max_angle_len)
    max_angle_len = 2;
end
% -------------------------------------------------------------------------
lendr = length(draw2d);
lendr = lendr + 1;
if isempty(id_draw2d)
    id_draw2d = ['XXDraw2dNo' num2str(lendr)];
end
% -------------------------------------------------------------------------
x1 = c_r * cosd(0)   + ref_point(1);
x2 = c_r * cosd(180) + ref_point(1);
y1 = c_r * sind(0)   + ref_point(2);
y2 = c_r * sind(180) + ref_point(2);
mi_drawarc(x1,y1,x2,y2,180,max_angle_len);
mi_drawarc(x2,y2,x1,y1,180,max_angle_len);
% -------------------------------------------------------------------------
sfactor = 1/(1-cosd(max_angle_len/2)) - 1; % -1 for security
eps_r = c_r * (1 - 1/sfactor);
bottom(1) = eps_r * cosd(-90) + ref_point(1);
bottom(2) = eps_r * sind(-90) + ref_point(2);
upper(1)  = eps_r * cosd(+90) + ref_point(1);
upper(2)  = eps_r * sind(+90) + ref_point(2);
left(1)   = eps_r * cosd(180) + ref_point(1);
left(2)   = eps_r * sind(180) + ref_point(2);
right(1)  = eps_r * cosd(0)   + ref_point(1);
right(2)  = eps_r * sind(0)   + ref_point(2);
center    = ref_point;
% -------------------------------------------------------------------------
draw2d(lendr).id_draw2d = id_draw2d;
draw2d(lendr).type = 'circle';
draw2d(lendr).c_r = c_r;
draw2d(lendr).ref_point = ref_point;
draw2d(lendr).center  = center;
draw2d(lendr).bottom  = bottom;
draw2d(lendr).upper   = upper;
draw2d(lendr).left    = left;
draw2d(lendr).right   = right;
draw2d(lendr).max_angle_len = max_angle_len;
% -------------------------------------------------------------------------




