%function vout = f_coefsize(f,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

clear
clc

% --- test 01
B = [];
T = [];
nb_elem = 11;
B(1:3,1:nb_elem) = ones(3,nb_elem) + 1j .* ones(3,nb_elem);
T(1:nb_elem,1) = linspace(25,100,nb_elem);
f = @fmurBT;
argument_array = {B, T}; %{};

% --- test 02
% cnode = [];
% nb_elem = 5;
% cnode(1,1:nb_elem) = 1 .* ones(1,nb_elem);
% cnode(2,1:nb_elem) = 2 .* ones(1,nb_elem);
% cnode(3,1:nb_elem) = 3 .* ones(1,nb_elem);
% f = @fbr_dir;
% argument_array = {cnode}; %{};


% --- valid argument list (to be updated each time modifying function)
arglist = {'argument_array','nb_elem'};

% --- default input value
% argument_array = {B, T}; %{};
nb_elem = [];

% --- check and update input
% for i = 1:length(varargin)/2
%     if any(strcmpi(arglist,varargin{2*i-1}))
%         eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
%     else
%         error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
%     end
% end
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
arg_pattern = {};
for i = 1:nb_arg
    ap = '(';
    for j = 1:len_size{i}
        if j == poidelem(i)
            ap = [ap 'id_elem,'];
        else
            ap = [ap ':,'];
        end
    end
    ap(end) = [];
    ap = [ap ')'];
    arg_pattern{i} = ap;
end
%--------------------------------------------------------------------------
% Test
%--------------------------------------------------------------------------
if nb_fargin == 0
    fformular = 'f()';
else
    fformular = 'f(';
    for i = 1:nb_fargin
        fformular = [fformular 'a{' num2str(i) '},'];
    end
    fformular(end) = [];
    fformular = [fformular ')'];
end
%--------------------------------------------------------------------------
nb_elem_test = 10; % to make sure that there is no confusion
%--------------------------------------------------------------------------
try
    a = {};
    for i = 1:nb_fargin
        id_elem = ones(1,nb_elem_test); %1:nb_elem__(i);
        eval(['a{i} = argument_array{i}' arg_pattern{i} ';']);
    end
    eval(['vtest = ' fformular ';']);
catch
    a = {};
    for i = 1:nb_fargin
        id_elem = 1;
        eval(['a{i} = argument_array{i}' arg_pattern{i} ';']);
    end
    eval(['vtest = ' fformular ';']);
end
%--------------------------------------------------------------------------
coef_size = size(vtest);
if numel(vtest) == 1
    len_size = 1;
else
    len_size = length(coef_size);
end
%--------------------------------------------------------------------------
if any(coef_size == nb_elem_test)
    is_array = 1;
else
    is_array = 0;
end
%--------------------------------------------------------------------------
coef_pattern = '(';
for i = 1:len_size
    if coef_size(i) == nb_elem_test
        coef_pattern = [coef_pattern 'id_elem,'];
    else
        coef_pattern = [coef_pattern ':,'];
    end
end
coef_pattern(end) = [];
coef_pattern = [coef_pattern ')'];
%--------------------------------------------------------------------------
if is_array
    for i = 1:len_size
        if coef_size(i) == nb_elem_test
            coef_size(i) = nb_elem;
        end
    end
end







