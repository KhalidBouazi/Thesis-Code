function [X,dX] = cendiff4(X,dt)

%% Compute derivatives (4th order central difference)
dX = zeros(length(X)-5,size(X,2));
for i=3:length(X)-3
    for k=1:size(X,2)
        dX(i-2,k) = (1/(12*dt))*(-X(i+2,k)+8*X(i+1,k)-8*X(i-1,k)+X(i-2,k));
    end
end  

% concatenate
X = X(3:end-3,:);

end