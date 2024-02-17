%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2024
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

classdef Coefficient < Xhandle
    properties
        f
        depend_on
        from
        varargin_list
        fvectorized
        % ---
        value
    end

    % --- Contructor
    methods
        function obj = Coefficient(args)
            arguments
                args.f
                args.depend_on {mustBeMember(args.depend_on,...
                    {'celem','cface', ...
                     'bv','jv','hv','pv','av','phiv','tv','omev','tempv',...
                     'bs','js','hs','ps','as','phis','ts','omes','temps'})}
                args.from = []
                args.varargin_list
                args.fvectorized = 0
            end
            % ---
            if isempty(args.from)
                error('#from must be given ! Give EMModel, THModel, ... ');
            end
            obj <= args;
        end
    end
end