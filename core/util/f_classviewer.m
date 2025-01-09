function clViewer = f_classviewer(ch3obj_path)
%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2025
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

arguments
    ch3obj_path = []
end
% ---
clViewer = [];
% ---
if isempty(ch3obj_path)
    ch3obj_path = fileparts(which('Mesh.m'));
end
% ---
clNames = what(ch3obj_path);
clNames = clNames.m;
for i = 1:length(clNames)
    clNames{i} = replace(clNames{i},'.m','');
end
% ---
clViewer = matlab.diagram.ClassViewer();
% ---
for i = 1:length(clNames)
    addClass(clViewer,clNames{i});
end
