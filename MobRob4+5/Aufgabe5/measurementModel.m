% measurementModel.m
%
% function prob = measurementModel(z,x,y,theta,lm);
%
% Liefert die Wahrscheinlichkeit zur�ck, dass an der Position x,y,theta 
% die n Sensormessungen z = [d_1; , d_2; ..., d_n] 
% zu den n Landmarken lm = [l_x1, l_y1; l_x2, l_y2; ...; l_xn, l_yn] beobachtet werden.
% Einheiten in rad und m.
%
% O. Bittel
% 13.12.2013
%
function prob = measurementModel(z,x,y,lm)
    n = length(z);
    prob = 1;
    for i = 1:n
        d = sqrt((lm(i,1)-x)^2 + (lm(i,2)-y)^2);
        sigma_d_2 = 2^2/1;   % Varianz [m^2/m]; d.h. 5cm Fehler (sigma) bei 1 m Entfernung
        prob = prob * ndf(z(i),d,sigma_d_2*d);
    end
return; 