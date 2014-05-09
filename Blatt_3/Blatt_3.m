%% Blatt 3, Teil a-c
clc; clear;

% Fehlerfrei---------------------------------------------------------------
T=0.1;

%w=v/(r+R/2) %R=40cm, r=1m
v=2; %m/s
w=5/3; %rad/s

steps=floor((2*pi)/(T*w));

position=zeros(3,steps);
for k=1:1:steps
position(:,k+1)=position(:,k)+[(T*cos(position(3,k))*v); (T*sin(position(3,k))*v); (T*w)];
end

plot(position(1,:),position(2,:),'r')

% Fehlerbehaftete Steuerbefehle--------------------------------------------

v=2; %m/s
w=(5/3); %rad/s

steps=floor((2*pi)/(T*w));

position=zeros(3,steps);
v_var=zeros(1,steps);
w_var=zeros(1,steps);
position(:,1)=[.05;.01;0];%Init Position
for k=1:1:steps
v_var(k)=(v-0.5+rand);
w_var(k)=(w-0.5+rand);
position(:,k+1)=position(:,k)+[(T*cos(position(3,k))*v_var(k)); (T*sin(position(3,k))*v_var(k)); (T*w_var(k))];
end

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

C_old=[sig_x,0,0,0,0;
    0,sig_y,0,0,0;
    0,0,sig_tetta,0,0;
    0,0,0,sig_v,0;
    0,0,0,0,sig_w];

syms x y tetta v w

g=[x;y;tetta]+[(T*cos(tetta)*v); (T*sin(tetta)*v); (T*w)];
G=jacobian(g,[x y tetta v w]);

for k=2:1:steps+1

G_calc=double(subs(G,{x,y,tetta,v,w},{position(1,k),position(2,k),position(3,k),v_var(k-1),w_var(k-1)}));
C_new=G_calc*C_old*G_calc';

[x_paint,y_paint]=sig_elipse(C_new(1:2,1:2),[position(1,k),position(2,k)],1);

hold on
plot(x_paint,y_paint)

C_old=zeros(5,5);
C_old(1:3,1:3)=C_new;
C_old(4,4)=sig_v;
C_old(5,5)=sig_w;
end
