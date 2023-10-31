function mu_r = fmurB(B)

if f_magnitude(B) < 1.5
    mu_r = 1000;
else
    mu_r = 10;
end
