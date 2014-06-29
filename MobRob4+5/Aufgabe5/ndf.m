% ndf.m
% 
% function prob = ndf(x, mu, sigma_2)
%
% Normal density function with mean mu and variance sigma_2.
%
function prob = ndf(x,mu,sigma_2)
prob = (1/sqrt(2*pi*sigma_2)) * exp(-0.5*(x-mu)^2/sigma_2);
return;
