clear
clc

%% Test mem

nb_time   = 10;
nb_elem__ = 1e5:1e5:1e6;
memsize1 = zeros(1,length(nb_elem__));
memsize2 = zeros(1,length(nb_elem__));

for i = 1:length(nb_elem__)
    nb_elem = nb_elem__(i);
    % ---
    c3dobj1.emdesign3d.em_test_open_js.fields.bv   = sparse(nb_time,nb_elem);
    c3dobj1.emdesign3d.em_test_open_js.fields.jv   = sparse(nb_time,nb_elem);
    c3dobj1.emdesign3d.em_test_open_js.fields.hv   = sparse(nb_time,nb_elem);
    c3dobj1.emdesign3d.em_test_open_js.fields.pv   = sparse(nb_time,nb_elem);
    c3dobj1.emdesign3d.em_test_open_js.fields.av   = sparse(nb_time,nb_elem);
    c3dobj1.emdesign3d.em_test_open_js.fields.phiv = sparse(nb_time,nb_elem);
    c3dobj1.thdesign3d.th_test_open_js.fields.tv   = sparse(nb_time,nb_elem);
    % ---
    memc3dobj1 = whos('c3dobj1');
    memsize1(i) =  memc3dobj1.bytes / (2^20); % to MB
    % ---
    c3dobj2.emdesign3d.em_test_open_js.fields.bv   = zeros(nb_time,nb_elem);
    c3dobj2.emdesign3d.em_test_open_js.fields.jv   = zeros(nb_time,nb_elem);
    c3dobj2.emdesign3d.em_test_open_js.fields.hv   = zeros(nb_time,nb_elem);
    c3dobj2.emdesign3d.em_test_open_js.fields.pv   = zeros(nb_time,nb_elem);
    c3dobj2.emdesign3d.em_test_open_js.fields.av   = zeros(nb_time,nb_elem);
    c3dobj2.emdesign3d.em_test_open_js.fields.phiv = zeros(nb_time,nb_elem);
    c3dobj2.thdesign3d.th_test_open_js.fields.tv   = zeros(nb_time,nb_elem);
    % ---
    memc3dobj2 = whos('c3dobj2');
    memsize2(i) =  memc3dobj2.bytes / (2^20); % to MB
end

figure
semilogy(nb_elem__,memsize1,'ro-','displayname','sparse'); hold on
semilogy(nb_elem__,memsize2,'kx-','displayname','zeros/ones');
legend('show');
ylabel('Mem (MB)'); xlabel('nb elem');
