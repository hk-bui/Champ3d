function c3dobj = f_build_pmagnet(c3dobj,varargin)
% F_BUILD_PMAGNET returns the em matrix system related to permanent magnet.
%--------------------------------------------------------------------------
% c3dobj = f_build_pmagnet(c3dobj,option);
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
arglist = {'id_emdesign3d','id_pmagnet'};

% --- default input value
id_emdesign3d = [];
id_pmagnet = '_all';

% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if isempty(id_emdesign3d)
    error([mfilename ': #id_emdesign3d must be given']); 
end
%--------------------------------------------------------------------------
if iscell(id_emdesign3d)
    id_emdesign3d = id_emdesign3d{1};
end
%--------------------------------------------------------------------------
id_pmagnet = f_to_scellargin(id_pmagnet);
%--------------------------------------------------------------------------
if any(strcmpi(id_pmagnet,{'_all'}))
    if isfield(c3dobj.emdesign3d.(id_emdesign3d),'pmagnet')
        id_pmagnet = fieldnames(c3dobj.emdesign3d.(id_emdesign3d).pmagnet);
    else
        return
    end
end
%--------------------------------------------------------------------------
for iec = 1:length(id_pmagnet)
    id_phydom = id_pmagnet{iec};
    to_be_rebuilt = c3dobj.emdesign3d.(id_emdesign3d).pmagnet.(id_phydom).to_be_rebuilt;
    if to_be_rebuilt
        %----------------------------------------------------------------------
        em_model = c3dobj.emdesign3d.(id_emdesign3d).em_model;
        %----------------------------------------------------------------------
        f_fprintf(0,'Build #pmagnet',1,id_phydom, ...
                  0,'in #emdesign3d',1,id_emdesign3d, ...
                  0,'for',1,em_model,0,'\n');
        switch em_model
            case {'fem_aphijw','fem_aphits'}
                tic;
                %----------------------------------------------------------
                phydomobj = c3dobj.emdesign3d.(id_emdesign3d).pmagnet.(id_phydom);
                %----------------------------------------------------------
                dir_array = f_callcoefficient(c3dobj,'phydomobj',phydomobj,...
                                                     'coefficient','br_dir');
                dir_array = f_normalize(dir_array);
                %----------------------------------------------------------
                Br_value = f_callcoefficient(c3dobj,'phydomobj',phydomobj,...
                                                    'coefficient','br_value');
                %----------------------------------------------------------
                Bs = dir_array .* Br_value;
                %----------------------------------------------------------
                sigwewe = f_cwewe(c3dobj,'phydomobj',phydomobj,...
                                         'coefficient',coef_array);
                %----------------------------------------------------------
                % --- Output
                c3dobj.emdesign3d.(id_emdesign3d).pmagnet.(id_phydom).sigwewe = sigwewe;
                %----------------------------------------------------------
                coeftype = f_coeftype(phydomobj.(coef_name));
                switch coeftype
                    case {'function_ltensor_array','function_iso_array'}
                        c3dobj.emdesign3d.(id_emdesign3d).pmagnet.(id_phydom).to_be_rebuilt = 1;
                    otherwise
                        c3dobj.emdesign3d.(id_emdesign3d).pmagnet.(id_phydom).to_be_rebuilt = 0;
                end
                %----------------------------------------------------------
            case {'fem_tomejw','fem_tomets'}
                % TODO
        end
        % --- Log message
        f_fprintf(0,'--- in',...
                  1,toc, ...
                  0,'s \n');
    end
end



for i = 1:nb_dom
        %SFace  = f_measure(dom3d.mesh.node,dom3d.mesh.face(:,dom3d.pmagnet(i).id_face),'face');
        %nFace  = f_chavec(dom3d.mesh.node,dom3d.mesh.face(:,dom3d.pmagnet(i).id_face),'face');
        %Br     = dom3d.pmagnet(i).br_value;
        %Flux   = SFace .* f_dot(nFace);

        IDElem = design3d.pmagnet(i).id_elem;
        nbElem = length(IDElem);
        %----------------------------------------------------------------------
        xCen = design3d.mesh.cnode(1,IDElem); 
        yCen = design3d.mesh.cnode(2,IDElem); 
        zCen = design3d.mesh.cnode(3,IDElem);
        br_ori = zeros(3,nbElem);
        for j = 1:nbElem
            br_ori(:,j) = design3d.pmagnet(i).br_ori(xCen(j),yCen(j),zCen(j));
        end
        br_ori = f_normalize(br_ori);
        Br(:,IDElem) = design3d.pmagnet(i).br_value .* br_ori;
    end