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
arglist = {'id_emdesign3d','id_econductor'};

% --- default input value
id_emdesign3d = [];
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
if isempty(id_emdesign3d)
    error([mfilename ': #id_emdesign3d must be given']); 
end
%--------------------------------------------------------------------------
if iscell(id_emdesign3d)
    id_emdesign3d = id_emdesign3d{1};
end
%--------------------------------------------------------------------------
id_econductor = f_to_scellargin(id_econductor);
%--------------------------------------------------------------------------
if any(strcmpi(id_econductor,{'_all'}))
    if isfield(c3dobj.emdesign3d.(id_emdesign3d),'econductor')
        id_econductor = fieldnames(c3dobj.emdesign3d.(id_emdesign3d).econductor);
    else
        return
    end
end
%--------------------------------------------------------------------------
for iec = 1:length(id_econductor)
    id_phydom = id_econductor{iec};
    to_be_rebuilt = c3dobj.emdesign3d.(id_emdesign3d).econductor.(id_phydom).to_be_rebuilt;
    if to_be_rebuilt
        %------------------------------------------------------------------
        em_model = c3dobj.emdesign3d.(id_emdesign3d).em_model;
        %------------------------------------------------------------------
        f_fprintf(0,'Build #econ',1,id_phydom, ...
                  0,'in #emdesign3d',1,id_emdesign3d, ...
                  0,'for',1,em_model,0,'\n');
        %------------------------------------------------------------------
        tic;
        %------------------------------------------------------------------
        id_mesh3d = c3dobj.emdesign3d.(id_emdesign3d).id_mesh3d;
        %------------------------------------------------------------------
        phydomobj = c3dobj.emdesign3d.(id_emdesign3d).econductor.(id_phydom);
        %------------------------------------------------------------------
        id_dom3d = phydomobj.id_dom3d;
        id_dom3d = f_to_scellargin(id_dom3d);
        % ---
        id_elem = [];
        id_face = [];
        id_edge = [];
        for i = 1:length(id_dom3d)
            defined_on = c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d{i}).defined_on;
            if f_strcmpi(defined_on,'elem')
                id_elem = [id_elem ...
                    c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d{i}).id_elem];
            elseif f_strcmpi(defined_on,'face')
                id_face = [id_face ...
                    c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d{i}).id_face];
            elseif f_strcmpi(defined_on,'edge')
                id_edge = [id_edge ...
                    c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d{i}).id_edge];
            end
        end
        %------------------------------------------------------------------
        % --- Output
        c3dobj.emdesign3d.(id_emdesign3d).econductor.(id_phydom).id_elem = id_elem;
        c3dobj.emdesign3d.(id_emdesign3d).econductor.(id_phydom).id_face = id_face;
        c3dobj.emdesign3d.(id_emdesign3d).econductor.(id_phydom).id_edge = id_edge;
        %------------------------------------------------------------------
        elem = c3dobj.mesh3d.(id_mesh3d).elem(:,id_elem);
        %------------------------------------------------------------------
        switch em_model
            case {'fem_aphijw','fem_aphits'}
                %----------------------------------------------------------
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
                c3dobj.emdesign3d.(id_emdesign3d).econductor.(id_phydom).sigmawewe = sigmawewe;
                c3dobj.emdesign3d.(id_emdesign3d).econductor.(id_phydom).id_node_phi = id_node_phi;
                %----------------------------------------------------------
                coeftype = f_coeftype(phydomobj.(coef_name));
                switch coeftype
                    case {'function_ltensor_array','function_iso_array'}
                        c3dobj.emdesign3d.(id_emdesign3d).econductor.(id_phydom).to_be_rebuilt = 1;
                    otherwise
                        c3dobj.emdesign3d.(id_emdesign3d).econductor.(id_phydom).to_be_rebuilt = 0;
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

