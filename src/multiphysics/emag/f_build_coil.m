function c3dobj = f_build_coil(c3dobj,varargin)
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
arglist = {'id_emdesign','id_coil'};

% --- default input value
id_emdesign = [];
id_coil = '_all';

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
id_coil = f_to_scellargin(id_coil);
%--------------------------------------------------------------------------
if any(strcmpi(id_coil,{'_all'}))
    if isfield(c3dobj.emdesign.(id_emdesign),'coil')
        id_coil = fieldnames(c3dobj.emdesign.(id_emdesign).coil);
    else
        return
    end
end
%--------------------------------------------------------------------------
for iec = 1:length(id_coil)
    id_phydom = id_coil{iec};
    %----------------------------------------------------------------------
    em_model = c3dobj.emdesign.(id_emdesign).em_model;
    %----------------------------------------------------------------------
    f_fprintf(0,'Build #coil',1,id_phydom, ...
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
    phydomobj = c3dobj.emdesign.(id_emdesign).coil.(id_phydom);
    coil_type = phydomobj.coil_type;
    defined_with = phydomobj.defined_with;
    %----------------------------------------------------------------------
    phydomobj = f_get_id(c3dobj,phydomobj);
    defined_on = phydomobj.defined_on;
    id_elem   = phydomobj.id_elem;
    id_face   = phydomobj.id_face;
    %----------------------------------------------------------------------
    switch em_model
        %------------------------------------------------------------------
        case {'3d_fem_aphijw','3d_fem_aphits'}
            switch coil_type
                %----------------------------------------------------------
                case {'close_jscoil'}
                    switch defined_with
                        %--------------------------------------------------
                        case {'field_vector'}
                            %----------------------------------------------
                            field_vector_o = phydomobj.field_vector_o;
                            field_vector_v = phydomobj.field_vector_v;
                            j_coil         = phydomobj.j_coil;
                            nb_turn        = phydomobj.nb_turn;
                            cs_area        = phydomobj.cs_area;
                            %----------------------------------------------
                            celem = c3dobj.mesh3d.(id_mesh).celem;
                            %----------------------------------------------
                            xCen = celem(1,id_elem); 
                            yCen = celem(2,id_elem); 
                            zCen = celem(3,id_elem);
                            %--------
                            fvlen = 100; % try to create a "big" vector
                            xi = field_vector_o(1) - field_vector_v(1)*fvlen;
                            yi = field_vector_o(2) - field_vector_v(2)*fvlen;
                            zi = field_vector_o(3) - field_vector_v(3)*fvlen;
                            xf = xi + 2*fvlen * field_vector_v(1);
                            yf = yi + 2*fvlen * field_vector_v(2);
                            zf = zi + 2*fvlen * field_vector_v(3);
                            %--------
                            lambda = ((xf-xi)*(xCen-xi) + (yf-yi)*(yCen-yi) + (zf-zi)*(zCen-zi))...
                                         ./((xf-xi)^2 + (yf-yi)^2 + (zf-zi)^2);
                            %--------
                            xp = xi + lambda*(xf-xi);   % Projected point
                            yp = yi + lambda*(yf-yi);
                            zp = zi + lambda*(zf-zi);
                            %--------
                            vJs = zeros(3,length(id_elem)); % Field direction
                            vJs(1,:) = (yf-yi)*(zCen-zp) - (yCen-yp)*(zf-zi); 
                            vJs(2,:) = (zf-zi)*(xCen-xp) - (zCen-zp)*(xf-xi);
                            vJs(3,:) = (xf-xi)*(yCen-yp) - (xCen-xp)*(yf-yi);
                            vJs = f_normalize(vJs);
                            %-----------------------Source field-----------
                            % current turn density vector field
                            N  = vJs .* nb_turn ./ cs_area;
                            % current density vector field
                            js_array = vJs .* j_coil;
                            js_array = js_array.';
                            %----------------------------------------------
                            wfjs = f_cwfvf(c3dobj,'phydomobj',phydomobj,'vector_field',js_array);
                            %----------------------------------------------
                            % --- Output
                            c3dobj.emdesign.(id_emdesign).coil.(id_phydom).js_array = js_array;
                            c3dobj.emdesign.(id_emdesign).coil.(id_phydom).wfjs = wfjs;
                            c3dobj.emdesign.(id_emdesign).coil.(id_phydom).N = N;
                        %--------------------------------------------------
                        case {'etrode'}
                            %----------------------------------------------
                            elem = c3dobj.mesh3d.(id_mesh).elem;
                            %----------------------------------------------
                            j_coil         = phydomobj.j_coil;
                            nb_turn        = phydomobj.nb_turn;
                            cs_area        = phydomobj.cs_area;
                            %----------------------------------------------
                            gid_node_petrode = phydomobj.petrode.id_node;
                            gid_node_netrode = phydomobj.netrode.id_node;
                            %----------------------------------------------
                            vJs = zeros(3,length(id_elem)); % Field direction
                            %----------------------------------------------
                            for ipart = 1:2
                                if ipart == 1
                                    id_elem_x = unique([phydomobj.petrode.id_elem ...
                                                        phydomobj.netrode.id_elem]);
                                else
                                    id_elem_x = setdiff(id_elem,id_elem_x);
                                end
                                gid_node_x = sort(f_uniquenode(elem(:,id_elem_x)));
                                lid_node_x = 1:length(gid_node_x);
                                %------------------------------------------
                                node_x = c3dobj.mesh3d.(id_mesh).node(:,gid_node_x);
                                nb_node_x = size(node_x,2);
                                %------------------------------------------
                                elem_type = c3dobj.mesh3d.(id_mesh).elem_type;
                                con = f_connexion(elem_type);
                                nbNo_inEl = con.nbNo_inEl;
                                %------------------------------------------
                                nb_elem_x = length(id_elem_x);
                                elem_x = c3dobj.mesh3d.(id_mesh).elem(:,id_elem_x);
                                elem_x = reshape(elem_x,1,[]);
                                elem_x = interp1(gid_node_x,lid_node_x,elem_x);
                                elem_x = reshape(elem_x,nbNo_inEl,[]);
                                %------------------------------------------
                                mesh_x = [];
                                mesh_x.node = node_x;
                                mesh_x.elem = elem_x;
                                mesh_x.elem_type = elem_type;
                                %------------------------------------------
                                mesh_x = f_meshds(mesh_x);
                                mesh_x = f_intkit(mesh_x);
                                %------------------------------------------
                                lid_node_petrode = interp1(gid_node_x,lid_node_x,gid_node_petrode);
                                lid_node_netrode = interp1(gid_node_x,lid_node_x,gid_node_netrode);
                                %------------------------------------------
                                nbG = con.nbG;
                                Weigh = con.Weigh;
                                nbEd_inEl = con.nbEd_inEl;
                                %------------------------------------------
                                We = cell(1,nbG);
                                detJ = cell(1,nbG);
                                for iG = 1:nbG
                                    We{iG} = mesh_x.intkit.We{iG};
                                    detJ{iG} = mesh_x.intkit.detJ{iG};
                                end
                                %------------------------------------------
                                coefwewe = zeros(nb_elem_x,nbEd_inEl,nbEd_inEl);
                                for iG = 1:nbG
                                    dJ    = f_tocolv(detJ{iG});
                                    weigh = Weigh(iG);
                                    for i = 1:nbEd_inEl
                                        weix = We{iG}(:,1,i);
                                        weiy = We{iG}(:,2,i);
                                        weiz = We{iG}(:,3,i);
                                        for j = i:nbEd_inEl % !!! i
                                            wejx = We{iG}(:,1,j);
                                            wejy = We{iG}(:,2,j);
                                            wejz = We{iG}(:,3,j);
                                            % ---
                                            coefwewe(:,i,j) = coefwewe(:,i,j) + ...
                                                weigh .* dJ .* ...
                                                (weix .* wejx + weiy .* wejy + weiz .* wejz);
                                        end
                                    end
                                end
                                %------------------------------------------
                                nb_edge = size(mesh_x.edge,2);
                                id_edge_in_elem = mesh_x.id_edge_in_elem;
                                wewe = sparse(nb_edge,nb_edge);
                                for i = 1:nbEd_inEl
                                    for j = i+1 : nbEd_inEl
                                        wewe = wewe + ...
                                            sparse(id_edge_in_elem(i,:),id_edge_in_elem(j,:),...
                                                   coefwewe(:,i,j),nb_edge,nb_edge);
                                    end
                                end
                                wewe = wewe + wewe.';
                                for i = 1:nbEd_inEl
                                    wewe = wewe + ...
                                        sparse(id_edge_in_elem(i,:),id_edge_in_elem(i,:),...
                                               coefwewe(:,i,i),nb_edge,nb_edge);
                                end
                                %------------------------------------------
                                V = zeros(nb_node_x,1);
                                if ipart == 1
                                    V(lid_node_petrode) = 1;
                                else
                                    V(lid_node_netrode) = 1;
                                end
                                %------------------------------------------
                                id_node_v_unknown = setdiff(lid_node_x,...
                                                            [lid_node_petrode lid_node_netrode]);
                                %------------------------------------------
                                gradgrad = mesh_x.grad.' * wewe * mesh_x.grad;
                                RHS = - gradgrad * V;
                                gradgrad = gradgrad(id_node_v_unknown,id_node_v_unknown);
                                RHS = RHS(id_node_v_unknown,1);
                                V(id_node_v_unknown) = gradgrad \ RHS;
                                %------------------------------------------
                                face_x = f_boundface(elem_x,node_x,'elem_type',elem_type);
                                %------------------------------------------
                                id_face = 1:size(face_x,2);
                                % 1/ triangle
                                itria = face_x(end, id_face) == 0;
                                % 2/ quad
                                iquad = face_x(end, id_face) ~= 0;
                                % ---
                                figure
                                msh = [];
                                msh.Faces = face_x(1:3,itria).';
                                msh.Vertices = node_x.';
                                msh.FaceVertexCData = f_tocolv(V);
                                msh.FaceColor = 'interp';
                                patch(msh); hold on
                                msh = [];
                                msh.Faces = face_x(1:4,iquad).';
                                msh.Vertices = node_x.';
                                msh.FaceVertexCData = f_tocolv(V);
                                msh.FaceColor = 'interp';
                                patch(msh);
                                %------------------------------------------
                                vJsx = f_field_we(mesh_x.grad * V,mesh_x);
                                vJsx = f_normalize(vJsx);
                                %------------------------------------------
                                [~,idjs]=ismember(id_elem_x,id_elem);
                                vJs(:,idjs) = vJsx;
                            end
                            %----------------------------------------------
                            %-----------------------Source field-----------
                            % current turn density vector field
                            N  = vJs .* nb_turn ./ cs_area;
                            % current density vector field
                            js_array = vJs .* j_coil;
                            js_array = js_array.';
                            %----------------------------------------------
                            wfjs = f_cwfvf(c3dobj,'phydomobj',phydomobj,'vector_field',js_array);
                            %----------------------------------------------
                            % --- Output
                            c3dobj.emdesign.(id_emdesign).coil.(id_phydom).js_array = js_array;
                            c3dobj.emdesign.(id_emdesign).coil.(id_phydom).wfjs = wfjs;
                            c3dobj.emdesign.(id_emdesign).coil.(id_phydom).N = N;
                            %----------------------------------------------
                            figure
                            f_quiver(c3dobj.mesh3d.(id_mesh).celem(:,id_elem),vJs);
                    end
                %----------------------------------------------------------
                case {'open_jscoil'}
                            %----------------------------------------------
                            elem = c3dobj.mesh3d.(id_mesh).elem;
                            %----------------------------------------------
                            j_coil         = phydomobj.j_coil;
                            nb_turn        = phydomobj.nb_turn;
                            cs_area        = phydomobj.cs_area;
                            %----------------------------------------------
                            gid_node_petrode = phydomobj.petrode.id_node;
                            gid_node_netrode = phydomobj.netrode.id_node;
                            %----------------------------------------------
                            vJs = zeros(3,length(id_elem)); % Field direction
                            %----------------------------------------------
                            id_elem_x = id_elem;
                            gid_node_x = sort(f_uniquenode(elem(:,id_elem_x)));
                            lid_node_x = 1:length(gid_node_x);
                            %------------------------------------------
                            node_x = c3dobj.mesh3d.(id_mesh).node(:,gid_node_x);
                            nb_node_x = size(node_x,2);
                            %------------------------------------------
                            elem_type = c3dobj.mesh3d.(id_mesh).elem_type;
                            con = f_connexion(elem_type);
                            nbNo_inEl = con.nbNo_inEl;
                            %------------------------------------------
                            nb_elem_x = length(id_elem_x);
                            elem_x = c3dobj.mesh3d.(id_mesh).elem(:,id_elem_x);
                            elem_x = reshape(elem_x,1,[]);
                            elem_x = interp1(gid_node_x,lid_node_x,elem_x);
                            elem_x = reshape(elem_x,nbNo_inEl,[]);
                            %------------------------------------------
                            mesh_x = [];
                            mesh_x.node = node_x;
                            mesh_x.elem = elem_x;
                            mesh_x.elem_type = elem_type;
                            %------------------------------------------
                            mesh_x = f_meshds(mesh_x);
                            mesh_x = f_intkit(mesh_x);
                            %------------------------------------------
                            lid_node_petrode = interp1(gid_node_x,lid_node_x,gid_node_petrode);
                            lid_node_netrode = interp1(gid_node_x,lid_node_x,gid_node_netrode);
                            %------------------------------------------
                            nbG = con.nbG;
                            Weigh = con.Weigh;
                            nbEd_inEl = con.nbEd_inEl;
                            %------------------------------------------
                            We = cell(1,nbG);
                            detJ = cell(1,nbG);
                            for iG = 1:nbG
                                We{iG} = mesh_x.intkit.We{iG};
                                detJ{iG} = mesh_x.intkit.detJ{iG};
                            end
                            %------------------------------------------
                            coefwewe = zeros(nb_elem_x,nbEd_inEl,nbEd_inEl);
                            for iG = 1:nbG
                                dJ    = f_tocolv(detJ{iG});
                                weigh = Weigh(iG);
                                for i = 1:nbEd_inEl
                                    weix = We{iG}(:,1,i);
                                    weiy = We{iG}(:,2,i);
                                    weiz = We{iG}(:,3,i);
                                    for j = i:nbEd_inEl % !!! i
                                        wejx = We{iG}(:,1,j);
                                        wejy = We{iG}(:,2,j);
                                        wejz = We{iG}(:,3,j);
                                        % ---
                                        coefwewe(:,i,j) = coefwewe(:,i,j) + ...
                                            weigh .* dJ .* ...
                                            (weix .* wejx + weiy .* wejy + weiz .* wejz);
                                    end
                                end
                            end
                            %------------------------------------------
                            nb_edge = size(mesh_x.edge,2);
                            id_edge_in_elem = mesh_x.id_edge_in_elem;
                            wewe = sparse(nb_edge,nb_edge);
                            for i = 1:nbEd_inEl
                                for j = i+1 : nbEd_inEl
                                    wewe = wewe + ...
                                        sparse(id_edge_in_elem(i,:),id_edge_in_elem(j,:),...
                                               coefwewe(:,i,j),nb_edge,nb_edge);
                                end
                            end
                            wewe = wewe + wewe.';
                            for i = 1:nbEd_inEl
                                wewe = wewe + ...
                                    sparse(id_edge_in_elem(i,:),id_edge_in_elem(i,:),...
                                           coefwewe(:,i,i),nb_edge,nb_edge);
                            end
                            %------------------------------------------
                            V = zeros(nb_node_x,1);
                            V(lid_node_petrode) = 1;
                            %------------------------------------------
                            id_node_v_unknown = setdiff(lid_node_x,...
                                                        [lid_node_petrode lid_node_netrode]);
                            %------------------------------------------
                            gradgrad = mesh_x.grad.' * wewe * mesh_x.grad;
                            RHS = - gradgrad * V;
                            gradgrad = gradgrad(id_node_v_unknown,id_node_v_unknown);
                            RHS = RHS(id_node_v_unknown,1);
                            V(id_node_v_unknown) = gradgrad \ RHS;
                            %------------------------------------------
                            face_x = f_boundface(elem_x,node_x,'elem_type',elem_type);
                            %------------------------------------------
                            id_face = 1:size(face_x,2);
                            % 1/ triangle
                            itria = face_x(end, id_face) == 0;
                            % 2/ quad
                            iquad = face_x(end, id_face) ~= 0;
                            % ---
                            figure
                            msh = [];
                            msh.Faces = face_x(1:3,itria).';
                            msh.Vertices = node_x.';
                            msh.FaceVertexCData = f_tocolv(V);
                            msh.FaceColor = 'interp';
                            patch(msh); hold on
                            msh = [];
                            msh.Faces = face_x(1:4,iquad).';
                            msh.Vertices = node_x.';
                            msh.FaceVertexCData = f_tocolv(V);
                            msh.FaceColor = 'interp';
                            patch(msh);
                            %------------------------------------------
                            vJs = f_field_we(mesh_x.grad * V,mesh_x);
                            vJs = f_normalize(vJs);
                            %----------------------------------------------
                            %-----------------------Source field-----------
                            % current turn density vector field
                            N  = vJs .* nb_turn ./ cs_area;
                            % current density vector field
                            js_array = vJs .* j_coil;
                            js_array = js_array.';
                            %----------------------------------------------
                            wfjs = f_cwfvf(c3dobj,'phydomobj',phydomobj,'vector_field',js_array);
                            %----------------------------------------------
                            % --- Output
                            c3dobj.emdesign.(id_emdesign).coil.(id_phydom).js_array = js_array;
                            c3dobj.emdesign.(id_emdesign).coil.(id_phydom).wfjs = wfjs;
                            c3dobj.emdesign.(id_emdesign).coil.(id_phydom).N = N;
                            %----------------------------------------------
                            figure
                            f_quiver(c3dobj.mesh3d.(id_mesh).celem(:,id_elem),vJs);
                %----------------------------------------------------------
                case {'open_iscoil','open_vscoil'}
                    %----------------------------------------------
                            elem = c3dobj.mesh3d.(id_mesh).elem;
                            nb_node = size(c3dobj.mesh3d.(id_mesh).node,2);
                            %----------------------------------------------
                            if f_strcmpi(coil_type,'open_iscoil')
                                i_coil         = phydomobj.i_coil;
                            elseif f_strcmpi(coil_type,'open_vscoil')
                                v_coil         = phydomobj.v_coil;
                            end
                            %----------------------------------------------
                            nb_turn        = phydomobj.nb_turn;
                            cs_area        = phydomobj.cs_area;
                            %----------------------------------------------
                            gid_node_petrode = phydomobj.petrode.id_node;
                            gid_node_netrode = phydomobj.netrode.id_node;
                            %----------------------------------------------
                            vJs = zeros(3,length(id_elem)); % Field direction
                            %----------------------------------------------
                            id_elem_x = id_elem;
                            gid_node_x = sort(f_uniquenode(elem(:,id_elem_x)));
                            lid_node_x = 1:length(gid_node_x);
                            %------------------------------------------
                            node_x = c3dobj.mesh3d.(id_mesh).node(:,gid_node_x);
                            nb_node_x = size(node_x,2);
                            %------------------------------------------
                            elem_type = c3dobj.mesh3d.(id_mesh).elem_type;
                            con = f_connexion(elem_type);
                            nbNo_inEl = con.nbNo_inEl;
                            %------------------------------------------
                            nb_elem_x = length(id_elem_x);
                            elem_x = c3dobj.mesh3d.(id_mesh).elem(:,id_elem_x);
                            elem_x = reshape(elem_x,1,[]);
                            elem_x = interp1(gid_node_x,lid_node_x,elem_x);
                            elem_x = reshape(elem_x,nbNo_inEl,[]);
                            %------------------------------------------
                            mesh_x = [];
                            mesh_x.node = node_x;
                            mesh_x.elem = elem_x;
                            mesh_x.elem_type = elem_type;
                            %------------------------------------------
                            mesh_x = f_meshds(mesh_x);
                            mesh_x = f_intkit(mesh_x);
                            %------------------------------------------
                            lid_node_petrode = interp1(gid_node_x,lid_node_x,gid_node_petrode);
                            lid_node_netrode = interp1(gid_node_x,lid_node_x,gid_node_netrode);
                            %------------------------------------------
                            nbG = con.nbG;
                            Weigh = con.Weigh;
                            nbEd_inEl = con.nbEd_inEl;
                            %------------------------------------------
                            We = cell(1,nbG);
                            detJ = cell(1,nbG);
                            for iG = 1:nbG
                                We{iG} = mesh_x.intkit.We{iG};
                                detJ{iG} = mesh_x.intkit.detJ{iG};
                            end
                            %------------------------------------------
                            coefwewe = zeros(nb_elem_x,nbEd_inEl,nbEd_inEl);
                            for iG = 1:nbG
                                dJ    = f_tocolv(detJ{iG});
                                weigh = Weigh(iG);
                                for i = 1:nbEd_inEl
                                    weix = We{iG}(:,1,i);
                                    weiy = We{iG}(:,2,i);
                                    weiz = We{iG}(:,3,i);
                                    for j = i:nbEd_inEl % !!! i
                                        wejx = We{iG}(:,1,j);
                                        wejy = We{iG}(:,2,j);
                                        wejz = We{iG}(:,3,j);
                                        % ---
                                        coefwewe(:,i,j) = coefwewe(:,i,j) + ...
                                            weigh .* dJ .* ...
                                            (weix .* wejx + weiy .* wejy + weiz .* wejz);
                                    end
                                end
                            end
                            %------------------------------------------
                            nb_edge = size(mesh_x.edge,2);
                            id_edge_in_elem = mesh_x.id_edge_in_elem;
                            wewe = sparse(nb_edge,nb_edge);
                            for i = 1:nbEd_inEl
                                for j = i+1 : nbEd_inEl
                                    wewe = wewe + ...
                                        sparse(id_edge_in_elem(i,:),id_edge_in_elem(j,:),...
                                               coefwewe(:,i,j),nb_edge,nb_edge);
                                end
                            end
                            wewe = wewe + wewe.';
                            for i = 1:nbEd_inEl
                                wewe = wewe + ...
                                    sparse(id_edge_in_elem(i,:),id_edge_in_elem(i,:),...
                                           coefwewe(:,i,i),nb_edge,nb_edge);
                            end
                            %------------------------------------------
                            V = zeros(nb_node_x,1);
                            V(lid_node_petrode) = 1;
                            %------------------------------------------
                            id_node_v_unknown = setdiff(lid_node_x,...
                                                        [lid_node_petrode lid_node_netrode]);
                            %------------------------------------------
                            gradgrad = mesh_x.grad.' * wewe * mesh_x.grad;
                            RHS = - gradgrad * V;
                            gradgrad = gradgrad(id_node_v_unknown,id_node_v_unknown);
                            RHS = RHS(id_node_v_unknown,1);
                            V(id_node_v_unknown) = gradgrad \ RHS;
                            %------------------------------------------
                            alpha = zeros(nb_node,1);
                            alpha(gid_node_x) = V;
                            %------------------------------------------
                            face_x = f_boundface(elem_x,node_x,'elem_type',elem_type);
                            %------------------------------------------
                            id_face = 1:size(face_x,2);
                            % 1/ triangle
                            itria = face_x(end, id_face) == 0;
                            % 2/ quad
                            iquad = face_x(end, id_face) ~= 0;
                            % ---
                            figure
                            msh = [];
                            msh.Faces = face_x(1:3,itria).';
                            msh.Vertices = node_x.';
                            msh.FaceVertexCData = f_tocolv(V);
                            msh.FaceColor = 'interp';
                            patch(msh); hold on
                            msh = [];
                            msh.Faces = face_x(1:4,iquad).';
                            msh.Vertices = node_x.';
                            msh.FaceVertexCData = f_tocolv(V);
                            msh.FaceColor = 'interp';
                            patch(msh);
                            %------------------------------------------
                            vJs = f_field_we(mesh_x.grad * V,mesh_x);
                            vJs = f_normalize(vJs);
                            %----------------------------------------------
                            %-----------------------Source field-----------
                            % current turn density vector field
                            N  = vJs .* nb_turn ./ cs_area;
                            %----------------------------------------------
                            % --- Output
                            c3dobj.emdesign.(id_emdesign).coil.(id_phydom).N = N;
                            c3dobj.emdesign.(id_emdesign).coil.(id_phydom).alpha = alpha;
                            %----------------------------------------------
                            figure
                            f_quiver(c3dobj.mesh3d.(id_mesh).celem(:,id_elem),vJs);
                
            end
        %------------------------------------------------------------------
        case {'3d_fem_tomejw','3d_fem_tomets'}
            % TODO
    end
    % --- Log message
    f_fprintf(0,'--- in',...
              1,toc, ...
              0,'s \n');
end