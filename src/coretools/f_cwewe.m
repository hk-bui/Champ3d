function coefwewe = f_cwewe(c3dobj,varargin)
% F_CWEWE computes the mass matrix int_v(coef x We x We x dv)
%--------------------------------------------------------------------------
% OUTPUT
% CoefWeWe : nb_edges_in_volume x nb_edges_in_volume
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'design3d','id_design3d','dom_type','id_dom',...
           'phydomobj','coefficient','coef_array_type'};

% --- default input value
design3d = [];
id_design3d = [];
dom_type  = [];
id_dom    = [];
phydomobj = [];
coefficient = [];
coef_array_type = [];

% --- default output value
coef_array = [];

% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if isempty(phydomobj)
    if ~isempty(design3d) && ~isempty(id_design3d) && ~isempty(dom_type) && ~isempty(id_dom)
        phydomobj = c3dobj.(design3d).(id_design3d).(dom_type).(id_dom);
    else
        return;
    end
end
%--------------------------------------------------------------------------
if isempty(coef_array_type)
    if length(size(coefficient)) == 2
        coef_array_type = 'iso_array';
    elseif length(size(coefficient)) == 3
        coef_array_type = 'tensor_array';
    end
end
%--------------------------------------------------------------------------
id_mesh3d = phydomobj.id_mesh3d;
id_dom3d  = phydomobj.id_dom3d;
id_elem   = c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d).id_elem;
nb_elem   = length(id_elem);
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
con = f_connexion(c3dobj.elem_type);
nbEd_inEl = con.nbEd_inEl;
nbElem    = c3dobj.nbElem;
nbEdge    = c3dobj.nbEdge;

if isempty(id_elem)
    id_elem = 1:nbElem;
end
%--------------------------------------------------------------------------

matCoef = f_cmatrix(coef,'dim',dim,'id_elem',id_elem,'nb_elem',nbElem);

%--------------------------------------------------------------------------

SWeWe = zeros(nbEd_inEl,nbElem,nbEd_inEl);
for iG = 1:con.nbG
    for i = 1:nbEd_inEl
        for j = i:nbEd_inEl % !!! i
            switch dim
                case 3
                    SWeWe(i,id_elem,j) = SWeWe(i,id_elem,j) + ...
                        f_multrowv(con.Weigh(iG).*c3dobj.detJ{iG}(id_elem),...
                        matCoef(1,1,id_elem).*c3dobj.We{iG}(1,i,id_elem).*c3dobj.We{iG}(1,j,id_elem)+...
                        matCoef(1,2,id_elem).*c3dobj.We{iG}(2,i,id_elem).*c3dobj.We{iG}(1,j,id_elem)+...
                        matCoef(1,3,id_elem).*c3dobj.We{iG}(3,i,id_elem).*c3dobj.We{iG}(1,j,id_elem)+...
                        matCoef(2,1,id_elem).*c3dobj.We{iG}(1,i,id_elem).*c3dobj.We{iG}(2,j,id_elem)+...
                        matCoef(2,2,id_elem).*c3dobj.We{iG}(2,i,id_elem).*c3dobj.We{iG}(2,j,id_elem)+...
                        matCoef(2,3,id_elem).*c3dobj.We{iG}(3,i,id_elem).*c3dobj.We{iG}(2,j,id_elem)+...
                        matCoef(3,1,id_elem).*c3dobj.We{iG}(1,i,id_elem).*c3dobj.We{iG}(3,j,id_elem)+...
                        matCoef(3,2,id_elem).*c3dobj.We{iG}(2,i,id_elem).*c3dobj.We{iG}(3,j,id_elem)+...
                        matCoef(3,3,id_elem).*c3dobj.We{iG}(3,i,id_elem).*c3dobj.We{iG}(3,j,id_elem));
                case 2
                    SWeWe(i,id_elem,j) = SWeWe(i,id_elem,j) + ...
                        f_multrowv(con.Weigh(iG).*c3dobj.detJ{iG}(id_elem),...
                        matCoef(1,1,id_elem).*c3dobj.We{iG}(1,i,id_elem).*c3dobj.We{iG}(1,j,id_elem)+...
                        matCoef(1,2,id_elem).*c3dobj.We{iG}(2,i,id_elem).*c3dobj.We{iG}(1,j,id_elem)+...
                        matCoef(2,1,id_elem).*c3dobj.We{iG}(1,i,id_elem).*c3dobj.We{iG}(2,j,id_elem)+...
                        matCoef(2,2,id_elem).*c3dobj.We{iG}(2,i,id_elem).*c3dobj.We{iG}(2,j,id_elem));
            end
        end
    end
end
%--------------------------------------------------------------------------
coefwewe = sparse(nbEdge,nbEdge);

for i = 1:nbEd_inEl
    for j = i+1 : nbEd_inEl
        coefwewe = coefwewe + ...
            sparse(c3dobj.edge_in_elem(i,:),c3dobj.edge_in_elem(j,:),...
                   SWeWe(i,:,j),nbEdge,nbEdge);
    end
end

coefwewe = coefwewe + coefwewe.';

for i = 1:nbEd_inEl
    coefwewe = coefwewe + ...
        sparse(c3dobj.edge_in_elem(i,:),c3dobj.edge_in_elem(i,:),...
               SWeWe(i,:,i),nbEdge,nbEdge);
end





