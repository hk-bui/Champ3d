function vout = f_foreach(f,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'argument_array','nb_elem'};

% --- default input value
argument_array = {};
nb_elem = [];

% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
if ~isa(f,'function_handle')
    error([mfilename ': #f must be a function handle !']);
end
%--------------------------------------------------------------------------
argument_array = f_to_scellargin(argument_array);
nb_arg = length(argument_array);
nb_fargin = f_nargin(f);
%--------------------------------------------------------------------------
if nb_fargin ~= length(argument_array)
    error([mfilename ': Check number of f arguments !']);
end
%--------------------------------------------------------------------------
nb_elem__ = zeros(1,nb_arg);
size_arg = {};
len_size = {};
for i = 1:nb_arg
    size_arg{i}  = size(argument_array{i});
    len_size{i}  = length(size_arg{i});
    nb_elem__(i) = max(size_arg{i});
end
%--------------------------------------------------------------------------
if isempty(nb_elem)
    nb_elem = max(nb_elem__);
end
%--------------------------------------------------------------------------
poidelem = zeros(1,nb_arg);
for i = 1:nb_arg
    po = find(size_arg{i} == nb_elem);
    if ~isempty(po)
        poidelem(i) = po;
    end
end
%--------------------------------------------------------------------------
% if nb_arg > 1
%     if ~all(diff(nb_elem__) == 0)
%         error([mfilename ': Check size of #argument_array !']);
%     end
% end
%--------------------------------------------------------------------------
% Test (brute)

a = {};
for i = 1:nb_fargin
    argu = argument_array{i};
    if poidelem(i)
        
    end
end


if nb_fargin == 0
    vtest = feval(f);
elseif nb_fargin == 1
    
    a1 = argument_array{1};
    vtest = feval(f,argument_array{1});
elseif nb_fargin == 2
    vtest = feval(f,argument_array{1},argument_array{2});
elseif nb_fargin == 3
    vtest = feval(f,argument_array{1},argument_array{2},argument_array{3});
elseif nb_fargin == 4
    vtest = feval(f,argument_array{1},argument_array{2},argument_array{3},argument_array{4});
elseif nb_fargin == 5
    vtest = feval(f,argument_array{1},argument_array{2},argument_array{3},argument_array{4},argument_array{5});
elseif nb_fargin == 6
    vtest = feval(f,argument_array{1},argument_array{2},argument_array{3},argument_array{4},argument_array{5},argument_array{6});
end
%--------------------------------------------------------------------------
sizev = size(vtest);
vout = zeros([nb_elem sizev]);
for i = 1:nb_elem
    vout()
end













