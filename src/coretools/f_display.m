function f_display(varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
fprintf('----- \n');
for i = 1:length(varargin)
    info = varargin{i};
    if isa(info,'char')
        fprintf([info '\n']);
    elseif isa(info,'cell')
        for j = 1:length(info)
            subinfo = info{j};
            if isa(subinfo,'char')
                fprintf([subinfo ' ']);
            elseif isa(subinfo,'numeric')
                sizesub = size(subinfo);
                if numel(subinfo) == 1
                    fprintf([num2str(subinfo) ' ']);
                elseif length(sizesub) <= 2
                    if sizesub(1) == 1
                        disp(subinfo);
                    elseif sizesub(2) == 1
                        disp(subinfo.');
                    else
                        disp(subinfo);
                    end
                else
                    disp(subinfo);
                end
            end
        end
    else
        disp(info);
    end
end
fprintf('----- \n');
%--------------------------------------------------------------------------