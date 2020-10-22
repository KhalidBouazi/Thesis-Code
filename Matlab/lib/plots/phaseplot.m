function phaseplot(result)

%% Check obligatory and optional function arguments
oblgfunargs = {'X'};
optfunargs = {};
optargvals = {};
result = checkandfillfunargs(result,oblgfunargs,optfunargs,optargvals);
    
%% Check state dimension
X = result.X;
m = size(X,1);

if m < 2 || m > 3
    error('State dimension: Must be 2 or 3.');
end

%% Start plotting
if m == 2
    plot(X(1,:),X(2,:));
elseif m == 3
    plot3(X(1,:),X(2,:),X(3,:));
    zlabel('$x_3$');
end
xlabel('$x_1$');
ylabel('$x_2$');

end



