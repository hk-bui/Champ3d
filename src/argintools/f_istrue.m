function boolargout = f_istrue(boolargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

if isempty(boolargin)
    boolargout = 0;
elseif isnumeric(boolargin)
    if boolargin > 0
        boolargout = 1;
    else
        boolargout = 0;
    end
elseif ischar(boolargin)
    if any(strcmpi(boolargin,{'no','off'}))
        boolargout = 0;
    elseif any(strcmpi(boolargin,{'yes','on'}))
        boolargout = 1;
    else
        boolargout = 0;
    end
end