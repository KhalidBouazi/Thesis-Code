function test_phasebasis(X,V)

pov = [-6,13];
X = X(:,1:cols(V));

for j = 1:4
    subtightplot(2,2,j,[0.15 0.1],[0.12 0.07],[0.1 0.05]);
    title(['$u_' num2str(j) '$']);
    surface([X(1,:);X(1,:)],[X(2,:);X(2,:)],[X(3,:);X(3,:)],[V(j,:);V(j,:)],...
        'facecol','no',...
        'edgecol','interp',...
        'linew',2);
    colormap('jet');
    set(gca,'xtick',[],'ytick',[],'ztick',[]);
    colorbar;
    view(pov);
    xlabel('$x_1$');
    ylabel('$x_2$');
    zlabel('$x_3$');
end


end