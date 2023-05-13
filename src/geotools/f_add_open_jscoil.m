function c3dobj = f_add_open_jscoil(c3dobj,varargin)
% F_ADD_COIL ...
%--------------------------------------------------------------------------
% FIXED INPUT
% emdesign3d : actual design
%--------------------------------------------------------------------------
% OPTIONAL INPUT
% 'id_dom3d' : ids of 3D domains
% 'id_bcon'  : ids of the applied boundary condition
% 'id_elem'  : elements' ids (used if id_dom3d is not available)
% 'coil_mode' = 'transmitter' or 'receiver'
%     + use 'transmitter' for source coil
% 'etrode_type' : electrode type : 'close' or 'open'
%     + for 'close'-type coil
%         o 'cs_equation' : cross section equation
%     + for 'open'-type coil
%         o 'petrode_equation' : equation to define positive electrode nodes
%         o 'netrode_equation' : equation to define negative electrode nodes
% 'v_petrode' : positive electrode potential
% 'v_netrode' : negative electrode potential
% 'stype' : source type
%     + 'j' : impressed j
%         o 'jcoil' : given j
%         o 'cs_area' : cross section area
%     + 'i' : impressed i
%     + 'v' : impressed v
% 'field_vector_o' : coordinates of the origine of the field vector
% 'field_vector_v' : the field vector that indicates approximatively
%                    the orientation of the source field
%--------------------------------------------------------------------------
% OUTPUT
% emdesign3d with added coil
%--------------------------------------------------------------------------
% EXAMPLE
% emdesign3d = f_add_coil(emdesign3d,'id_dom3d','coil',...
%                          'coil_type','stranded',...
%                          'coil_mode','transmitter',...
%                          'etrode_type','open',...
%                          'petrode_equation',{'z == max(z) & x < 0'},...
%                          'netrode_equation',{'z == max(z) & x > 0'},...
%                          'v_petrode',1,...
%                          'v_netrode',0,...
%                          'stype','j','j_coil',Icoil/coilSection,...
%                          'cs_area',coilSection,...
%                          'id_bcon',1);
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'id_emdesign3d','id_coil','id_dom3d','id_elem','etrode_type',...
           'coil_mode','coil_type',...
           'cs_equation','petrode_equation','netrode_equation',...
           'field_vector_o','field_vector_v','nb_turn', ...
           'v_petrode','v_netrode','stype','cs_area','j_coil','i_coil','id_bcon'};
       

% --- default input value
id_emdesign3d = [];
id_coil       = [];
id_dom3d      = [];
id_elem       = [];
id_node       = [];
coil_mode     = 'transmitter'; % or 'receiver'
coil_type     = [];
etrode_type   = [];
cs_equation   = [];
petrode_equation = [];
netrode_equation = [];
v_petrode = 1;
v_netrode = 0;
stype     = [];
cs_area   = 1;
j_coil    = 1;
i_coil    = 1;
nb_turn   = 1;
id_bcon   = [];
field_vector_o = [];
field_vector_v = [];
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

if isempty(id_emdesign3d)
    id_emdesign3d = fieldnames(c3dobj.emdesign3d);
    id_emdesign3d = id_emdesign3d{1};
end

if isempty(id_dom3d)
    error([mfilename ' : #id_dom3d must be given !']);
end

if isempty(id_coil)
    error([mfilename ' : #id_coil must be given !']);
end

%--------------------------------------------------------------------------
if ~isempty(c3dobj.coil(iec+1).petrode_equation)
    if ~iscell(c3dobj.coil(iec+1).petrode_equation)
        petrode_equation{1} = c3dobj.coil(iec+1).petrode_equation;
    else
        petrode_equation = c3dobj.coil(iec+1).petrode_equation;
    end
    for itrod = 1:length(c3dobj.coil(iec+1).petrode_equation)
        geo = f_findnode(c3dobj.mesh.node,c3dobj.mesh.elem(:,c3dobj.coil(iec+1).id_elem),...
                'elem_type',c3dobj.mesh.elem_type,...
                'cut_equation',petrode_equation{itrod});
        geo.id_elem = c3dobj.coil(iec+1).id_elem(geo.id_elem); % !!!
        %------
        c3dobj.coil(iec+1).petrode(itrod) = geo;
        %------
    end
end
%--------------------------------------------------------------------------
if ~isempty(c3dobj.coil(iec+1).netrode_equation)
    if ~iscell(c3dobj.coil(iec+1).netrode_equation)
        netrode_equation{1} = c3dobj.coil(iec+1).netrode_equation;
    else
        netrode_equation = c3dobj.coil(iec+1).netrode_equation;
    end
    for itrod = 1:length(c3dobj.coil(iec+1).netrode_equation)
        geo = f_findnode(c3dobj.mesh.node,c3dobj.mesh.elem(:,c3dobj.coil(iec+1).id_elem),...
                'elem_type',c3dobj.mesh.elem_type,...
                'cut_equation',netrode_equation{itrod});
        geo.id_elem = c3dobj.coil(iec+1).id_elem(geo.id_elem); % !!!
        %------
        c3dobj.coil(iec+1).netrode(itrod) = geo;
        %------
    end
end
end

