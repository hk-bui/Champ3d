function dir = f_dir3(celem,varargin)

dir1 = f_dir1(celem);
dir2 = f_dir2(celem);

dir = cross(dir1, dir2);