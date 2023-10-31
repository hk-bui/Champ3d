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
arglist = {'id_emdesign3d','id_coil'};

% --- default input value
id_emdesign3d = [];
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
if isempty(id_emdesign3d)
    error([mfilename ': #id_emdesign3d must be given']); 
end
%--------------------------------------------------------------------------
if iscell(id_emdesign3d)
    id_emdesign3d = id_emdesign3d{1};
end
%--------------------------------------------------------------------------
id_coil = f_to_scellargin(id_coil);
%--------------------------------------------------------------------------
if any(strcmpi(id_coil,{'_all'}))
    if isfield(c3dobj.emdesign3d.(id_emdesign3d),'coil')
        id_coil = fieldnames(c3dobj.emdesign3d.(id_emdesign3d).coil);
    else
        return
    end
end
%--------------------------------------------------------------------------
for iec = 1:length(id_coil)
    id_phydom = id_coil{iec};
    %----------------------------------------------------------------------
    em_model = c3dobj.emdesign3d.(id_emdesign3d).em_model;
    %----------------------------------------------------------------------
    f_fprintf(0,'Build #coil',1,id_phydom, ...
              0,'in #emdesign3d',1,id_emdesign3d, ...
              0,'for',1,em_model,0,'\n');
    switch em_model
        case {'fem_aphijw','fem_aphits'}
            tic;
            %--------------------------------------------------------------
            phydomobj = c3dobj.emdesign3d.(id_emdesign3d).coil.(id_phydom);
            %--------------------------------------------------------------
            coef_name  = 'sigma';
            coef_array = f_callcoefficient(c3dobj,'phydomobj',phydomobj,...
                                                  'coefficient',coef_name);
            %--------------------------------------------------------------
            sigwewe = f_cwewe(c3dobj,'phydomobj',phydomobj,...
                                     'coefficient',coef_array);
            %--------------------------------------------------------------
            % --- Output
            c3dobj.emdesign3d.(id_emdesign3d).coil.(id_phydom).sigwewe = sigwewe;
        case {'fem_tomejw','fem_tomets'}
            % TODO
    end
    % --- Log message
    f_fprintf(0,'--- in',...
              1,toc, ...
              0,'s \n');
end