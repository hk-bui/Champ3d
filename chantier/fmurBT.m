function mu_r = fmurBT(B,T)


B0    = [0   0   2  2    50   50].';
T0    = [0   200 0  200   0   200].';
mu_r0 = [1e3 1   10 1     1   1].';

fmu_r = scatteredInterpolant(B0, T0, mu_r0);
mu_r(1)  = fmu_r(f_magnitude(B), T);
mu_r(2)  = mu_r(1) + 1;