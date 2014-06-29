% Blatt 4
clc; clear; clear all;

% Fehlerfrei---------------------------------------------------------------
T=0.1;

%w=v/(r+R/2) %R=40cm, r=1m
v=2; %m/s
w=5/3; %rad/s
steps=floor((2*pi)/(T*w))+1;

position_r=zeros(3,steps); %Position
sens_r=zeros(4,steps);     %Senorwerte
sens_r(:,1)=[sqrt(20);atan2(4,2);sqrt(128);atan2(8,8)];
for k=1:1:steps
position_r(:,k+1)=position_r(:,k)+[(T*cos(position_r(3,k))*v); (T*sin(position_r(3,k))*v); (T*w)];
sens_r(:,k+1)=[(sqrt((position_r(1,k+1)-2)^2+(position_r(2,k+1)-4)^2));atan2((4-position_r(2,k+1)),(2-position_r(1,k+1)));
             (sqrt((position_r(1,k+1)-8)^2+(position_r(2,k+1)-8)^2));atan2((8-position_r(2,k+1)),(8-position_r(1,k+1)))];
end

plot(position_r(1,:),position_r(2,:),'r')

% Fehlerbehaftete Steuerbefehle--------------------------------------------

position=zeros(3,steps);
sens=zeros(4,steps);
v_var=zeros(1,steps);
v_var(1)=(v+0.5*randn(1,1));
w_var=zeros(1,steps);
w_var(1)=(w+0.5*randn(1,1));
position(:,1)=[0;0;0];%Init Position
sens(:,1)=[sqrt(20);atan2(4,2);sqrt(128);atan2(8,8)];
for k=1:1:steps
position(:,k+1)=position(:,k)+[(T*cos(position(3,k))*v_var(k)); (T*sin(position(3,k))*v_var(k)); (T*w_var(k))];
sens(:,k+1)=[(sqrt((position(1,k+1)-2)^2+(position(2,k+1)-4)^2));atan2((4-position(2,k+1)),(2-position(1,k+1)));
             (sqrt((position(1,k+1)-8)^2+(position(2,k+1)-8)^2));atan2((8-position(2,k+1)),(8-position(1,k+1)))];

v_var(k+1)=(v+0.05*randn(1,1));
w_var(k+1)=(w+0.05*randn(1,1));
end

%Plot
hold on
plot(position(1,:),position(2,:),':g')

% Elipsen------------------------------------------------------------------
% Fehler
k_d=((0.05^2)/1);
k_tetta=(0.0873^2)/(2*pi);
k_drift=(0.0349^2)/1;

sig_x= k_d*(T*cos(position(3,1))*v);
sig_y= k_d*(T*sin(position(3,1))*v);
sig_tetta=((k_tetta*w)/T)+((k_drift*v)/T);
sig_v=k_d*v/T;
sig_w=k_tetta*w/T;

C_k=[sig_x,  0,      0;
     0,      sig_y,  0;
     0,      0,      sig_tetta];
C_u=[sig_v,  0;
     0,      sig_w];
I=[1,0,0;0,1,0;0,0,1];

% syms x y tetta v w
% 
% g=[x;y;tetta]+[(T*cos(tetta)*v); (T*sin(tetta)*v); (T*w)];
% G=jacobian(g,[x y tetta v w])


% For "k+1"
for k=2:1:steps+1
% Kalman

%Jacobi
G_u=[cos(position(3,k))*T,  0;
     sin(position(3,k))*T,  0;
     0,                   T];
G_k=[1,  0,  -T*v_var(k)*sin(position(3,k));
     0,  1,  T*v_var(k)*cos(position(3,k));
     0,  0,  1];
C_k=(G_k*C_k*G_k')+(G_u*C_u*G_u');

x_s=position(1,k);
y_s=position(2,k);
r_l1=sqrt((x_s-2)^2+((y_s-4)^2));
r_l2=sqrt((x_s-8)^2+((y_s-8)^2));

H=[((x_s-2)/r_l1),     ((y_s-4)/r_l1),     0;
   (-(y_s-4)/(r_l1^2)) ((x_s-2)/(r_l1^2))  -1;
   ((x_s-8)/r_l2),     ((y_s-8)/r_l2),     0;
   (-(y_s-8)/(r_l2^2)) ((x_s-8)/(r_l2^2))  -1];

C_z=[0.01*sens(1,k),  0,               0,               0;
     0,               0.001*sens(2,k)  0,               0;
     0,               0,               0.01*sens(3,k),  0;
     0,               0,               0,               0.001*sens(4,k)];
 
K=C_k*H'*(H*C_k*H'+C_z)^(-1);
position(:,k)=position(:,k)+K*(sens_r(:,k)-sens(:,k));
C_k=(I-(K*H))*C_k;

% Plot
[x_paint,y_paint]=sig_elipse(C_k(1:2,1:2),[position(1,k),position(2,k)],1);
hold on
plot(x_paint,y_paint)

end
