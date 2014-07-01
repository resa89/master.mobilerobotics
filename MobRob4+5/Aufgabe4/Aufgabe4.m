clc; clear; close all;
ones(10)*ones(10);
% Parameter definitions
t = 30; % simulated time
Tmess = 1/10; % measurement interval
Tstate = 1/100; % state update interval

l = [2 4; 8 8]'

sAbweichV = 10;
sAbweichOmega = 320/180*pi;

uRefV = 5;
uRefw = 0/180*pi;

uRefVdev = 2;
uRefwdev = 45/180*pi;

% Variable initialisation
Nmess = floor(t/Tmess);
Nstate = floor(t/Tstate);

xRef = zeros(3, Nstate);
uRef = [10 0.2]';
uRausch = [0 0]'

xMess = zeros(3, Nstate);
xOdom = zeros(3, Nstate);
uMess = zeros(2, Nstate);
zMess = zeros(2, Nmess);

sigma{1} = ones(3)*1e9*0;

sigma_u = zeros(2);
sigma_u(1,1) = sAbweichV^2;
sigma_u(2,2) = sAbweichOmega^2;

Gx = zeros(3,3);
Gu = zeros(3,2);

x(:, 1) = [0 0 0]';

% Simulation
figure(1)
hold on;
kMess = 1;
for k = 1:Nstate
    % control vector
    uRausch = 0.9*uRausch + 0.1*[randn(1)*sAbweichV randn(1)*sAbweichOmega]';
    uMess(:,k) = uRef + uRausch;
    
    % prediction
    bMess = [Tstate*cos(xMess(3,k)) 0; Tstate*sin(xMess(3,k)) 0; 0 Tstate];
    bRef = [Tstate*cos(xRef(3,k)) 0; Tstate*sin(xRef(3,k)) 0; 0 Tstate];
    xRef(:,k+1) = xRef(:,k)+bRef*uRef;
    xMess(:,k+1) = xMess(:,k)+bMess*uMess(:,k);
    xOdom(:,k+1) = xOdom(:,k)+bMess*uMess(:,k);
    
    % normalisation
    xRef(3,k+1) = mod(xRef(3,k+1), 2*pi);
    xMess(3,k+1) = mod(xMess(3,k+1), 2*pi);
    xOdom(3,k+1) = mod(xOdom(3,k+1), 2*pi);
    
    Gx(1,:) = [1 0 -Tstate*uMess(1,k)*sin(xMess(3,k+1))];
    Gx(2,:) = [0 1  Tstate*uMess(1,k)*cos(xMess(3,k+1))];
    Gx(3,:) = [0 0  1];
    
    Gu(1,:) = [Tstate*cos(xMess(3,k+1)) 0];
    Gu(2,:) = [Tstate*sin(xMess(3,k+1)) 0];
    Gu(3,:) = [0 Tstate];
    
    sigma{k+1} = Gx*sigma{k}*Gx'+Gu*sigma_u*Gu';
    
    if mod(k,Tmess/Tstate) == 0
        % calculation of measurement vector (with errors)
        d1 = norm(xRef(1:2,k+1) - l(:,1));
        d2 = norm(xRef(1:2,k+1) - l(:,2));
        zMess(:,k+1) = [d1+randn(1)*sqrt(0.01*d1) d2+randn(1)*sqrt(0.01*d2)]';
        sigma_z = [0.01*d1 0; 0 0.01*d2];
        
        % Expected measurement vector
        d1Hat = norm(xMess(1:2,k+1) - l(:,1));
        d2Hat = norm(xMess(1:2,k+1) - l(:,2));
        zHat = [d1Hat d2Hat]';
        
        % Measurement equation
        l1x = l(1,1); l1y = l(2,1);
        l2x = l(1,2); l2y = l(2,2);
        x = xMess(1,k+1); y = xMess(2,k+1);
        H(1,:) = [-(2*l1x - 2*x)/(2*((l1x - x)^2 + (l1y - y)^2)^(1/2)), -(2*l1y - 2*y)/(2*((l1x - x)^2 + (l1y - y)^2)^(1/2)), 0];
        H(2,:) = [ -(2*l2x - 2*x)/(2*((l2x - x)^2 + (l2y - y)^2)^(1/2)), -(2*l2y - 2*y)/(2*((l2x - x)^2 + (l2y - y)^2)^(1/2)), 0];
        
        % Kalman Gain
        K = sigma{k+1}*H'/(H*sigma{k+1}*H'+sigma_z);
        
        % State correction
        xMess(:,k+1) = xMess(:,k+1) + K*(zMess(:,k+1) - zHat);
        
        % Sigma correcrion
        sigma{k+1} = (eye(3) - K*H)*sigma{k+1};
    end
    
    
    % random reference control vectors
    if mod(k,400) == 0
        %uRef = [randn(1) * uRefVdev + uRefV; randn(1)*uRefwdev + uRefw];
    end
    
    % visualisation of sigma ellipses
    if mod(k,100) == 0
        ellipse = sigEllipse(xMess(1:2,k+1), sigma{k+1}(1:2, 1:2), 1);
        plot(ellipse(1,:),ellipse(2,:), 'r');
    end
end

plot(xRef(1,:), xRef(2,:),'b'); 

plot(xMess(1,:), xMess(2,:),'y:'); 
plot(xOdom(1,:), xOdom(2,:),'g'); 

axis equal;