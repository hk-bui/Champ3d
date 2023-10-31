function bs = f_bs2(celem,varargin)

% --- valid argument list (to be updated each time modifying function)
arglist = {'fbx','fby','fbz','move_step'};

% --- default input value
fbx = [];
fby = [];
fbz = [];
move_step = [0 0 0];

% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end

% ---
x = celem(1) - move_step(1);
y = celem(2) - move_step(2);
z = celem(3) - move_step(3);
% ---
if isempty(fbx)
    bs(1) = 0;
else
    bs(1) = fbx(x, y, z);
end
% ---
if isempty(fby)
    bs(2) = 0;
else
    bs(2) = fby(x, y, z);
end
% ---
if isempty(fbz)
    bs(3) = 0;
else
    bs(3) = fbz(x, y, z);
end




