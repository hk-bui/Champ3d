function [field, node, id_node] = f_incmove(field,node,varargin)
% F_INCREMENTALMOVE returns ... related to an incremental move in x, y or z
% direction.
% field : [1 x nbElem]
% node  : [3 x nbElem]
% 'direction' : 'x', 'y' or 'z'
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'id_node','direction','nb_step','cyclic_move'};

% --- default input value
id_node = [];
direction = [];
nb_step = 1;
cyclic_move = 0;

% --- check and update input
for i = 1:(nargin-2)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': Check function arguments : ' strjoin(arglist,', ') ' !']);
    end
end

%--------------------------------------------------------------------------
if isempty(id_node)
    id_node = 1:length(field);
end
%--------------------------------------------------------------------------
if strcmpi(direction,'x')
    [node, id] = f_multisort(node,'sort_order',[1 2 3]);
    cmov       = node(1,:);
    id_node    = id_node(id);
    field      = field(id);
elseif strcmpi(direction,'y')
    [node, id] = f_multisort(node,'sort_order',[2 1 3]);
    cmov       = node(2,:);
    id_node    = id_node(id);
    field      = field(id);
elseif strcmpi(direction,'z')
    [node, id] = f_multisort(node,'sort_order',[3 1 2]);
    cmov       = node(3,:);
    id_node    = id_node(id);
    field      = field(id);
end
%--------------------------------------------------------------------------
dcz = [1  find(diff(cmov))+1];
%--------------------------------------------------------------------------
nb_cmov = length(dcz) - 1;
for i = 1 : nb_cmov
    iP{i} = dcz(i) : dcz(i+1)-1; % all have same cmov
    f{i}  = field(iP{i});
end
%--------------------------------------------------------------------------
for i = 1 : nb_cmov
    k = i + nb_step;
    if k <= nb_cmov
        field(iP{k}) = f{i};
    else
        if ~cyclic_move
            field(iP{i}) = 0;
        else
            k = mod(k,nb_cmov); if k == 0; k = nb_cmov; end
            field(iP{k}) = f{i};
        end
    end
end


% for k = 1:nb_step
%     for i = 1 : length(dcz)-1
%         iP0 = dcz(i) : dcz(i+1)-1;
%         if i < length(dcz)-1
%             iP1 = dcz(i+1) : dcz(i+2)-1;
%             if i == 1
%                 f0 = field(iP0);
%             end
%             field(iP0) = field(iP1);
%         else
%             if ~cyclic_move
%                 field(iP0) = 0;
%             else
%                 field(iP0) = f0;
%             end
%         end
%     end
% end
%--------------------------------------------------------------------------