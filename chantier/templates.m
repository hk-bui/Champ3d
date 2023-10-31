%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.

% --- for help file
o-- obligation
r-- recommendation
l-- linked to, related to


%--------------------------------------------------------------------------
% --- valid argument list (to be updated each time modifying function)
arglist = {''};

% --- default input value
id_mesh2d = [];

% --- check and update input
for i = 1:(nargin-1)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': Check function arguments : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if ~strcmpi(build_from,'geo1d')
    error([mfilename ' : #build_from must be specified !']);
end
if isempty(id_mesh2d)
    error([mfilename ' : #id_mesh2d must be given !']);
end
%--------------------------------------------------------------------------
keeparg = {'flog','id_x','id_y'};
argtopass = {};
for i = 1:length(keeparg)
    argtopass{2*i-1} = keeparg{i};
    argtopass{2*i}   = eval(keeparg{i});
end
%--------------------------------------------------------------------------
while iscell(id_mesh2d)
    id_mesh2d = id_mesh2d{1};
end
%--------------------------------------------------------------------------
codeidx * codeidy
codeidx * codeidy * codeidl
%--------------------------------------------------------------------------
tic
fprintf(['Add dom2d #' id_dom2d ' defined by : \n']);
fprintf(['id_x #' strjoin(id_x,', #') '\n']);
fprintf(['id_y #' strjoin(id_y,', #')]);
fprintf(' --- in %.2f s \n',toc);
%--------------------------------------------------------------------------
%----------------------------------------------------------
id_xij = id_x{i}{j};
id_xij = replace(id_xij,'...','');
% checking validity
idxvalid = regexp(all_id_x,[id_xij '\w*']);
% ---
for m = 1:length(idxvalid)
    if sum(idxvalid{m}) >= 1
        codeidx = f_str2code(all_id_x{m});
    end
end
%--------------------------------------------------------------------------
if isempty(id_emdesign3d)
    id_emdesign3d = fieldnames(c3dobj.emdesign3d);
    id_emdesign3d = id_emdesign3d{1};
end
%--------------------------------------------------------------------------
if isempty(id_design3d)
    id_design3d = fieldnames(c3dobj.design3d);
    id_design3d = id_design3d{1};
end
%--------------------------------------------------------------------------
if isempty(id_mesh1d)
    id_mesh1d = fieldnames(c3dobj.mesh1d);
    id_mesh1d = id_mesh1d{1};
end
%--------------------------------------------------------------------------
c3dobj.mesh2d.(c3dobj.mesh3d.(id_mesh3d).id_mesh2d)
c3dobj.mesh1d.(c3dobj.mesh3d.(id_mesh3d).id_mesh1d)
%--------------------------------------------------------------------------
if isempty(id_mesh3d)
    error([mfilename ': no mesh3d found !']);
else
    mesh3d = c3dobj.mesh3d.(id_mesh3d);
end
%--------------------------------------------------------------------------
grep -r -n --color=always f_edge *
find . -type f -name '*.m' -exec sed -i 's/for/pour/g' {} \;
find . -type f -name '*.m' -exec sed -i 's/\/2/pour/g' {} \;
find . -type f -name '*.m' -exec sed -i 's/(nargin-1)/length(varargin)/g' {} \;
sed -i "s/Check function arguments/'' /g" {} \; % outer double quote to allow inner single quote
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
edge_in_elem = f_get_edge_in_elem(c3dobj,'of_dom3d',id_dom3d);
nb_edge = numel(unique(edge_in_elem));
%--------------------------------------------------------------------------
CoefWeWe = sparse(nb_edge,nb_edge);

for i = 1:nbEd_inEl
    for j = i+1 : nbEd_inEl
        CoefWeWe = CoefWeWe + ...
            sparse(edge_in_elem(i,:),edge_in_elem(j,:),...
                   coefwewe(i,:,j),nb_edge,nb_edge);
    end
end

CoefWeWe = CoefWeWe + CoefWeWe.';

for i = 1:nbEd_inEl
    CoefWeWe = CoefWeWe + ...
        sparse(edge_in_elem(i,:),edge_in_elem(i,:),...
               coefwewe(i,:,i),nb_edge,nb_edge);
end
%--------------------------------------------------------------------------
{'cdetJ','cJinv','cWn','cgradWn','cWe','cWf','detJ','Jinv','Wn','gradWn','We','Wf'}