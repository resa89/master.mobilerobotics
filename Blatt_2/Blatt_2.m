%% Blatt 2 Aufgabe 1
clc; clear;

% Kovarianzmatrix
C = [3.8 -7.7; -7.7 22.2];
% Mittelwerte
mue = [3;1];

% Berechnen der x,y-Werte der 1,2-Sigma-Ellipse 
% Anmerkung: ca. 86% aller x,y-Paare sollten innerhalb der Ellipse liegen

for k=1:10
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

figure (1)
hold on
plot(x,y)
grid on
hold off
axis square
end

%% Aufgabe 2
clc; clear;

n=100;
% Kovarianzmatrix
C = [4 0;0 9];
% Mittelwerte
mue = [0;0];

% Zufallszahlen
%--------------------------------------------------------------------------
tmp = mvrandn(mue,C,n);
x = tmp(1,:);
y = tmp(2,:);

figure (2)
hold on
plot(x,y,'r*')

% Berechnen der x,y-Werte der 1,2-Sigma-Ellipse 
%--------------------------------------------------------------------------
for k=1:2
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

plot(x,y)
end

% Kreis drms
%--------------------------------------------------------------------------
drms= sqrt(C(1,1)+C(2,2));
Kreis = [drms * cos(i) ; 
         drms * sin(i) ];
x = Kreis(1,:) + mue(1);
y = Kreis(2,:) + mue(2);

plot(x,y,'g')

axis equal
grid on
hold off

%% Aufgabe 3

C1=[56.63 20.25; 20.25 8.37];
C2=[0.69 -1.2; -1.2 3.56];

mue1=[2;1];
mue2=[4;3];

[x1,y1]=sig_elipse(C1,mue1,1);
[x2,y2]=sig_elipse(C2,mue2,1);
[mue,C] = combine( mue1, C1, mue2, C2);
[x3,y3]=sig_elipse(C,mue,1);

figure (3)

subplot(2,2,1)
plot(x1,y1,x3,y3,':r')
axis ([-10 10 -5 5],'square')
title('Messwert 1')

subplot(2,2,2)
plot(x2,y2,'g',x3,y3,':r')
axis ([-10 10 -5 5],'square')
title('Messwert 2')

subplot(2,2,[3,4])
plot(x1,y1,x2,y2,'g',x3,y3,':r')
axis ([-10 10 -5 5],'square')
title('Fussion')

%% Aufgabe 4
clc; clear;

T_AX=se2(0,0,-pi/6);
T_XO=se2(-1,-2,0);
T_AO=T_AX*T_XO;
T_OA=T_AO^-1;

C_A=[(0.1^2) 0;0 (0.05^2)];
mue_A=[1;0];
[x_A,y_A]=sig_elipse(C_A,mue_A,1);

p_A=[x_A;y_A;ones(1,length(x_A))];

p_O=zeros(3,length(p_A));
for i=1:length(p_A)
    p_O(:,i)=T_OA*p_A(:,i);
end

mue_B=T_OA*[mue_A ; 1];
mue_Bx=[1,mue_B(1)];
mue_By=[2,mue_B(2)];

figure(4)
plot(p_O(1,:),p_O(2,:),mue_Bx,mue_By,'-g',1,2,'*r', 'MarkerSize',12)
axis ([0 3 0 3],'square')

%% Aufgabe 5
clear; clc;

syms x_r y_r x_or y_or teta real

g1=cos(teta)*x_r-sin(teta)*y_r+x_or;
g2=sin(teta)*x_r+cos(teta)*y_r+y_or;

G=jacobian([g1;g2],[x_r y_r x_or y_or teta])

G_calc=double(subs(G,{x_r,y_r,x_or,y_or,teta},{1,0,1,2,pi/6}))
g1_calc=double(subs(g1,{x_r,y_r,x_or,teta},{1,0,1,pi/6}));
g2_calc=double(subs(g2,{x_r,y_r,y_or,teta},{1,0,2,pi/6}));

mue_O=[g1_calc;g2_calc];

C_Z=[(0.1^2) 0;0 (0.05^2)];
C_X=[0.025 -0.015 0; -0.015 0.025 0; 0 0 (0.0436^2)];
C_R=zeros(5,5);
C_R(1:2,1:2)=C_Z;
C_R(3:5,3:5)=C_X;
C_O=G_calc*C_R*G_calc';

[x1,y1]=sig_elipse(C_O,mue_O,1);

%--------------------------------------------
T_AX=se2(0,0,-pi/6);
T_XO=se2(-1,-2,0);
T_AO=T_AX*T_XO;
T_OA=T_AO^-1;

C_A=[(0.1^2) 0;0 (0.05^2)];
mue_A=[1;0];
[x_A,y_A]=sig_elipse(C_A,mue_A,1);

p_A=[x_A;y_A;ones(1,length(x_A))];

p_O=zeros(3,length(p_A));
for i=1:length(p_A)
    p_O(:,i)=T_OA*p_A(:,i);
end

mue_B=T_OA*[mue_A ; 1];
mue_Bx=[1,mue_B(1)];
mue_By=[2,mue_B(2)];

%-----------------------------------------------
mue_X=[1;2];
C_X2=[0.025 -0.015; -0.015 0.025];
[x3,y3]=sig_elipse(C_X2,mue_X,1);

figure (5)
plot(x1,y1,p_O(1,:),p_O(2,:),'g',x3,y3,':r',mue_Bx,mue_By,'-g',1,2,'*r', 'MarkerSize',12)
axis ([0 2.5 0 3],'square')











