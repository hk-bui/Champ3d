function c3dobj = f_build_airbox(c3dobj,varargin)
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
arglist = {'id_emdesign','id_airbox'};

% --- default input value
id_emdesign = [];
id_airbox = [];

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
if isempty(id_airbox)
    if isfield(c3dobj.emdesign.(id_emdesign),'airbox')
        id_airbox_ = fieldnames(c3dobj.emdesign.(id_emdesign).airbox);
        for iab = 1:length(id_airbox_)
            if ~strcmpi(id_airbox_{iab},'airbox_by_default')
                id_airbox = id_airbox_{iab};
                break; % take the first not by default
            end
        end
    end
end
%--------------------------------------------------------------------------
dim = c3dobj.emdesign.(id_emdesign).dimension;
%--------------------------------------------------------------------------
if isempty(id_airbox)
    id_airbox = 'airbox_by_default';
    if dim == 3
        %c3dobj = f_add_dom3d(c3dobj,'id_dom3d','airbox_by_default');
        c3dobj = f_add_airbox(c3dobj,'id_emdesign',id_emdesign,...
                              'id_airbox',id_airbox, ...
                              'id_dom3d','all_domain');
    elseif dim == 2
        %c3dobj = f_add_dom2d(c3dobj,'id_dom2d','airbox_by_default');
        c3dobj = f_add_airbox(c3dobj,'id_emdesign',id_emdesign,...
                              'id_airbox',id_airbox, ...
                              'id_dom2d','all_domain');
    end
end
%--------------------------------------------------------------------------
id_airbox = f_to_scellargin(id_airbox);
id_airbox = id_airbox{1}; % cannot treat two airbox
%--------------------------------------------------------------------------
tic;
to_be_rebuilt = c3dobj.emdesign.(id_emdesign).airbox.(id_airbox).to_be_rebuilt;
if to_be_rebuilt
    %----------------------------------------------------------------------
    em_model = c3dobj.emdesign.(id_emdesign).em_model;
    %----------------------------------------------------------------------
    f_fprintf(0,'Build #airbox',1,id_airbox, ...
              0,'in #emdesign',1,id_emdesign, ...
              0,'for',1,em_model,0,'\n');
    %----------------------------------------------------------------------
    tic;
    %----------------------------------------------------------------------
    if dim == 3
        id_mesh = c3dobj.emdesign.(id_emdesign).id_mesh3d;
    elseif dim == 2
        id_mesh = c3dobj.emdesign.(id_emdesign).id_mesh2d;
    end
    %----------------------------------------------------------------------
    phydomobj = c3dobj.emdesign.(id_emdesign).airbox.(id_airbox);
    %----------------------------------------------------------------------
    phydomobj = f_get_id(c3dobj,phydomobj);
    id_elem   = phydomobj.id_elem;
    %----------------------------------------------------------------------
    switch em_model
        case {'3d_fem_aphijw','3d_fem_aphits'}
            %--------------------------------------------------------------
            id_dom3d  = phydomobj.id_dom3d;
            %--------------------------------------------------------------
            elem = c3dobj.mesh3d.(id_mesh).elem(:,id_elem);
            %--------------------------------------------------------------
            id_node = f_uniquenode(elem);
            %--------------------------------------------------------------
            bound_face = f_get_bound_face(c3dobj,'of_dom3d',id_dom3d);
            %--------------------------------------------------------------
            edge_list = c3dobj.mesh3d.(id_mesh).edge;
            id_edge_in_bound_face = f_edgeinface(bound_face,edge_list);
            id_edge_in_bound_face = unique(id_edge_in_bound_face);
            %--------------------------------------------------------------
            id_edge_in_elem = f_edgeinelem(elem,edge_list);
            id_edge_in_elem = unique(id_edge_in_elem);
            %--------------------------------------------------------------
            id_inner_edge = setdiff(id_edge_in_elem,id_edge_in_bound_face);
            id_bound_edge = id_edge_in_bound_face;
            %--------------------------------------------------------------
            % --- Output
            c3dobj.emdesign.(id_emdesign).airbox.(id_airbox).id_elem = id_elem;
            c3dobj.emdesign.(id_emdesign).airbox.(id_airbox).id_node = id_node;
            c3dobj.emdesign.(id_emdesign).airbox.(id_airbox).id_inner_edge = id_inner_edge;
            c3dobj.emdesign.(id_emdesign).airbox.(id_airbox).id_bound_edge = id_bound_edge;
            %c3dobj.emdesign.(id_emdesign).airbox.(id_airbox).id_face = id_face;
            %c3dobj.emdesign.(id_emdesign).airbox.(id_airbox).id_edge = id_edge;
            %--------------------------------------------------------------
            c3dobj.emdesign.(id_emdesign).airbox.(id_airbox).to_be_rebuilt = 0;
            %--------------------------------------------------------------
        case {'3d_fem_tomejw','3d_fem_tomets'}
            % TODO
    end
    % --- Log message
    f_fprintf(0,'--- in',...
              1,toc, ...
              0,'s \n');
end
%----------------------------------------------------------------------