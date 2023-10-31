

cobj.emd.d1.x = 1:100;
cobj.emd.d1.y = [];
cobj.emd.d2.x = 1:10;
cobj.emd.d2.y = [];

nb_workers = 10;
parpool('Processes',nb_workers);

parfor i = 1:2
    if i == 1
        cobj.emd.d1.y = cobj.emd.d1.x .^ 2;
    end
    if i == 2
        cobj.emd.d2.y = cobj.emd.d2.x .^ 2;
    end
end

