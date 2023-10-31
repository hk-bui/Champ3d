function dir = f_dir2(celem,varargin)

dir = f_dir1(celem);
dir = cross(dir, [0 1 0]);