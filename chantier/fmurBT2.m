function mu_r = fmurBT2(varargin)

% how to put fmu_r outside ?

B0    = [0   0   2  2];
T0    = [0   200 0  200];
mu_r0 = [1e3 1   10 1];

fmu_r = scatteredInterpolant(B0, T0, mu_r0);
mu_r  = murBT(B, T);