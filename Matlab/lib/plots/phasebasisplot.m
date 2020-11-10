function phasebasisplot(result)

%% Check obligatory and optional function arguments
oblgfunargs = {'X','V'};
optfunargs = {};
optargvals = {};
result = checkandfillfunargs(result,oblgfunargs,optfunargs,optargvals);

%% Check state dimension
X = result.X;
m = size(X,1);

if m < 2 || m > 3
    error('State dimension: Must be 2 or 3.');
end

V = result.V;
X = X(:,1:size(V,1));

%% Start plotting
if m == 2
    Z = zeros(size(X(1,:)));
    pov = [0,90];
else
    Z = X(3,:);
    pov = [-6,13];
end

if size(V,2) >= 4
    num = 4;
else
    num = size(V,2); 
end

for j = 1:num
    subtightplot(2,2,j,[0.1 0.1],[0.07 0.07],[0.1 0.05]);
    title(['$u_' num2str(j) '$']);
    surface([X(1,:);X(1,:)],[X(2,:);X(2,:)],[Z;Z],[V(:,j)';V(:,j)'],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
    colormap('jet');
    set(gca,'xtick',[],'ytick',[],'ztick',[]);
    colorbar;
    view(pov);
    xlabel('$x_1$');
    ylabel('$x_2$');

    if m == 3
        zlabel('$x_3$');
    end
end
    
end



