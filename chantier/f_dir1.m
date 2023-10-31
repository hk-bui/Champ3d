function dir = f_dir1(celem,varargin)

dir1_ref = [0 0 1];
rot_axis = [0 1 0];
if celem(1) > 0
    ang = +45;
else
    ang = -45;
end

dir = f_rotaroundaxis(dir1_ref,'rot_axis',rot_axis,'angle',ang);
