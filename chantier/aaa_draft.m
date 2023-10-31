%--------------------------------------------------------------------------
if isfield(phydomobj,'id_emdesign3d')
    id_mesh3d = c3dobj.emdesign3d.(phydomobj.id_emdesign3d).id_mesh3d;
elseif isfield(phydomobj,'id_thdesign3d')
    id_mesh3d = c3dobj.thdesign3d.(phydomobj.id_thdesign3d).id_mesh3d;
end
id_dom3d  = phydomobj.id_dom3d;
id_elem   = c3dobj.mesh3d.(id_mesh3d).dom3d.(id_dom3d).id_elem;
node = c3dobj.mesh3d.(id_mesh3d).celem(:,id_elem);
vf = bs_array;
figure
f_quiver(node,vf.');
%--------------------------------------------------------------------------





F   = design3d.mesh.R.' * MfJ;
Mff = f_cwfwf(design3d.mesh);
S   = design3d.mesh.R.' * Mff * design3d.mesh.R;


%----------------------------------------------------------------------
Bs = design3d.sfield.bs;
%----------------------------------------------------------------------
MfJ = f_wfvf(design3d.mesh,'vector_field',Bs);
F   = design3d.mesh.R.' * MfJ;
Mff = f_cwfwf(design3d.mesh);
S   = design3d.mesh.R.' * Mff * design3d.mesh.R;
%--------------------------------------------------------------------------
iEA = setdiff(1:design3d.mesh.nbEdge,design3d.bcon(design3d.sfield.id_bcon).id_edge);
F   = F(iEA,1);
S   = S(iEA,iEA);
% figure
% f_viewthings('type','edge','node',mesh.node,'edge',mesh.edge(:,bcon(ibcon).id_edge));
%--------------------------------------------------------------------------
ABr = zeros(design3d.mesh.nbEdge,1);
ABr(iEA) = f_qmr(S,F);
%--------------------------------------------------------------------------
%rotA = dom3d.mesh.R * mRHS;
%B = f_postpro3d(dom3d.mesh,rotA,'W2');
%figure
%f_viewthings('type','elem','node',dom3d.mesh.node,'elem',dom3d.mesh.elem(:,dom3d.sfield(1).id_elem),...
%         'elem_type','prism','color','r'); hold on
%f_quiver(dom3d.mesh.cnode,real(B),'sfactor',2);
%--------------------------------------------------------------------------
mu0 = 4*pi*1e-7;
Mff = f_cwfwf(design3d.mesh,'coef',1/(mu0));
mRHS = design3d.mesh.R.' * Mff * design3d.mesh.R * ABr;
%--------------------------------------------------------------------------
design3d.aphi.sfieldRHS = mRHS;
design3d.aphi.Bs = Bs;

%--------------------------------------------------------------------------
close all
figure; plot(1,1,'or')
texpos = get(gca, 'OuterPosition');
hold on;
text(texpos(1)+1,texpos(2)+1.01, ...
     '$\overrightarrow{\mathbf{champ}}\mathbf{3d}$', ...
     'FontSize',10, ...
     'FontWeight','bold',...
     'Color','blue', ...
     'Interpreter','latex',...
     'Units','normalized', ...
     'VerticalAlignment', 'baseline', ...
     'HorizontalAlignment', 'right');



