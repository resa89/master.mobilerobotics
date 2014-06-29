% normeAngle.m
% function alpha_n = normAngle(alpha)
% alpha: 	   Winkel
% alpha_n:     auf [-pi, +pi] transformierter Winkel.
%
% O. Bittel; 15.5.2009
%
function alpha_n = normAngle(alpha)

alpha_n = alpha;

while alpha_n > pi
   alpha_n = alpha_n - 2*pi;
end

while alpha_n <= -pi
   alpha_n = alpha_n + 2*pi;
end