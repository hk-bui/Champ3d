function mu_r = fmurBarray(B)

nb_elem = size(B,2);
mu_r = zeros(1,nb_elem);

iBa = find(f_magnitude((B)) <= 1.5);
iBb = find(f_magnitude((B)) > 1.5);

mu_r(iBa) = 1000;
mu_r(iBb) = 10;
