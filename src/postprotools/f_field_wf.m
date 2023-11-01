function field_wf = f_field_wf(gvalue,mesh,varargin)
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
arglist = {'id_elem','coefficient','options'};

% --- default input value
id_elem = [];
coefficient = [];
options = 'on_center'; % 'on_center', 'on_gauss_points'

% --- default output value
field_wf = [];

% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
nb_elem = size(mesh.elem,2);
if isempty(id_elem)
    id_elem = 1:nb_elem;
end
%--------------------------------------------------------------------------
if isempty(coefficient)
    coef_array = 1;
    coef_array_type = 'iso_array';
else
    [coef_array, coef_array_type] = f_tensor_array(coefficient);
end
%--------------------------------------------------------------------------
if isfield(mesh,'elem_type')
    elem_type = mesh.elem_type;
else
    elem_type = f_elemtype(mesh.elem,'defined_on','elem');
end
%--------------------------------------------------------------------------
con = f_connexion(elem_type);
nbG = con.nbG;
nbNo_inEl = con.nbNo_inEl;
%--------------------------------------------------------------------------
if any(strcmpi(options,{'on_center'}))
    Wf = mesh.intkit.cWf{1}(id_elem,:);
    fi = zeros(length(id_elem),1);
    for i = 1:nbNo_inEl
        wni = Wn(:,i);
        fi = fi + coef_array .* wni .* gvalue;
    end
    % ---
    field_wf = sparse(id_elem,1,fi,nb_elem,1);
    % ---
elseif any(strcmpi(options,{'on_gauss_points'}))
    % TODO
end
%--------------------------------------------------------------------------
if any(strcmpi(coef_array_type,{'iso_array'}))
    
    
    %----------------------------------------------------------------------
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
                    weigh .* dJ .* ( coef_array .* ...
                    (weix .* wejx + weiy .* wejy + weiz .* wejz) );
            end
        end
    end
    %----------------------------------------------------------------------
elseif any(strcmpi(coef_array_type,{'tensor_array'}))
    %----------------------------------------------------------------------
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
                    weigh .* dJ .* (...
                    coef_array(:,1,1) .* weix .* wejx +...
                    coef_array(:,1,2) .* weiy .* wejx +...
                    coef_array(:,1,3) .* weiz .* wejx +...
                    coef_array(:,2,1) .* weix .* wejy +...
                    coef_array(:,2,2) .* weiy .* wejy +...
                    coef_array(:,2,3) .* weiz .* wejy +...
                    coef_array(:,3,1) .* weix .* wejz +...
                    coef_array(:,3,2) .* weiy .* wejz +...
                    coef_array(:,3,3) .* weiz .* wejz );
            end
        end
    end
    %----------------------------------------------------------------------
end

