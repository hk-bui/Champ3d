function [edge_in_elem, ori_edge_in_elem] = f_get_edge_in_elem(mesh3d,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'elem_type','of_dom3d'};

% --- default input value
elem_type = [];
of_dom3d = [];
%--------------------------------------------------------------------------
% --- check and update input
for i = 1:(nargin-1)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': Check function arguments : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if isempty(elem_type) && isfield(mesh3d,'elem_type')
    elem_type = mesh3d.elem_type;
end
%--------------------------------------------------------------------------
if isempty(of_dom3d)
    elem = mesh3d.elem;
    defined_on = 'elem';
    %----------------------------------------------------------------------
    if ~isfield(mesh3d,'edge')
        edge = f_get_edge(mesh3d);
    elseif isempty(mesh3d.edge)
        edge = f_get_edge(mesh3d);
    else
        edge = mesh3d.edge;
    end
else
    if ~iscell(of_dom3d)
        of_dom3d = {of_dom3d};
    end
    elem = [];
    for i = 1:length(of_dom3d)
        defined_on = mesh3d.dom3d.(of_dom3d{i}).defined_on;
        if ~any(strcmpi('elem',defined_on))
            error([mfilename ': #of_dom3d list must defined_on elem!']);
        end
        elem = [elem mesh3d.elem(:,mesh3d.dom3d.(of_dom3d{i}).id_elem)];
    end
    %----------------------------------------------------------------------
    mesh3d = [];
    mesh3d.elem = elem;
    edge = f_get_edge(mesh3d);
    %----------------------------------------------------------------------
end
%--------------------------------------------------------------------------
if isempty(elem_type)
    nbnoinel = size(elem, 1);
    if any(strcmpi(defined_on,{'elem','el'}))
        switch nbnoinel
            case 4
                elem_type = 'tet';
            case 6
                elem_type = 'prism';
            case 8
                elem_type = 'hex';
        end
    elseif any(strcmpi(defined_on,{'face','fa'}))
        switch nbnoinel
            case 3
                elem_type = 'tri';
            case 4
                elem_type = 'quad';
        end
    end
    fprintf(['Build meshds for ' elem_type ' \n']);
end
%--------------------------------------------------------------------------
if isempty(elem_type)
    error([mfilename ' : #elem_type must be given !']);
end
%--------------------------------------------------------------------------
con = f_connexion(elem_type);
nbNo_inEd = con.nbNo_inEd;
nbEd_inEl = con.nbEd_inEl;
EdNo_inEl = con.EdNo_inEl;
%--------------------------------------------------------------------------
nbElem = size(elem,2);
%--------------------------------------------------------------------------
e = reshape([elem(EdNo_inEl(:,1),:); elem(EdNo_inEl(:,2),:)], ...
             nbEd_inEl, nbNo_inEd, nbElem);
ori_edge_in_elem = squeeze(sign(diff(e, 1, 2)));
e = sort(e, 2);
%--------------------------------------------------------------------------
edge_in_elem = f_findvecnd(e,edge,'position',2);
%--------------------------------------------------------------------------
% --- Outputs
% mesh3d.edge_in_elem = edge_in_elem;
% mesh3d.ori_edge_in_elem = ori_edge_in_elem;

end