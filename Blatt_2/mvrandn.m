function r = mvrandn(mu,C,n)
% r = mvrandn(mu,C,n)
%
% Die Funtion generiert Zufallsvariablen nach einer
% mehrdimensionalen Normalverteilung.
%
% mu:   Vektor mit Mittelwerten
% C:    Kovarianzmatrix
% n:    Anzahl der Spalten von r 
x_sch=randn(2,n);

[V,D]=eig(C);

x=zeros(2,n);

for i=1:n
    x(:,i)=V*sqrt(D)*x_sch(:,i)+mu;
end

r=x;