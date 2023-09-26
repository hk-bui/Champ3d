function [id_edge_in_face, ori_edge_in_face, sign_edge_in_face] = f_edgeinface(face,edge_list,varargin)
%--------------------------------------------------------------------------
% CHAMP3D PROJECT
% Author : Huu-Kien Bui, IREENA Lab - UR 4642, Nantes Universite'
% Huu-Kien.Bui@univ-nantes.fr
% Copyright (c) 2022 H-K. Bui, All Rights Reserved.
%--------------------------------------------------------------------------

% --- valid argument list (to be updated each time modifying function)
arglist = {'get'};

% --- default input value
get = '_all';

%--------------------------------------------------------------------------
% --- check and update input
for i = 1:length(varargin)/2
    if any(strcmpi(arglist,varargin{2*i-1}))
        eval([lower(varargin{2*i-1}) '= varargin{2*i};']);
    else
        error([mfilename ': #' varargin{2*i-1} ' argument is not valid. Function arguments list : ' strjoin(arglist,', ') ' !']);
    end
end
%--------------------------------------------------------------------------
nb_face = size(face,2);
%--------------------------------------------------------------------------
itria = find(face(4,:) == 0);
iquad = setdiff(1:nb_face,itria);
%--------------------------------------------------------------------------
maxnbEd_inFa = 4;
id_edge_in_face = zeros(maxnbEd_inFa,nb_face);
ori_edge_in_face  = zeros(maxnbEd_inFa,nb_face);
sign_edge_in_face = zeros(maxnbEd_inFa,nb_face);
%--------------------------------------------------------------------------
if ~isempty(itria)
    face_ = face(1:3,itria);
    [id_ed, ori_edge, sign_edge] = ...
        f_edgeinelem(face_,edge_list,'defined_on','face','get',get);
    id_edge_in_face(1:3,itria) = id_ed;
    ori_edge_in_face(1:3,itria) = ori_edge;
    sign_edge_in_face(1:3,itria) = sign_edge;
end
%--------------------------------------------------------------------------
if ~isempty(iquad)
    face_ = face(1:4,iquad);
    [id_ed, ori_edge, sign_edge] = ...
        f_edgeinelem(face_,edge_list,'defined_on','face','get',get);
    id_edge_in_face(1:4,iquad) = id_ed;
    ori_edge_in_face(1:4,iquad) = ori_edge;
    sign_edge_in_face(1:4,iquad) = sign_edge;
end
%--------------------------------------------------------------------------