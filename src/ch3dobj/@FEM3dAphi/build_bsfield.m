%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

function build_bsfield(obj)
phydom_type = 'bsfield';
% ---
allphydom = fieldnames(obj.(phydom_type));
% ---
for i = 1:length(allphydom)
    % ---
    id_phydom = allphydom{i};
    % ---
    phydom = obj.(phydom_type).(id_phydom);
    dom__ = phydom.dom;
    for j = 1:length(dom__)
        dom = dom__{j};
        parent_mesh = dom.parent_mesh;
        gid_elem    = dom.gid_elem;
        %------------------------------------------------------
        bs = obj.(phydom_type).(id_phydom).bs.get_on(dom);
        wfbs = parent_mesh.cwfvf('id_elem',gid_elem,'vector_field',bs);
        %------------------------------------------------------
        obj.(phydom_type).(id_phydom).matrix.wfbs{j} = wfbs;
    end
end
end