function f_view_mesh3d(node,elem,varargin)
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
arglist = {'elem_type','defined_on','face_color','edge_color','alpha_value'};

% --- default input value
elem_type   = '';
defined_on  = 'elem'; % elem, face, edge
edge_color  = 'none';
face_color  = 'w';
alpha_value = 1;
% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if any(strcmpi(defined_on,{'elem','face'}))
    elem_type = f_elemtype(elem,'defined_on',defined_on);
end
%--------------------------------------------------------------------------
transarg = {'edge_color',edge_color,'face_color',face_color,'alpha_value',alpha_value};
%--------------------------------------------------------------------------
switch defined_on
    case {'elem'}
        % ---
        %mshds.node = node;
        %mshds.elem = elem;
        %mshds = f_meshds3d(mshds,'output_list','face');
        %mshds = f_get_bound_face(mshds,'elem_type',elem_type);
        % ---
        %face_in_elem = mshds.face_in_elem;
        %face = mshds.face;
        %id_face = reshape(face_in_elem, 1, []);
        %id_face = unique(id_face);
        % ---
        face = f_boundface(elem,node,'elem_type',elem_type);
        id_face = 1:size(face,2);
        % ---
        % 1/ triangle
        ind_tria = find(face(end, id_face) == 0);
        if ~isempty(ind_tria)
            triface  = face(1:3,id_face(ind_tria));
            f_view_face(node, triface, transarg{:}); hold on
        end
        % ---
        % 2/ quad
        ind_quad = find(face(end, id_face) ~= 0);
        if ~isempty(ind_quad)
            quadface = face(1:4,id_face(ind_quad));
            f_view_face(node, quadface, transarg{:}); hold on
        end
        view(3);
    case {'face'}
        id_face = 1:size(elem, 2);
        % 1/ triangle
        ind_tria = find(elem(end, :) == 0);
        if ~isempty(ind_tria)
            triface  = elem(1:3,ind_tria);
            f_view_face(node, triface, transarg{:}); hold on
        end
        % ---
        % 2/ quad
        ind_quad = setdiff(id_face, ind_tria);
        if ~isempty(ind_quad)
            quadface  = elem(1:4,ind_quad);
            f_view_face(node, quadface, transarg{:}); hold off
        end
        view(3);
    case {'edge'}
    case {'node'}
        % ---
        if size(node,1) == 2
            plot(node(1,elem),node(2,elem),['o' face_color],'MarkerFaceColor',face_color);
            axis tight; axis equal; box on;
            xlabel('x (m)'); ylabel('y (m)');
        elseif size(node,1) == 3
            plot3(node(1,elem),node(2,elem),node(3,elem),['o' face_color],'MarkerFaceColor',face_color);
            axis tight; axis equal; box on; view(3);
            xlabel('x (m)'); ylabel('y (m)'); zlabel('z (m)'); 
        end
end