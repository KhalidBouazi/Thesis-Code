function phasebasisplot(X,V)

%% Check function arguments
if nargin < 2
    error('Arguments: Minimum number of arguments is 2.');
end

%% Check state dimension
m = size(X,1);

if m < 2 || m > 3
    error('State dimension: Must be 2 or 3.');
end

%% Start plotting
figure;

X = X(:,1:size(V,1));

if m == 2
    Z = zeros(size(X(1,:)));
    pov = [0,90];
else
    Z = X(3,:);
    pov = [-6,13];
end

for i = 1:6
    subplot(2,3,i);
    surface([X(1,:);X(1,:)],[X(2,:);X(2,:)],[Z;Z],[V(:,i)';V(:,i)'],...
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



