function [ x,y ] = sig_elipse( C,mue,k )

%Eigenwerte und Eigenvektoren aus E^-1 berechnen
[V D] = eig( inv(C) );
%Parameterdarstellung der Ellipse ungedreht und um den Nullpunkt
i = -pi:0.01:pi;
E = [k/sqrt(D(1,1)) * cos(i) ; 
     k/sqrt(D(2,2)) * sin(i) ];
%Ellipse drehen mit Rotationsmatrix V
E = V*E;
%Ellipse um mu verschieben
x = E(1,:) + mue(1);
y = E(2,:) + mue(2);


end

