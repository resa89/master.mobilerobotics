clc; clear; close all;

% Parameter definitions
t = 100; % simulated time
T = 0.1; % Zeitkonstante
M = 100; % Partikelanzahl

N = floor(t/T);
xRef = zeros(3,N+1);

l = [2 80
     4 80];

uRefV = 2;
uRefw = 2/180*pi;

uRefVdev = 0.4;
uRefwdev = 5/180*pi;

xRef(:,1) = [0 0 0];
uRef = [2 5/180*pi];

partikel = zeros(3,M);
pool = zeros(3,M);
w = zeros(1,M);

for m=1:M
    partikel(1:2,m) = randn(2,1) * 5 + [-2 -4]';
%     partikel(3,m) = rand * 2*pi;
end

partikelPath = zeros(2,N);
z = zeros(length(l),1);

figure
hold on

for n=1:N
    partikelMean = [mean(partikel(1,:)); mean(partikel(2,:))];
    partikelPath(:,n) = partikelMean;
    if mod(n-1,50) == 0 || n==N
        scatter(partikel(1,:), partikel(2,:),5,'r');
        
        partikelMean = [mean(partikel(1,:)); mean(partikel(2,:))];
    
        cov = zeros(2);
        for m = 1:M
            e = partikel(1:2,m) - partikelMean;
            cov = cov + e*e';
        end
        cov = cov/M;

        ellipse = sigEllipse(partikelMean, cov, 1);
        plot(ellipse(1,:),ellipse(2,:));
    end
    
    if mod(n,20) == 0
        uRef(1) = randn * uRefVdev + uRefV;
        uRef(2) = randn * uRefwdev + uRefw;
    end
    
    % State propagation
    [xRef(1,n+1), xRef(2,n+1), xRef(3,n+1)] = sampleMotionModel(xRef(1,n), xRef(2,n), xRef(3,n), uRef(1), uRef(2), T);
    % Measurement
    for i=1:length(l)
        z(i) = norm(xRef(1:2,n+1)-l(:,i));
    end
    
    % Partikel propagation
    for m = 1:M
        [pool(1,m), pool(2,m), pool(3,m)] = sampleMotionModel(partikel(1,m), partikel(2,m), partikel(3,m), uRef(1), uRef(2), T);
        w(m) = measurementModel(z, pool(1,m), pool(2,m), l');
        if m~=1
            w(m) = w(m-1) + w(m);
        end
    end
    
    % Resampling
    for m = 1:M
        r = rand * w(M);
        i = find(w>r,1);
        partikel(:,m) = pool(:,i);
    end
end

plot(xRef(1,:), xRef(2,:));
plot(partikelPath(1,:), partikelPath(2,:),'g');
axis equal
scatter(l(1,:), l(2,:),'MarkerEdgeColor',[0 0.5 0],'MarkerFaceColor',[0 0.5 0]); 
