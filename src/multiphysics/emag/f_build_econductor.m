function c3dobj = f_build_econductor(c3dobj,varargin)
% F_BUILD_ECONDUCTOR returns the em matrix system related to econductor. 
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
arglist = {'id_emdesign','id_econductor'};

% --- default input value
id_emdesign = [];
id_econductor = '_all';

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
id_econductor = f_to_scellargin(id_econductor);
%--------------------------------------------------------------------------
if any(strcmpi(id_econductor,{'_all'}))
    if isfield(c3dobj.emdesign.(id_emdesign),'econductor')
        id_econductor = fieldnames(c3dobj.emdesign.(id_emdesign).econductor);
    else
        return
    end
end
%--------------------------------------------------------------------------
for iec = 1:length(id_econductor)
    id_phydom = id_econductor{iec};
    to_be_rebuilt = c3dobj.emdesign.(id_emdesign).econductor.(id_phydom).to_be_rebuilt;
    if to_be_rebuilt
        %------------------------------------------------------------------
        em_model = c3dobj.emdesign.(id_emdesign).em_model;
        %------------------------------------------------------------------
        f_fprintf(0,'Build #econ',1,id_phydom, ...
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
        phydomobj = c3dobj.emdesign.(id_emdesign).econductor.(id_phydom);
        %------------------------------------------------------------------
        phydomobj = f_get_id(c3dobj,phydomobj);
        id_elem   = phydomobj.id_elem;
        %----------------------------------------------------------------------
        switch em_model
            case {'3d_fem_aphijw','3d_fem_aphits'}
                %--------------------------------------------------------------
                elem = c3dobj.mesh3d.(id_mesh).elem(:,id_elem);
                %--------------------------------------------------------------
                id_node_phi = f_uniquenode(elem);
                %----------------------------------------------------------
                coef_name  = 'sigma';
                coef_array = f_callcoefficient(c3dobj,'phydomobj',phydomobj,...
                                                      'coefficient',coef_name);
                %----------------------------------------------------------
                sigmawewe = f_cwewe(c3dobj,'phydomobj',phydomobj,...
                                         'coefficient',coef_array);
                %----------------------------------------------------------
                % --- Output
                c3dobj.emdesign.(id_emdesign).econductor.(id_phydom).id_elem = id_elem;
                c3dobj.emdesign.(id_emdesign).econductor.(id_phydom).sigma_array = coef_array;
                c3dobj.emdesign.(id_emdesign).econductor.(id_phydom).sigmawewe = sigmawewe;
                c3dobj.emdesign.(id_emdesign).econductor.(id_phydom).id_node_phi = id_node_phi;
                %----------------------------------------------------------
                coeftype = f_coeftype(phydomobj.(coef_name));
                switch coeftype
                    case {'function_ltensor_array','function_iso_array'}
                        c3dobj.emdesign.(id_emdesign).econductor.(id_phydom).to_be_rebuilt = 1;
                    otherwise
                        c3dobj.emdesign.(id_emdesign).econductor.(id_phydom).to_be_rebuilt = 0;
                end
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

