%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

function coefwfvf = cwfvf(obj,args)
arguments
    obj
    args.id_elem = []
    args.coefficient = 1
    args.vector_field = [1 1 1];
    args.order = 'full'
end
%--------------------------------------------------------------------------
id_elem = args.id_elem;
coefficient = args.coefficient;
order = args.order;
vector_field = args.vector_field;
%--------------------------------------------------------------------------
if isempty(id_elem)
    nb_elem = obj.nb_elem;
    id_elem = 1:nb_elem;
else
    nb_elem = length(id_elem);
end
% ---
if isnumeric(order)
    if order < 1
        order = '0';
    else
        order = 'full';
    end
end
%--------------------------------------------------------------------------
[coefficient, coef_array_type] = f_column_format(coefficient);
%--------------------------------------------------------------------------
if ~iscell(vector_field)
    vector_field = f_column_format(vector_field);
end
%--------------------------------------------------------------------------
refelem = obj.refelem;
nbFa_inEl = refelem.nbFa_inEl;
%--------------------------------------------------------------------------
if isempty(obj.intkit.Wf) || isempty(obj.intkit.cWf)
    obj.build_intkit;
end
%--------------------------------------------------------------------------
switch order
    case '0'
        nbG = 1;
        Weigh = refelem.cWeigh;
        % ---
        Wf = cell(1,nbG);
        detJ = cell(1,nbG);
        for iG = 1:nbG
            Wf{iG} = obj.intkit.cWf{iG}(id_elem,:,:);
            detJ{iG} = obj.intkit.cdetJ{iG}(id_elem,1);
        end
    case 'full'
        nbG = refelem.nbG;
        Weigh = refelem.Weigh;
        % ---
        Wf = cell(1,nbG);
        detJ = cell(1,nbG);
        for iG = 1:nbG
            Wf{iG} = obj.intkit.Wf{iG}(id_elem,:,:);
            detJ{iG} = obj.intkit.detJ{iG}(id_elem,1);
        end
end
%--------------------------------------------------------------------------
coefwfvf = zeros(nb_elem,nbFa_inEl);
%--------------------------------------------------------------------------
vfx = cell(3,1);
vfy = cell(3,1);
vfz = cell(3,1);
if ~iscell(vector_field)
    for iG = 1:nbG
        if numel(vector_field) == 3
            vfx{iG} = vector_field(1);
            vfy{iG} = vector_field(2);
            vfz{iG} = vector_field(3);
        elseif size(vector_field,1) >  length(id_elem) && ...
               size(vector_field,1) == obj.nb_elem
            vfx{iG} = vector_field(id_elem,1);
            vfy{iG} = vector_field(id_elem,2);
            vfz{iG} = vector_field(id_elem,3);
        else
            vfx{iG} = vector_field(:,1);
            vfy{iG} = vector_field(:,2);
            vfz{iG} = vector_field(:,3);
        end
    end
else
    for iG = 1:nbG
        vfx{iG} = vector_field{iG}(:,1);
        vfy{iG} = vector_field{iG}(:,2);
        vfz{iG} = vector_field{iG}(:,3);
    end
end
%--------------------------------------------------------------------------
if any(strcmpi(coef_array_type,{'scalar'}))
    %----------------------------------------------------------------------
    for iG = 1:nbG
        dJ    = f_tocolv(detJ{iG});
        weigh = Weigh(iG);
        % ---
        vix = vfx{iG}(:,1);
        viy = vfy{iG}(:,1);
        viz = vfz{iG}(:,1);
        % ---
        for i = 1:nbFa_inEl
            % ---
            wix = Wf{iG}(:,1,i);
            wiy = Wf{iG}(:,2,i);
            wiz = Wf{iG}(:,3,i);
            % ---
            coefwfvf(:,i) = coefwfvf(:,i) + ...
                weigh .* dJ .* ( coefficient .* ...
                (wix .* vix + wiy .* viy + wiz .* viz) );
        end
    end
    %----------------------------------------------------------------------
elseif any(strcmpi(coef_array_type,{'tensor'}))
    %----------------------------------------------------------------------
    for iG = 1:nbG
        dJ    = f_tocolv(detJ{iG});
        weigh = Weigh(iG);
        % ---
        vix = vfx{iG}(:,1);
        viy = vfy{iG}(:,1);
        viz = vfz{iG}(:,1);
        % ---
        for i = 1:nbFa_inEl
            % ---
            wix = Wf{iG}(:,1,i);
            wiy = Wf{iG}(:,2,i);
            wiz = Wf{iG}(:,3,i);
            % ---
            coefwfvf(:,i) = coefwfvf(:,i) + ...
                weigh .* dJ .* (...
                coefficient(:,1,1) .* wix .* vix +...
                coefficient(:,1,2) .* wiy .* vix +...
                coefficient(:,1,3) .* wiz .* vix +...
                coefficient(:,2,1) .* wix .* viy +...
                coefficient(:,2,2) .* wiy .* viy +...
                coefficient(:,2,3) .* wiz .* viy +...
                coefficient(:,3,1) .* wix .* viz +...
                coefficient(:,3,2) .* wiy .* viz +...
                coefficient(:,3,3) .* wiz .* viz );
        end
    end
    %----------------------------------------------------------------------
end 