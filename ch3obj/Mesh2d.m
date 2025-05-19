%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to Champ3d code.
%--------------------------------------------------------------------------
% Champ3d is copyright (c) 2023-2025 H-K. Bui.
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% See LICENSE and CREDITS files for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef Mesh2d < Mesh
    % --- Constructors
    methods
        function obj = Mesh2d()
            obj = obj@Mesh;
        end
    end
    % --- Methods - Add dom
    methods
        % ---
        function add_vdom(obj,args)
            arguments
                obj
                % ---
                args.id char = []
                % ---
                args.id_xline = []
                args.id_yline = []
                % ---
                args.elem_code = []
                args.gid_elem = []
                args.condition char = []
                % ---
                args.dom_obj {mustBeA(args.dom_obj,{'VolumeDom2d'})}
            end
            % ---
            if isempty(args.id)
                error('#id must be given !');
            end
            % ---
            if ~isfield(args,'dom_obj')
                args.parent_mesh = obj;
                % ---
                argu = f_to_namedarg(args,'for','VolumeDom2d');
                dom = VolumeDom2d(argu{:});
                obj.dom.(args.id) = dom;
                % ---
                obj.is_defining_obj_of(dom);
                % ---
            else
                dom = args.dom_obj;
                dom.id = args.id;
                obj.dom.(args.id) = dom;
                % obj.is_defining_obj_of(dom);
            end
        end
        % --- XTODO
        function add_sdom(obj,args)
            arguments
                obj
                % ---
                args.id char
                % ---
                args.mesh1d = []
                % ---
                args.id_xline = []
                args.id_yline = []
                % ---
                args.elem_code = []
                args.gid_elem = []
                args.condition char = []
            end
            % ---
            args.parent_mesh = obj;
            % ---
            argu = f_to_namedarg(args,'for','SurfaceDom2d');
            dom = SurfaceDom2d(argu{:});
            obj.dom.(args.id) = dom;
            % ---
            obj.is_defining_obj_of(dom);
            % ---
        end
    end

    % --- Methods - Integ
    methods
        % -----------------------------------------------------------------
        function coefwn = cwn(obj,args)
            arguments
                obj
                args.id_elem = []
                args.coefficient = 1
                args.order = 'full'
            end
            %--------------------------------------------------------------
            id_elem = args.id_elem;
            coefficient = args.coefficient;
            order = args.order;
            %--------------------------------------------------------------
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
            %--------------------------------------------------------------
            [coefficient, coef_array_type] = f_column_format(coefficient);
            %--------------------------------------------------------------
            refelem = obj.refelem;
            nbNo_inEl = refelem.nbNo_inEl;
            %--------------------------------------------------------------
            if isempty(obj.intkit.Wn) || isempty(obj.intkit.cWn)
                obj.build_intkit;
            end
            %--------------------------------------------------------------
            switch order
                case '0'
                    nbG = 1;
                    Weigh = refelem.cWeigh;
                    % ---
                    Wn = cell(1,nbG);
                    detJ = cell(1,nbG);
                    for iG = 1:nbG
                        Wn{iG} = obj.intkit.cWn{iG}(:,id_elem);
                        detJ{iG} = obj.intkit.cdetJ{iG}(1,id_elem);
                    end
                case 'full'
                    nbG = refelem.nbG;
                    Weigh = refelem.Weigh;
                    % ---
                    Wn = cell(1,nbG);
                    detJ = cell(1,nbG);
                    for iG = 1:nbG
                        Wn{iG} = obj.intkit.Wn{iG}(:,id_elem);
                        detJ{iG} = obj.intkit.detJ{iG}(1,id_elem);
                    end
            end
            %--------------------------------------------------------------
            coefwn = zeros(nbNo_inEl,nb_elem);
            %--------------------------------------------------------------
            if any(f_strcmpi(coef_array_type,{'scalar'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    dJ    = detJ{iG};
                    weigh = Weigh(iG);
                    for i = 1:nbNo_inEl
                        wix = Wn{iG}(i,:);
                        coefwn(i,:) = coefwn(i,:) + ...
                            weigh .* dJ .* coefficient .* wix;
                    end
                end
                %----------------------------------------------------------
            else
                error('#coefficient must be scalar');
            end
        end
        % -----------------------------------------------------------------
        function coefwnwn = cwnwn(obj,args)
            arguments
                obj
                args.id_elem = []
                args.coefficient = 1
                args.order = 'full'
            end
            %--------------------------------------------------------------
            id_elem = args.id_elem;
            coefficient = args.coefficient;
            order = args.order;
            %--------------------------------------------------------------
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
            %--------------------------------------------------------------
            [coefficient, coef_array_type] = f_column_format(coefficient);
            %--------------------------------------------------------------
            refelem = obj.refelem;
            nbNo_inEl = refelem.nbNo_inEl;
            %--------------------------------------------------------------
            if isempty(obj.intkit.Wn) || isempty(obj.intkit.cWn)
                obj.build_intkit;
            end
            %--------------------------------------------------------------
            switch order
                case '0'
                    nbG = 1;
                    Weigh = refelem.cWeigh;
                    % ---
                    Wn = cell(1,nbG);
                    detJ = cell(1,nbG);
                    for iG = 1:nbG
                        Wn{iG} = obj.intkit.cWn{iG}(:,id_elem);
                        detJ{iG} = obj.intkit.cdetJ{iG}(1,id_elem);
                    end
                case 'full'
                    nbG = refelem.nbG;
                    Weigh = refelem.Weigh;
                    % ---
                    Wn = cell(1,nbG);
                    detJ = cell(1,nbG);
                    for iG = 1:nbG
                        Wn{iG} = obj.intkit.Wn{iG}(:,id_elem);
                        detJ{iG} = obj.intkit.detJ{iG}(1,id_elem);
                    end
            end
            %--------------------------------------------------------------
            coefwnwn = zeros(nbNo_inEl,nbNo_inEl,nb_elem);
            %--------------------------------------------------------------
            if any(f_strcmpi(coef_array_type,{'scalar'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    dJ    = detJ{iG};
                    weigh = Weigh(iG);
                    for i = 1:nbNo_inEl
                        wix = Wn{iG}(i,:);
                        for j = i:nbNo_inEl
                            wjx = Wn{iG}(j,:);
                            coefwnwn(i,j,:) = squeeze(coefwnwn(i,j,:)).' + ...
                                weigh .* dJ .* coefficient .* ...
                                (wix .* wjx);
                        end
                    end
                end
                %----------------------------------------------------------
            else
                error('#coefficient must be scalar');
            end
        end
        % -----------------------------------------------------------------
        function coefwewe = cwewe(obj,args)
            arguments
                obj
                args.id_elem = []
                args.coefficient = 1
                args.order = 'full'
            end
            %--------------------------------------------------------------
            id_elem = args.id_elem;
            coefficient = args.coefficient;
            order = args.order;
            %--------------------------------------------------------------
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
            %--------------------------------------------------------------
            [coefficient, coef_array_type] = f_column_format(coefficient);
            %--------------------------------------------------------------
            refelem = obj.refelem;
            nbEd_inEl = refelem.nbEd_inEl;
            %--------------------------------------------------------------
            if isempty(obj.intkit.We) || isempty(obj.intkit.cWe)
                obj.build_intkit;
            end
            %--------------------------------------------------------------
            switch order
                case '0'
                    nbG = 1;
                    Weigh = refelem.cWeigh;
                    % ---
                    We = cell(1,nbG);
                    detJ = cell(1,nbG);
                    for iG = 1:nbG
                        We{iG} = obj.intkit.cWe{iG}(:,:,id_elem);
                        detJ{iG} = obj.intkit.cdetJ{iG}(1,id_elem);
                    end
                case 'full'
                    nbG = refelem.nbG;
                    Weigh = refelem.Weigh;
                    % ---
                    We = cell(1,nbG);
                    detJ = cell(1,nbG);
                    for iG = 1:nbG
                        We{iG} = obj.intkit.We{iG}(:,:,id_elem);
                        detJ{iG} = obj.intkit.detJ{iG}(1,id_elem);
                    end
            end
            %--------------------------------------------------------------
            coefwewe = zeros(nbEd_inEl,nbEd_inEl,nb_elem);
            %--------------------------------------------------------------
            if any(f_strcmpi(coef_array_type,{'scalar'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    dJ    = detJ{iG};
                    weigh = Weigh(iG);
                    for i = 1:nbEd_inEl
                        weix = We{iG}(1,i,:);
                        weiy = We{iG}(2,i,:);
                        for j = i:nbEd_inEl % !!! i
                            wejx = We{iG}(1,j,:);
                            wejy = We{iG}(2,j,:);
                            % ---
                            coefwewe(i,j,:) = squeeze(coefwewe(i,j,:)).' + ...
                                weigh .* dJ .* coefficient .* ...
                                squeeze(weix .* wejx + weiy .* wejy).';
                        end
                    end
                end
                %----------------------------------------------------------
            elseif any(f_strcmpi(coef_array_type,{'tensor'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    dJ    = detJ{iG};
                    weigh = Weigh(iG);
                    for i = 1:nbEd_inEl
                        weix = We{iG}(1,i,:);
                        weiy = We{iG}(2,i,:);
                        for j = i:nbEd_inEl % !!! i
                            wejx = We{iG}(1,j,:);
                            wejy = We{iG}(2,j,:);
                            % ---
                            coefwewe(i,j,:) = squeeze(coefwewe(i,j,:)).' + ...
                                weigh .* dJ .* ...
                                squeeze(...
                                coefficient(:,1,1) .* weix .* wejx +...
                                coefficient(:,1,2) .* weiy .* wejx +...
                                coefficient(:,2,1) .* weix .* wejy +...
                                coefficient(:,2,2) .* weiy .* wejy).';
                        end
                    end
                end
                %----------------------------------------------------------
            end
        end
        % -----------------------------------------------------------------
        function coefwfwf = cwfwf(obj,args)
            arguments
                obj
                args.id_elem = []
                args.coefficient = 1
                args.order = 'full'
            end
            %--------------------------------------------------------------
            id_elem = args.id_elem;
            coefficient = args.coefficient;
            order = args.order;
            %--------------------------------------------------------------
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
            %--------------------------------------------------------------
            [coefficient, coef_array_type] = f_column_format(coefficient);
            %--------------------------------------------------------------
            refelem = obj.refelem;
            nbFa_inEl = refelem.nbFa_inEl;
            %--------------------------------------------------------------
            if isempty(obj.intkit.Wf) || isempty(obj.intkit.cWf)
                obj.build_intkit;
            end
            %--------------------------------------------------------------
            switch order
                case '0'
                    nbG = 1;
                    Weigh = refelem.cWeigh;
                    % ---
                    Wf = cell(1,nbG);
                    detJ = cell(1,nbG);
                    for iG = 1:nbG
                        Wf{iG} = obj.intkit.cWf{iG}(:,:,id_elem);
                        detJ{iG} = obj.intkit.cdetJ{iG}(1,id_elem);
                    end
                case 'full'
                    nbG = refelem.nbG;
                    Weigh = refelem.Weigh;
                    % ---
                    Wf = cell(1,nbG);
                    detJ = cell(1,nbG);
                    for iG = 1:nbG
                        Wf{iG} = obj.intkit.Wf{iG}(:,:,id_elem);
                        detJ{iG} = obj.intkit.detJ{iG}(1,id_elem);
                    end
            end
            %--------------------------------------------------------------
            coefwfwf = zeros(nbFa_inEl,nbFa_inEl,nb_elem);
            %--------------------------------------------------------------
            if any(f_strcmpi(coef_array_type,{'scalar'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    dJ    = detJ{iG};
                    weigh = Weigh(iG);
                    for i = 1:nbFa_inEl
                        weix = Wf{iG}(1,i,:);
                        weiy = Wf{iG}(2,i,:);
                        for j = i:nbFa_inEl % !!! i
                            wejx = Wf{iG}(1,j,:);
                            wejy = Wf{iG}(2,j,:);
                            % ---
                            coefwfwf(i,j,:) = squeeze(coefwfwf(i,j,:)).' + ...
                                weigh .* dJ .* coefficient .* ...
                                squeeze(weix .* wejx + weiy .* wejy).';
                        end
                    end
                end
                %----------------------------------------------------------
            elseif any(f_strcmpi(coef_array_type,{'tensor'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    dJ    = detJ{iG};
                    weigh = Weigh(iG);
                    for i = 1:nbFa_inEl
                        weix = Wf{iG}(1,i,:);
                        weiy = Wf{iG}(2,i,:);
                        for j = i:nbFa_inEl % !!! i
                            wejx = Wf{iG}(1,j,:);
                            wejy = Wf{iG}(2,j,:);
                            % ---
                            coefwfwf(i,j,:) = squeeze(coefwfwf(i,j,:)).' + ...
                                weigh .* dJ .* ...
                                squeeze(...
                                coefficient(:,1,1) .* weix .* wejx +...
                                coefficient(:,1,2) .* weiy .* wejx +...
                                coefficient(:,2,1) .* weix .* wejy +...
                                coefficient(:,2,2) .* weiy .* wejy).';
                        end
                    end
                end
                %----------------------------------------------------------
            end
        end
        % -----------------------------------------------------------------
        function coefwevf = cwevf(obj,args)
            arguments
                obj
                args.id_elem = []
                args.coefficient = 1
                args.vector_field = [1 1 1];
                args.order = 'full'
            end
            %--------------------------------------------------------------
            id_elem = args.id_elem;
            coefficient = args.coefficient;
            order = args.order;
            vector_field = args.vector_field;
            %--------------------------------------------------------------
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
            %--------------------------------------------------------------
            [coefficient, coef_array_type] = f_column_format(coefficient);
            vector_field = f_column_format(vector_field);
            %--------------------------------------------------------------
            refelem = obj.refelem;
            nbEd_inEl = refelem.nbEd_inEl;
            %--------------------------------------------------------------
            if isempty(obj.intkit.We) || isempty(obj.intkit.cWe)
                obj.build_intkit;
            end
            %--------------------------------------------------------------
            switch order
                case '0'
                    nbG = 1;
                    Weigh = refelem.cWeigh;
                    % ---
                    We = cell(1,nbG);
                    detJ = cell(1,nbG);
                    for iG = 1:nbG
                        We{iG} = obj.intkit.cWe{iG}(:,:,id_elem);
                        detJ{iG} = obj.intkit.cdetJ{iG}(1,id_elem);
                    end
                case 'full'
                    nbG = refelem.nbG;
                    Weigh = refelem.Weigh;
                    % ---
                    We = cell(1,nbG);
                    detJ = cell(1,nbG);
                    for iG = 1:nbG
                        We{iG} = obj.intkit.We{iG}(:,:,id_elem);
                        detJ{iG} = obj.intkit.detJ{iG}(1,id_elem);
                    end
            end
            %--------------------------------------------------------------
            coefwevf = zeros(nbEd_inEl,nb_elem);
            %--------------------------------------------------------------
            if numel(vector_field) == 2
                vfx = vector_field(1);
                vfy = vector_field(2);
            elseif size(vector_field,2) > length(id_elem) && ...
                   size(vector_field,2) == obj.nb_elem
                vfx = vector_field(1,id_elem);
                vfy = vector_field(2,id_elem);
            else
                vfx = vector_field(1,:);
                vfy = vector_field(2,:);
            end
            %--------------------------------------------------------------
            if any(strcmpi(coef_array_type,{'scalar'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    dJ    = detJ{iG};
                    weigh = Weigh(iG);
                    for i = 1:nbEd_inEl
                        wfix = We{iG}(1,i,:);
                        wfiy = We{iG}(2,i,:);
                        coefwevf(i,:) = coefwevf(i,:) + ...
                            weigh .* dJ .* coefficient .* ...
                            squeeze(wfix .* vfx + wfiy .* vfy).';
                    end
                end
                %----------------------------------------------------------
            elseif any(strcmpi(coef_array_type,{'tensor'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    dJ    = detJ{iG};
                    weigh = Weigh(iG);
                    for i = 1:nbEd_inEl
                        wfix = We{iG}(1,i,:);
                        wfiy = We{iG}(2,i,:);
                        coefwevf(i,:) = coefwevf(i,:) + ...
                            weigh .* dJ .* ...
                            squeeze(...
                            coefficient(:,1,1) .* wfix .* vfx +...
                            coefficient(:,1,2) .* wfiy .* vfx +...
                            coefficient(:,2,1) .* wfix .* vfy +...
                            coefficient(:,2,2) .* wfiy .* vfy).';
                    end
                end
                %----------------------------------------------------------
            end
        end
        % -----------------------------------------------------------------
        function coefwfvf = cwfvf(obj,args)
            arguments
                obj
                args.id_elem = []
                args.coefficient = 1
                args.vector_field = [1 1 1];
                args.order = 'full'
            end
            %--------------------------------------------------------------
            id_elem = args.id_elem;
            coefficient = args.coefficient;
            order = args.order;
            vector_field = args.vector_field;
            %--------------------------------------------------------------
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
            %--------------------------------------------------------------
            [coefficient, coef_array_type] = f_column_format(coefficient);
            vector_field = f_column_format(vector_field);
            %--------------------------------------------------------------
            refelem = obj.refelem;
            nbFa_inEl = refelem.nbFa_inEl;
            %--------------------------------------------------------------
            if isempty(obj.intkit.Wf) || isempty(obj.intkit.cWf)
                obj.build_intkit;
            end
            %--------------------------------------------------------------
            switch order
                case '0'
                    nbG = 1;
                    Weigh = refelem.cWeigh;
                    % ---
                    Wf = cell(1,nbG);
                    detJ = cell(1,nbG);
                    for iG = 1:nbG
                        Wf{iG} = obj.intkit.cWf{iG}(:,:,id_elem);
                        detJ{iG} = obj.intkit.cdetJ{iG}(1,id_elem);
                    end
                case 'full'
                    nbG = refelem.nbG;
                    Weigh = refelem.Weigh;
                    % ---
                    Wf = cell(1,nbG);
                    detJ = cell(1,nbG);
                    for iG = 1:nbG
                        Wf{iG} = obj.intkit.Wf{iG}(:,:,id_elem);
                        detJ{iG} = obj.intkit.detJ{iG}(1,id_elem);
                    end
            end
            %--------------------------------------------------------------
            coefwfvf = zeros(nbFa_inEl,nb_elem);
            %--------------------------------------------------------------
            if numel(vector_field) == 2
                vfx = vector_field(1);
                vfy = vector_field(2);
            elseif size(vector_field,2) > length(id_elem) && ...
                   size(vector_field,2) == obj.nb_elem
                vfx = vector_field(1,id_elem);
                vfy = vector_field(2,id_elem);
            else
                vfx = vector_field(1,:);
                vfy = vector_field(2,:);
            end
            %--------------------------------------------------------------
            if any(strcmpi(coef_array_type,{'scalar'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    dJ    = detJ{iG};
                    weigh = Weigh(iG);
                    for i = 1:nbFa_inEl
                        wfix = Wf{iG}(1,i,:);
                        wfiy = Wf{iG}(2,i,:);
                        coefwfvf(i,:) = coefwfvf(i,:) + ...
                            weigh .* dJ .* coefficient .* ...
                            squeeze(wfix .* vfx + wfiy .* vfy).';
                    end
                end
                %----------------------------------------------------------
            elseif any(strcmpi(coef_array_type,{'tensor'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    dJ    = detJ{iG};
                    weigh = Weigh(iG);
                    for i = 1:nbFa_inEl
                        wfix = Wf{iG}(1,i,:);
                        wfiy = Wf{iG}(2,i,:);
                        coefwfvf(i,:) = coefwfvf(i,:) + ...
                            weigh .* dJ .* ...
                            squeeze(...
                            coefficient(:,1,1) .* wfix .* vfx +...
                            coefficient(:,1,2) .* wfiy .* vfx +...
                            coefficient(:,2,1) .* wfix .* vfy +...
                            coefficient(:,2,2) .* wfiy .* vfy).';
                    end
                end
                %----------------------------------------------------------
            end
        end
    end

    % ---get field
    methods
        % -----------------------------------------------------------------
        function scalar_field = field_wn(obj,args)
            arguments
                obj
                args.id_elem = []
                args.coefficient = 1
                args.dof = 1
                args.on {mustBeMember(args.on,{'center','gauss_points','interpolation_points'})} = 'center'
            end
            %--------------------------------------------------------------
            id_elem = args.id_elem;
            coefficient = args.coefficient;
            dof = args.dof;
            on_ = args.on;
            %--------------------------------------------------------------
            nb_elem = obj.nb_elem;
            % ---
            if isempty(id_elem)
                id_elem = 1:nb_elem;
            end
            %--------------------------------------------------------------
            if numel(dof) ~= obj.nb_node
                error('dof must be defined in whole mesh !');
            end
            %--------------------------------------------------------------
            [coefficient, coef_array_type] = f_column_format(coefficient);
            dof = TensorArray.scalar(dof);
            %--------------------------------------------------------------
            refelem = obj.refelem;
            nbNo_inEl = refelem.nbNo_inEl;
            %--------------------------------------------------------------
            if isempty(obj.elem)
                error('No mesh data !');
            end
            elem = obj.elem;
            %--------------------------------------------------------------
            switch on_
                case 'center'
                    % ---
                    if isempty(obj.intkit.cWn)
                        obj.build_intkit;
                    end
                    % ---
                    nbG = 1;
                    % ---
                    Wx = cell(1,nbG);
                    for iG = 1:nbG
                        Wx{iG} = obj.intkit.cWn{iG}(:,id_elem);
                    end
                case 'gauss_points'
                    % ---
                    if isempty(obj.intkit.Wn)
                        obj.build_intkit;
                    end
                    % ---
                    nbG = refelem.nbG;
                    % ---
                    Wx = cell(1,nbG);
                    for iG = 1:nbG
                        Wx{iG} = obj.intkit.Wn{iG}(:,id_elem);
                    end
                case 'interpolation_points'
                    % ---
                    if isempty(obj.prokit.Wn)
                        obj.build_prokit;
                    end
                    % ---
                    nbG = obj.refelem.nbI;
                    % ---
                    Wx = cell(1,nbG);
                    for iG = 1:nbG
                        Wx{iG} = obj.prokit.Wn{iG}(:,id_elem);
                    end
            end
            %--------------------------------------------------------------
            scalar_field = cell(nbG,1);
            for i = 1:nbG
                scalar_field{i} = sparse(1,nb_elem);
            end
            %--------------------------------------------------------------
            if any(f_strcmpi(coef_array_type,{'scalar'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    fi = zeros(1,length(id_elem));
                    for i = 1:nbNo_inEl
                        wi = Wx{iG}(i,:);
                        id_node = elem(i,id_elem);
                        fi(1,:) = fi(1,:) + coefficient .* wi .* dof(id_node);
                    end
                    % ---
                    scalar_field{iG}(1,id_elem) = fi;
                end
                % ---
                if nbG == 1
                    scalar_field = scalar_field{1};
                end
                %----------------------------------------------------------
            else
                error('#coefficient must be scalar');
            end
        end
        % -----------------------------------------------------------------
        function vector_field = field_we(obj,args)
            arguments
                obj
                args.id_elem = []
                args.coefficient = 1
                args.dof = 1
                args.on {mustBeMember(args.on,{'center','gauss_points','interpolation_points'})} = 'center'
            end
            %--------------------------------------------------------------
            id_elem = args.id_elem;
            coefficient = args.coefficient;
            dof = args.dof;
            on_ = args.on;
            %--------------------------------------------------------------
            nb_elem = obj.nb_elem;
            % ---
            if isempty(id_elem)
                id_elem = 1:nb_elem;
            end
            %--------------------------------------------------------------
            if numel(dof) ~= obj.nb_edge
                error('dof must be defined in whole mesh !');
            end
            %--------------------------------------------------------------
            [coefficient, coef_array_type] = f_column_format(coefficient);
            dof = TensorArray.scalar(dof);
            %--------------------------------------------------------------
            refelem = obj.refelem;
            nbEd_inEl = refelem.nbEd_inEl;
            %--------------------------------------------------------------
            if isempty(obj.meshds.id_edge_in_elem)
                obj.build_meshds;
            end
            id_edge_in_elem = obj.meshds.id_edge_in_elem;
            %--------------------------------------------------------------
            switch on_
                case 'center'
                    % ---
                    if isempty(obj.intkit.cWe)
                        obj.build_intkit;
                    end
                    % ---
                    nbG = 1;
                    % ---
                    Wx = cell(1,nbG);
                    for iG = 1:nbG
                        Wx{iG} = obj.intkit.cWe{iG}(:,:,id_elem);
                    end
                case 'gauss_points'
                    % ---
                    if isempty(obj.intkit.We)
                        obj.build_intkit;
                    end
                    % ---
                    nbG = refelem.nbG;
                    % ---
                    Wx = cell(1,nbG);
                    for iG = 1:nbG
                        Wx{iG} = obj.intkit.We{iG}(:,:,id_elem);
                    end
                case 'interpolation_points'
                    % ---
                    if isempty(obj.prokit.We)
                        obj.build_prokit;
                    end
                    % ---
                    nbG = obj.refelem.nbI;
                    % ---
                    Wx = cell(1,nbG);
                    for iG = 1:nbG
                        Wx{iG} = obj.prokit.We{iG}(:,:,id_elem);
                    end
            end
            %--------------------------------------------------------------
            vector_field = cell(nbG,1);
            for i = 1:nbG
                vector_field{i} = sparse(2,nb_elem);
            end
            %--------------------------------------------------------------
            if any(f_strcmpi(coef_array_type,{'scalar'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    fi = zeros(2,length(id_elem));
                    for i = 1:nbEd_inEl
                        wix = squeeze(Wx{iG}(1,i,:)).';
                        wiy = squeeze(Wx{iG}(2,i,:)).';
                        id_edge = id_edge_in_elem(i,id_elem);
                        fi(1,:) = fi(1,:) + coefficient .* wix .* dof(id_edge);
                        fi(2,:) = fi(2,:) + coefficient .* wiy .* dof(id_edge);
                    end
                    % ---
                    vector_field{iG}(1:2,id_elem) = fi;
                end
                % ---
                if nbG == 1
                    vector_field = vector_field{1};
                end
                %----------------------------------------------------------
            elseif any(f_strcmpi(coef_array_type,{'tensor'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    fi = zeros(2,length(id_elem));
                    %------------------------------------------------------
                    for i = 1:nbEd_inEl
                        wix = Wx{iG}(1,i,:);
                        wiy = Wx{iG}(2,i,:);
                        id_edge = id_edge_in_elem(i,id_elem);
                        fi(1,:) = fi(1,:) + ...
                            squeeze(coefficient(:,1,1) .* wix + ...
                                    coefficient(:,1,2) .* wiy).' ...
                            .* dof(id_edge) ;
                        fi(2,:) = fi(2,:) + ...
                            squeeze(coefficient(:,2,1) .* wix + ...
                                    coefficient(:,2,2) .* wiy).' ...
                            .* dof(id_edge) ;
                    end
                    % ---
                    vector_field{iG}(1:2,id_elem) = fi;
                end
                % ---
                if nbG == 1
                    vector_field = vector_field{1};
                end
                %----------------------------------------------------------
            end
        end
        % -----------------------------------------------------------------
        function vector_field = field_wf(obj,args)
            arguments
                obj
                args.id_elem = []
                args.coefficient = 1
                args.dof = 1
                args.on {mustBeMember(args.on,{'center','gauss_points','interpolation_points'})} = 'center'
            end
            %--------------------------------------------------------------
            id_elem = args.id_elem;
            coefficient = args.coefficient;
            dof = args.dof;
            on_ = args.on;
            %--------------------------------------------------------------
            nb_elem = obj.nb_elem;
            % ---
            if isempty(id_elem)
                id_elem = 1:nb_elem;
            end
            %--------------------------------------------------------------
            if numel(dof) ~= obj.nb_face
                error('dof must be defined in whole mesh !');
            end
            %--------------------------------------------------------------
            [coefficient, coef_array_type] = f_column_format(coefficient);
            dof = TensorArray.scalar(dof);
            %--------------------------------------------------------------
            refelem = obj.refelem;
            nbFa_inEl = refelem.nbFa_inEl;
            %--------------------------------------------------------------
            if isempty(obj.meshds.id_face_in_elem)
                obj.build_meshds;
            end
            id_face_in_elem = obj.meshds.id_face_in_elem;
            %--------------------------------------------------------------
            switch on_
                case 'center'
                    % ---
                    if isempty(obj.intkit.cWf)
                        obj.build_intkit;
                    end
                    % ---
                    nbG = 1;
                    % ---
                    Wx = cell(1,nbG);
                    for iG = 1:nbG
                        Wx{iG} = obj.intkit.cWf{iG}(:,:,id_elem);
                    end
                case 'gauss_points'
                    % ---
                    if isempty(obj.intkit.Wf)
                        obj.build_intkit;
                    end
                    % ---
                    nbG = refelem.nbG;
                    % ---
                    Wx = cell(1,nbG);
                    for iG = 1:nbG
                        Wx{iG} = obj.intkit.Wf{iG}(:,:,id_elem);
                    end
                case 'interpolation_points'
                    % ---
                    if isempty(obj.prokit.Wf)
                        obj.build_prokit;
                    end
                    % ---
                    nbG = obj.refelem.nbI;
                    % ---
                    Wx = cell(1,nbG);
                    for iG = 1:nbG
                        Wx{iG} = obj.prokit.Wf{iG}(:,:,id_elem);
                    end
            end
            %--------------------------------------------------------------
            vector_field = cell(nbG,1);
            for i = 1:nbG
                vector_field{i} = sparse(2,nb_elem);
            end
            %--------------------------------------------------------------
            if any(f_strcmpi(coef_array_type,{'scalar'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    fi = zeros(2,length(id_elem));
                    for i = 1:nbFa_inEl
                        wix = squeeze(Wx{iG}(1,i,:)).';
                        wiy = squeeze(Wx{iG}(2,i,:)).';
                        id_face = id_face_in_elem(i,id_elem);
                        fi(1,:) = fi(1,:) + coefficient .* wix .* dof(id_face);
                        fi(2,:) = fi(2,:) + coefficient .* wiy .* dof(id_face);
                    end
                    % ---
                    vector_field{iG}(1:2,id_elem) = fi;
                end
                % ---
                if nbG == 1
                    vector_field = vector_field{1};
                end
                %----------------------------------------------------------
            elseif any(f_strcmpi(coef_array_type,{'tensor'}))
                %----------------------------------------------------------
                for iG = 1:nbG
                    fi = zeros(2,length(id_elem));
                    %------------------------------------------------------
                    for i = 1:nbFa_inEl
                        wix = Wx{iG}(1,i,:);
                        wiy = Wx{iG}(2,i,:);
                        id_face = id_face_in_elem(i,id_elem);
                        fi(1,:) = fi(1,:) + ...
                            squeeze(coefficient(:,1,1) .* wix + ...
                                    coefficient(:,1,2) .* wiy).' ...
                            .* dof(id_face) ;
                        fi(2,:) = fi(2,:) + ...
                            squeeze(coefficient(:,2,1) .* wix + ...
                                    coefficient(:,2,2) .* wiy).' ...
                            .* dof(id_face) ;
                    end
                    % ---
                    vector_field{iG}(1:2,id_elem) = fi;
                end
                % ---
                if nbG == 1
                    vector_field = vector_field{1};
                end
                %----------------------------------------------------------
            end
        end
        % -----------------------------------------------------------------
    end

    % --- Methods - Plot
    methods
        % -----------------------------------------------------------------
        function plot(obj,args)
            arguments
                obj
                args.edge_color = [0.4940 0.1840 0.5560]
                args.face_color = 'c'
                args.alpha {mustBeNumeric} = 0.9
                args.field_value = []
            end
            %--------------------------------------------------------------
            mshalone = 1;
            forcomplx   = 1;
            forvector   = 1;
            fval     = [];
            for3d    = 0;
            if ~isempty(args.field_value)
                mshalone = 0;
                fval = f_column_format(args.field_value);
                % ---
                if isreal(fval)
                    forcomplx = 0;
                end
                % ---
                if size(fval,2) == 1
                    forvector = 0;
                end
                % ---
                if size(fval,2) == 3
                    for3d = 1;
                end
            end
            %--------------------------------------------------------------
            if forvector
                fx = fval(:,1);
                fy = fval(:,2);
                if for3d
                    fz = fval(:,3);
                end
            end
            %--------------------------------------------------------------
            edge_color_  = args.edge_color;
            face_color_  = args.face_color;
            alpha_       = args.alpha;
            %--------------------------------------------------------------
            clear msh;
            %--------------------------------------------------------------
            msh.Vertices = obj.node.';
            if isa(obj,'QuadMesh')
                msh.Faces = obj.elem(1:4,:).';
            elseif isa(obj,'TriMesh')
                msh.Faces = obj.elem(1:3,:).';
            end
            msh.FaceColor = face_color_;
            msh.EdgeColor = edge_color_; % [0.7 0.7 0.7] --> gray
            %--------------------------------------------------------------
            if mshalone
                patch(msh);
            else
                if forvector
                    if forcomplx
                        % ---
                        subplot(131);
                        msh.FaceVertexCData = (f_magnitude(fval.')).';
                        patch(msh,'DisplayName','magnitude');
                        % ---
                        subplot(132);
                        msh.FaceVertexCData = [];
                        patch(msh,'DisplayName','real-part'); hold on
                        f_quiver(obj.node,real(fval.'));
                        % ---
                        subplot(133);
                        msh.FaceVertexCData = [];
                        patch(msh,'DisplayName','imag-part'); hold on
                        f_quiver(obj.node,imag(fval.'));
                    else
                        % ---
                        subplot(121);
                        msh.FaceVertexCData = (f_magnitude(fval.')).';
                        patch(msh,'DisplayName','magnitude');
                        % ---
                        subplot(122);
                        msh.FaceVertexCData = [];
                        patch(msh,'DisplayName','vector-field'); hold on
                        f_quiver(obj.node,fval.');
                    end
                else
                    if forcomplx
                        % ---
                        subplot(121);
                        msh.FaceVertexCData = real(fval);
                        patch(msh,'DisplayName','real-part');
                        % ---
                        subplot(122);
                        msh.FaceVertexCData = imag(fval);
                        patch(msh,'DisplayName','imag-part');
                    else
                        msh.FaceVertexCData = fval;
                        patch(msh);
                    end
                end
            end
            %--------------------------------------------------------------
            xlabel('x (m)'); ylabel('y (m)');
            if size(obj.node,1) == 3
                zlabel('z (m)'); view(3);
            end
            axis equal; axis tight; alpha(alpha_); hold on
            %--------------------------------------------------------------
            f_chlogo;
        end
    end
end




