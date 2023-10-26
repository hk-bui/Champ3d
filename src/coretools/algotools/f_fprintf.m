function f_fprintf(varargin)
%--------------------------------------------------------------------------
% This code is written by: H-K. Bui, 2023
% as a contribution to champ3d code.
%--------------------------------------------------------------------------
% champ3d is copyright (c) 2023 H-K. Bui.
% See LICENSE and CREDITS files in champ3d root directory for more information.
% Huu-Kien.Bui@univ-nantes.fr
% IREENA Lab - UR 4642, Nantes Universite'
%--------------------------------------------------------------------------

len = length(varargin);
if mod(len,2) ~= 0
    error([mfilename ': give arguments in pairs (format1,string1,...). \n']);
end

%--------------------------------------------------------------------------
form = {};
str  = {};
for i = 1:len/2
    %----------------------------------------------------------------------
    f = varargin{2*i - 1};
    if isnumeric(f)
        if numel(f) == 1
            if any(f,[0 1 2])
                form{i} = f;
            end
        end
    else
        form{i} = 0;
    end
    %----------------------------------------------------------------------
    s = varargin{2*i};
    if isnumeric(s)
        if numel(s) == 1
            str{i} = num2str(s);
        else
            str{i} = [num2str(s(1)) ',' num2str(s(2)) '...'];
        end
    elseif ischar(s)
        str{i} = s;
    else
        str{i} = '___';
    end
end
%--------------------------------------------------------------------------
for i = 1:len/2
    
end












