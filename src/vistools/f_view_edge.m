function f_view_edge(node,edge,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'edge_color'};

% --- default input value
edge_color  = 'k';

% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
x1 = node(1,edge(1,:));
x2 = node(1,edge(2,:));
y1 = node(2,edge(1,:));
y2 = node(2,edge(2,:));
z1 = node(3,edge(1,:));
z2 = node(3,edge(2,:));
%--------------------------------------------------------------------------
x = [x1; x2];
y = [y1; y2];
z = [z1; z2];
%--------------------------------------------------------------------------
line(x,y,z, 'color', edge_color); view(3)
%--------------------------------------------------------------------------
















