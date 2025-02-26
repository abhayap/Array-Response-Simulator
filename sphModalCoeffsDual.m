function b_N = sphModalCoeffsDual(N, kr, ka)
%SPHMODALCOEFFS Modal coefficients for rigid or open spherical array
%
%   N: maximum order
%   kr: wavenumber-radius product
%   arrayType: {'open','rigid','directional'} open for open array of 
%               omnidirectional sensors, rigid for sensors mounted on a 
%               rigid baffle, directional for an array of first-order 
%               directional microphones determined by the dirCoeff
%   dirCoeff:   relevant only in the 'directional' type, dirCoeff ranges
%               from 0 (omni) to 1 (dipole), where for example 0.5 is a
%               cardioid sensor. In the 0 case it is equivalent to an open
%               array of omnis. The first order directivity function is
%               defined as d(theta) = dirCoeff + (1-dirCoeff)*cos(theta)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SPHMODALCOEFFS.M - 15/7/2013, updated 12/2/2013
% Archontis Politis, archontis.politis@aalto.fi
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

b_N = zeros(length(kr), N+1);

for n=0:N
    jn = sph_besselj(n, kr);
    jnprime = dsph_besselj(n, ka);
    hn = sph_hankel2(n, kr);
    hnprime = dsph_hankel2(n, ka);

    temp = 4*pi*1i^n * (jn-(jnprime./hnprime).*hn);
    if n==0
        temp(kr==0) = 4*pi;
    else
        temp(kr==0) = 0;
    end
    b_N(:, n+1) = temp;
end

% Avoid NaNs for very high orders, instead of very small values
b_N(isnan(b_N)) = 0;
