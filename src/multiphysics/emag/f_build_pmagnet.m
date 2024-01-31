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
arglist = {'id_emdesign','id_pmagnet'};

% --- default input value
id_emdesign = [];
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
if isempty(id_emdesign)
    error([mfilename ': #id_emdesign must be given']); 
end
%--------------------------------------------------------------------------
if iscell(id_emdesign)
    id_emdesign = id_emdesign{1};
end
%--------------------------------------------------------------------------
id_pmagnet = f_to_scellargin(id_pmagnet);
%--------------------------------------------------------------------------
if any(strcmpi(id_pmagnet,{'_all'}))
    if isfield(c3dobj.emdesign.(id_emdesign),'pmagnet')
        id_pmagnet = fieldnames(c3dobj.emdesign.(id_emdesign).pmagnet);
    else
        return
    end
end
%--------------------------------------------------------------------------
for iec = 1:length(id_pmagnet)
    %----------------------------------------------------------------------
    id_phydom = id_pmagnet{iec};
    to_be_rebuilt = c3dobj.emdesign.(id_emdesign).pmagnet.(id_phydom).to_be_rebuilt;
    if to_be_rebuilt
        %------------------------------------------------------------------
        em_model = c3dobj.emdesign.(id_emdesign).em_model;
        %------------------------------------------------------------------
        f_fprintf(0,'Build #pmagnet',1,id_phydom, ...
                  0,'in #emdesign',1,id_emdesign, ...
                  0,'for',1,em_model,0,'\n');
        %------------------------------------------------------------------
        phydomobj = c3dobj.emdesign.(id_emdesign).pmagnet.(id_phydom);
        %------------------------------------------------------------------
        phydomobj = f_get_id(c3dobj,phydomobj);
        id_elem   = phydomobj.id_elem;
        %------------------------------------------------------------------
        switch em_model
            case {'3d_fem_aphijw','3d_fem_aphits'}
                tic;
                %----------------------------------------------------------
                if ~isempty(phydomobj.br_value) && ~isempty(phydomobj.br_dir)
                    coef_name  = 'br_value';
                    br_value_array = ...
                        f_callcoefficient(c3dobj,'phydomobj',phydomobj,...
                                                 'coefficient',coef_name);
                    coef_name  = 'br_dir';
                    br_dir_array = ...
                        f_callcoefficient(c3dobj,'phydomobj',phydomobj,...
                                                 'coefficient',coef_name);
                    br_array = br_value_array .* br_dir_array;
                elseif ~isempty(phydomobj.br)
                    coef_name  = 'br';
                    br_array = ...
                        f_callcoefficient(c3dobj,'phydomobj',phydomobj,...
                                                 'coefficient',coef_name);
                end
                %----------------------------------------------------------
                coef_name  = 'mu_r';
                coef_array = f_callcoefficient(c3dobj,'phydomobj',phydomobj,...
                                                      'coefficient',coef_name);
                %----------------------------------------------------------
                mu0 = 4 * pi * 1e-7;
                nu0nur = f_invtensor(mu0 .* coef_array);
                %----------------------------------------------------------
                nu0nurwfwf = f_cwfwf(c3dobj,'phydomobj',phydomobj,...
                                            'coefficient',nu0nur);
                %----------------------------------------------------------
                wfbr = f_cwfvf(c3dobj,'phydomobj',phydomobj,'vector_field',br_array);
                %----------------------------------------------------------
                % --- Output
                c3dobj.emdesign.(id_emdesign).pmagnet.(id_phydom).id_elem  = id_elem;
                c3dobj.emdesign.(id_emdesign).pmagnet.(id_phydom).br_array = br_array;
                c3dobj.emdesign.(id_emdesign).pmagnet.(id_phydom).mu_r_array = coef_array;
                c3dobj.emdesign.(id_emdesign).pmagnet.(id_phydom).nu0nurwfwf = nu0nurwfwf;
                c3dobj.emdesign.(id_emdesign).pmagnet.(id_phydom).wfbr     = wfbr;
                % ---
                c3dobj.emdesign.(id_emdesign).pmagnet.(id_phydom).to_be_rebuilt = 0;
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
