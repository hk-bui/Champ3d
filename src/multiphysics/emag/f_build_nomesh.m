function c3dobj = f_build_nomesh(c3dobj,varargin)
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
arglist = {'id_emdesign','id_nomesh'};

% --- default input value
id_emdesign = [];
id_nomesh = '_all';

% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if isempty(id_emdesign)
    error([mfilename ': #id_emdesign must be given']); 
end
%--------------------------------------------------------------------------
if iscell(id_emdesign)
    id_emdesign = id_emdesign{1};
end
%--------------------------------------------------------------------------
dim = c3dobj.emdesign.(id_emdesign).dimension;
%--------------------------------------------------------------------------
id_nomesh = f_to_scellargin(id_nomesh);
%--------------------------------------------------------------------------
if any(strcmpi(id_nomesh,{'_all'}))
    if isfield(c3dobj.emdesign.(id_emdesign),'nomesh')
        id_nomesh = fieldnames(c3dobj.emdesign.(id_emdesign).nomesh);
    else
        return
    end
end
%--------------------------------------------------------------------------
for iec = 1:length(id_nomesh)
    id_phydom = id_nomesh{iec};
    to_be_rebuilt = c3dobj.emdesign.(id_emdesign).nomesh.(id_phydom).to_be_rebuilt;
    if to_be_rebuilt
        %------------------------------------------------------------------
        em_model = c3dobj.emdesign.(id_emdesign).em_model;
        %------------------------------------------------------------------
        f_fprintf(0,'Build #nomesh',1,id_phydom, ...
                  0,'in #emdesign',1,id_emdesign, ...
                  0,'for',1,em_model,0,'\n');
        tic;
        %------------------------------------------------------------------
        if dim == 3
            id_mesh = c3dobj.emdesign.(id_emdesign).id_mesh3d;
        elseif dim == 2
            id_mesh = c3dobj.emdesign.(id_emdesign).id_mesh2d;
        end
        %------------------------------------------------------------------
        phydomobj = c3dobj.emdesign.(id_emdesign).nomesh.(id_phydom);
        %------------------------------------------------------------------
        switch em_model
            case {'3d_fem_aphijw','3d_fem_aphits'}
                id_dom3d = phydomobj.id_dom3d;
                id_dom3d = f_to_scellargin(id_dom3d);
                % ---
                id_elem = [];
                id_face = [];
                id_edge = [];
                bound_face = [];
                for i = 1:length(id_dom3d)
                    defined_on = c3dobj.mesh3d.(id_mesh).dom3d.(id_dom3d{i}).defined_on;
                    if any(f_strcmpi(defined_on,'elem'))
                        id_elem = [id_elem ...
                            c3dobj.mesh3d.(id_mesh).dom3d.(id_dom3d{i}).id_elem];
                        bfa = f_get_bound_face(c3dobj,'of_dom3d',id_dom3d{i});
                        bound_face = [bound_face, bfa];
                    elseif any(f_strcmpi(defined_on,'face'))
                        id_face = [id_face ...
                            c3dobj.mesh3d.(id_mesh).dom3d.(id_dom3d{i}).id_face];
                    elseif any(f_strcmpi(defined_on,'edge'))
                        id_edge = [id_edge ...
                            c3dobj.mesh3d.(id_mesh).dom3d.(id_dom3d{i}).id_edge];
                    end
                end
                %----------------------------------------------------------
                edge_list = c3dobj.mesh3d.(id_mesh).edge;
                %----------------------------------------------------------
                % --- Output
                c3dobj.emdesign.(id_emdesign).nomesh.(id_phydom).id_elem = id_elem;
                c3dobj.emdesign.(id_emdesign).nomesh.(id_phydom).id_face = id_face;
                c3dobj.emdesign.(id_emdesign).nomesh.(id_phydom).id_edge = id_edge;
                %----------------------------------------------------------
                elem = c3dobj.mesh3d.(id_mesh).elem(:,id_elem);
                %----------------------------------------------------------
                id_bound_node = f_uniquenode(bound_face);
                %----------------------------------------------------------
                id_edge_in_bound_face = f_edgeinface(bound_face,edge_list);
                id_edge_in_bound_face = unique(id_edge_in_bound_face);
                %----------------------------------------------------------
                id_node_in_elem = f_uniquenode(elem);
                id_edge_in_elem = f_edgeinelem(elem,edge_list);
                id_edge_in_elem = unique(id_edge_in_elem);
                %----------------------------------------------------------
                id_inner_node = setdiff(id_node_in_elem,id_bound_node);
                id_inner_edge = setdiff(id_edge_in_elem,id_edge_in_bound_face);
                id_bound_edge = id_edge_in_bound_face;
                %----------------------------------------------------------
                % --- Output
                c3dobj.emdesign.(id_emdesign).nomesh.(id_phydom).id_elem = id_elem;
                c3dobj.emdesign.(id_emdesign).nomesh.(id_phydom).id_inner_node = id_inner_node;
                c3dobj.emdesign.(id_emdesign).nomesh.(id_phydom).id_bound_node = id_bound_node;
                c3dobj.emdesign.(id_emdesign).nomesh.(id_phydom).id_inner_edge = id_inner_edge;
                c3dobj.emdesign.(id_emdesign).nomesh.(id_phydom).id_bound_edge = id_bound_edge;
                %----------------------------------------------------------
                c3dobj.emdesign.(id_emdesign).nomesh.(id_phydom).to_be_rebuilt = 0;
                %----------------------------------------------------------
            case {'3d_fem_tomejw','3d_fem_tomets'}
                % TODO
        end
        % --- Log message
        f_fprintf(0,'--- in',...
                  1,toc, ...
                  0,'s \n');
    end
end












