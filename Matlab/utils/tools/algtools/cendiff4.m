function [X,dX] = cendiff4(X,dt)

%% Compute derivatives (4th order central difference)
[m,n] = size(X);

dX = zeros(n-5,m); 

for i = 1:m 
    for j = 3:n-3 
        dX(i,j-2) = 1/(12*dt)*(-X(i,j+2) + 8*X(i,j+1) - 8*X(i,j-1) + X(i,j-2));
    end
end

%% Trim first and last two rows that are lost in derivative
X = X(3:end-3,:);

end