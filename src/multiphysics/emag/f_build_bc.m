function c3dobj = f_build_bc(c3dobj,varargin)
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
arglist = {'id_emdesign','id_bc'};

% --- default input value
id_emdesign = [];
id_bc = '_all';

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

% id_emdesign = 'em_multicubes';
% id_bc = 'sibc';

%--------------------------------------------------------------------------
id_bc = f_to_scellargin(id_bc);
%--------------------------------------------------------------------------
if any(strcmpi(id_bc,{'_all'}))
    if isfield(c3dobj.emdesign.(id_emdesign),'bc')
        id_bc = fieldnames(c3dobj.emdesign.(id_emdesign).bc);
    else
        return
    end
end
%--------------------------------------------------------------------------
for iec = 1:length(id_bc)
    id_phydom = id_bc{iec};
    to_be_rebuilt = c3dobj.emdesign.(id_emdesign).bc.(id_phydom).to_be_rebuilt;
    if to_be_rebuilt
        %------------------------------------------------------------------
        em_model = c3dobj.emdesign.(id_emdesign).em_model;
        dim = c3dobj.emdesign.(id_emdesign).dimension;
        %------------------------------------------------------------------
        f_fprintf(0,'Build #bc',1,id_phydom, ...
                  0,'in #emdesign',1,id_emdesign, ...
                  0,'for',1,em_model,0,'\n');
        %------------------------------------------------------------------
        tic;
        %------------------------------------------------------------------
        if dim == 3
            id_mesh = c3dobj.emdesign.(id_emdesign).id_mesh3d;
        elseif dim == 2
            id_mesh = c3dobj.emdesign.(id_emdesign).id_mesh2d;
        end
        %------------------------------------------------------------------
        phydomobj = c3dobj.emdesign.(id_emdesign).bc.(id_phydom);
        %------------------------------------------------------------------
        phydomobj  = f_get_id(c3dobj,phydomobj);
        defined_on = phydomobj.defined_on;
        id_elem    = phydomobj.id_elem;
        id_face    = phydomobj.id_face;
        bc_type    = phydomobj.bc_type;
        %------------------------------------------------------------------
        % --- Output
        c3dobj.emdesign.(id_emdesign).bc.(id_phydom).id_face = id_face;
        %------------------------------------------------------------------
        switch em_model
            case {'3d_fem_aphijw','3d_fem_aphits'}
                %----------------------------------------------------------
                edge_list = c3dobj.mesh3d.(id_mesh).edge;
                %----------------------------------------------------------
                if f_strcmpi(bc_type,{'sibc'})
                    if any(f_strcmpi(defined_on,'elem'))
                        [face, ~, info] = ...
                            f_boundface(c3dobj.mesh3d.(id_mesh).elem(:,id_elem),...
                                        c3dobj.mesh3d.(id_mesh).node,...
                                        'elem_type',c3dobj.mesh3d.(id_mesh).elem_type);
                        id_face = f_findvecnd(face, ...
                                  c3dobj.mesh3d.(id_mesh).face);
                        c3dobj.emdesign.(id_emdesign).bc.(id_phydom).defined_on = 'face';
                        c3dobj.emdesign.(id_emdesign).bc.(id_phydom).id_face = id_face;
                    elseif any(f_strcmpi(defined_on,'face'))
                        face = c3dobj.mesh3d.(id_mesh).face(:,id_face);
                    end
                    %------------------------------------------------------
                    id_edge = f_edgeinface(face,edge_list);
                    id_edge = unique(id_edge);
                    %------------------------------------------------------
                    id_node_phi = f_uniquenode(face);
                    %------------------------------------------------------
                    %coef_name = 'sigma';
                    %sigma_array = f_callcoefficient(c3dobj,'phydomobj',phydomobj,...
                    %                          'coefficient',coef_name);
                    sigma_array = phydomobj.sigma;
                    %------------------------------------------------------
                    %coef_name = 'mu_r';
                    %mu_r_array  = f_callcoefficient(c3dobj,'phydomobj',phydomobj,...
                    %                          'coefficient',coef_name);
                    mu_r_array = phydomobj.mu_r;
                    %------------------------------------------------------
                    mu0 = 4 * pi * 1e-7;
                    mu  = mu0 .*  mu_r_array;
                    fr  = c3dobj.emdesign.(id_emdesign).frequency;
                    skindepth = sqrt(2./(2*pi*fr.*mu.*sigma_array));
                    %------------------------------------------------------
                    cparam = 0;
                    if ~isempty(phydomobj.r_ht) && ~isempty(phydomobj.r_et)
                        cparam = 1/phydomobj.r_ht - 1/phydomobj.r_et;
                    elseif ~isempty(phydomobj.r_ht)
                        cparam = 1/phydomobj.r_ht;
                    elseif ~isempty(phydomobj.r_et)
                        cparam = - 1/phydomobj.r_et;
                    end
                    %------------------------------------------------------
                    z_sibc = (1+1j)./(skindepth.*sigma_array) .* ...
                             (1 + (1-1j)/4 .* skindepth .* cparam);
                    %------------------------------------------------------
                    [grface,lid_face,face_elem_type] = f_filterface(face);
                    %------------------------------------------------------
                    gsibcwewe = cell(1,length(grface));
                    %------------------------------------------------------
                    gid_face = cell(1,length(grface));
                    facemesh = cell(1,length(grface));
                    %------------------------------------------------------
                    for igr = 1:length(grface)
                        % ---
                        gid_face{igr} = id_face(lid_face{igr});
                        % ---
                        face = grface{igr};
                        [flat_node,flatface] = ...
                            f_flatface(c3dobj.mesh3d.(id_mesh).node,face);
                        % ---
                        meshbc = [];
                        meshbc.node = c3dobj.mesh3d.(id_mesh).node;
                        meshbc.elem = flatface;
                        nb_elem = size(meshbc.elem,2);
                        % ---
                        meshbc.elem_type = f_elemtype(meshbc.elem,'defined_on','face');
                        meshbc = f_meshds(meshbc,'elem_type',face_elem_type{igr});
                        meshbc = f_intkit(meshbc,'flat_node',flat_node);
                        %--------------------------------------------------
                        facemesh{igr} = meshbc;
                        %--------------------------------------------------
                        con = f_connexion(meshbc.elem_type);
                        nbG = con.nbG;
                        Weigh = con.Weigh;
                        nbEd_inEl = con.nbEd_inEl;
                        %--------------------------------------------------
                        We = cell(1,nbG);
                        detJ = cell(1,nbG);
                        for iG = 1:nbG
                            We{iG} = meshbc.intkit.We{iG};
                            detJ{iG} = meshbc.intkit.detJ{iG};
                        end
                        %--------------------------------------------------
                        gsibcwewe{igr} = zeros(nb_elem,nbEd_inEl,nbEd_inEl);
                        %--------------------------------------------------
                        for iG = 1:nbG
                            dJ    = f_tocolv(detJ{iG});
                            weigh = Weigh(iG);
                            for i = 1:nbEd_inEl
                                weix = We{iG}(:,1,i);
                                weiy = We{iG}(:,2,i);
                                for j = i:nbEd_inEl % !!! i
                                    wejx = We{iG}(:,1,j);
                                    wejy = We{iG}(:,2,j);
                                    % ---
                                    gsibcwewe{igr}(:,i,j) = ...
                                        gsibcwewe{igr}(:,i,j) + ...
                                        weigh .* dJ .* ( 1./z_sibc .* ...
                                        (weix .* wejx + weiy .* wejy) );
                                end
                            end
                        end
                        %--------------------------------------------------
                    end
                    %------------------------------------------------------
                    c3dobj.emdesign.(id_emdesign).bc.(id_phydom).id_elem = id_elem;
                    c3dobj.emdesign.(id_emdesign).bc.(id_phydom).id_face = id_face;
                    c3dobj.emdesign.(id_emdesign).bc.(id_phydom).facemesh = facemesh;
                    c3dobj.emdesign.(id_emdesign).bc.(id_phydom).gid_face = gid_face;
                    c3dobj.emdesign.(id_emdesign).bc.(id_phydom).lid_face = lid_face;
                    c3dobj.emdesign.(id_emdesign).bc.(id_phydom).skindepth = skindepth;
                    c3dobj.emdesign.(id_emdesign).bc.(id_phydom).sigma_array = sigma_array;
                    c3dobj.emdesign.(id_emdesign).bc.(id_phydom).mu_r_array = mu_r_array;
                    c3dobj.emdesign.(id_emdesign).bc.(id_phydom).z_sibc = z_sibc;
                    c3dobj.emdesign.(id_emdesign).bc.(id_phydom).gsibcwewe = gsibcwewe;
                    c3dobj.emdesign.(id_emdesign).bc.(id_phydom).id_node_phi = id_node_phi;
                end
                %----------------------------------------------------------
                if f_strcmpi(bc_type,{'fixed'})
                    
                end
                %----------------------------------------------------------
                if f_strcmpi(bc_type,{'bsfield'})
                    %------------------------------------------------------
                    coef_name = 'bs';
                    bs_array  = f_callcoefficient(c3dobj,'phydomobj',phydomobj,...
                                                         'coefficient',coef_name);
                    %------------------------------------------------------
                    node = c3dobj.mesh3d.(id_mesh).node;
                    face = c3dobj.mesh3d.(id_mesh).face(:,id_face);
                    %------------------------------------------------------
                    [face,lid_face] = f_filterface(face);
                    for i = 1:length(face)
                        gid_face{i} = id_face(lid_face{i});
                    end
                    %------------------------------------------------------
                    for i = 1:length(face)
                        idgFace = gid_face{i};
                        [flat_node,flat_face] = ...
                            f_flatface(c3dobj.mesh3d.(id_mesh).node,...
                                       c3dobj.mesh3d.(id_mesh).face(:,idgFace));
                        %--------------------------------------------------
                        meshbc.node = node;
                        meshbc.elem = flat_face;
                        %--------------------------------------------------
                        meshbc = f_intkit(meshbc,'flat_node',flat_node);
                    end
                    %------------------------------------------------------
                    %------------------------------------------------------
                    %------------------------------------------------------
                    %------------------------------------------------------
                    %------------------------------------------------------
                    %flux = f_0o_integral(node,face,'defined_on','face','vector_field',bs_array);
                    %------------------------------------------------------
                    node = c3dobj.mesh3d.(id_mesh).cface(:,id_face);
                    vf = bs_array;
                    figure
                    f_quiver(node,vf.');
                    %------------------------------------------------------
                    
                end
            case {'3d_fem_tomejw','3d_fem_tomets'}
                % TODO
        end
        % --- Log message
        f_fprintf(0,'--- in',...
                  1,toc, ...
                  0,'s \n');
    end
end