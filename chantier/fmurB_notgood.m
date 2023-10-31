function mu_r = fmurB_notgood(B)

if abs(f_norm(B)) <= 1.5
    mu_r = 1e3;
else
    mu_r = 1;
end
