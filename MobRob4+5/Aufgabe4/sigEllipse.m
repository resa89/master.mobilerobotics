function [ ellipse ] = sigEllipse( x, sigma, n )
    % Punktmenge Einheitskreis
    angle = 0:0.01:2*pi;
    
    %s1 = V*ellipse
    ellipse = zeros(2,length(angle));
    
    if rank(sigma) < 2
        disp('sigma not invertable')
        return
    end
    [V, Lamda] = eig(inv(sigma));

    % Kreis + dehnen und quetschen
    tmpEllipse = [1/sqrt(Lamda(1,1))*cos(angle); 1/sqrt(Lamda(2,2))*sin(angle)];

    for i = 1:length(ellipse)
        ellipse(:, i) = V*tmpEllipse(:,i)*n + x;
    end
end