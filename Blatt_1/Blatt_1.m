%%
clear; clc;

% Aufgabe 1
%--------------------------------------------------------------------------

disp('Aufgabenteil 1a')
T_AB=se2(-2,0,pi)
T_BC=se2(-4,-1,-pi/2)
T_AC=se2(2,1,pi/2)

disp('Aufgabenteil 1b')
T_AC2=T_AB*T_BC

disp('Aufgabenteil 1c')
T_CA=se2(-1,2,-pi/2)
T_CA2=T_AC^-1


if (isequal(round(T_AC),round(T_AC2))==1)
    disp('super cool')
    disp(' ')
end

disp('Aufgabenteil 1d')
p_B=[-3;1;1];
p_A=T_AB*p_B

disp('Aufgabenteil 1e')
p_C=T_CA*p_A

%% Aufgabe 2
%--------------------------------------------------------------------------

disp('Aufgabenteil 2a')
T_OA=se2(1,1,0)
T_OB=se2(3,2,pi/6)

a=0;
if a
figure(1)
hold on
trplot2(T_OA,'frame', 'A', 'color','bl')
trplot2(T_OB,'frame', 'B','color','gr')
axis([0 5 0 5])
hold off
end

disp('Aufgabenteil 2b')
p_B=[1;1;1];
p_O=T_OB*p_B

disp('Aufgabenteil 2c')
disp('Grafisch ermittelt:')
T_AB=se2(2,1,pi/6)
disp('Berechnet:')
T_AO=T_OA^-1
T_AB2=T_AO*T_OB

disp('Aufgabenteil 2d')
p_A=T_AB*p_B

disp('Aufgabenteil 2e')
q_A=T_AB*p_A
disp('Der Punkt p_A wird im Koordinatensystem A mit dem Koordinatensystem B transformiert')

%% Aufgabe 3
%--------------------------------------------------------------------------

disp('Aufgabenteil 3a')

% trans3d(x,y,z,alpha,betta,gamma)
T_A1A2=trans3d_func(0.5,0,0,0,30,0)
T_RA1=trans3d_func(0.3,0,0.2,0,-20,10)
T_OR=trans3d_func(2,1,0.1,0,0,30)

p_A2=[0.5;0;0;1]
p_O=T_OR*T_RA1*T_A1A2*p_A2






