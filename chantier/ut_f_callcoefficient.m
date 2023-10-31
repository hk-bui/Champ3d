
id_emdesign3d = 'bm_01_3d';
id_econductor = 'plate';
%------------------------------------------------------------------
phydomobj = c3dobj.emdesign3d.(id_emdesign3d).econductor.(id_econductor);
%------------------------------------------------------------------
coef_name  = 'sigma';
%------------------------------------------------------------------
ltensor = f_callcoefficient(c3dobj,'phydomobj',phydomobj,...
                                   'coefficient',coef_name);
%gtensor = f_gtensor(ltensor);
%------------------------------------------------------------------