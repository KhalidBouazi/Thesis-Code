function delayphaseplot(result)

%% Check obligatory and optional function arguments
oblgfunargs = {'V'};
optfunargs = {};
optargvals = {};
result = checkandfillfunargs(result,oblgfunargs,optfunargs,optargvals);

%% Check delay coordinate dimension
V = result.V;
n = size(V,2);

if n < 2
    error('State dimension: Must be minimum 2.');
end

%% Start plotting
if n == 2
    plot(V(:,1),V(:,2));
elseif n > 2
    plot3(V(:,1),V(:,2),V(:,3));
    zlabel('$v_3$');
end
xlabel('$v_1$');
ylabel('$v_2$');
    
end
