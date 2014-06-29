% sampleMotionModel.m
%
% function [x_new,y_new,theta_new] = sampleMotionModel(x_old, y_old, theta_old, v, omega, T)
%
% Aus Steuerbefehl [v, omega] 
% und alter Position [x_old, y_old, theta_old] 
% wird neue Position [x_new,y_new,theta_new] zufaellig generiert.
%
% O. Bittel
% 13.12.2013
%
function [x_new,y_new,theta_new] = sampleMotionModel(x_old,y_old,theta_old,v,omega,T)
    % Konstanten f�r Fehlermodell f�r Steuerdaten
    k_d = 0.5^2; % (0.05m)^2/m
    k_theta = (10^2/360)* (pi/180); % (5 Grad)^2/360 Grad
    k_drift = (2*pi/180)^2; % (2 Grad)^2/1m

    % Steuerbefehl verrauschen:
    sigma2_v = (k_d/T)*abs(v); 
    v_e = v + randn(1,1)*sqrt(sigma2_v);
    sigma2_omega = (k_theta/T)*abs(omega);
    omega_e = omega + randn(1,1)*sqrt(sigma2_omega); % Drehratenfehler
    sigma2_drift = (k_drift/T)*abs(v); 
    omega_e = omega_e + randn(1,1)*sqrt(sigma2_drift); % Driftfehler

    % Neuer Zustand:
    x_new = x_old + T*cos(theta_old)*v_e;
    y_new = y_old + T*sin(theta_old)*v_e;
    theta_new = normAngle(theta_old + T*omega_e);