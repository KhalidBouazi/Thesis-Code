function matrixplot(result,args)

%% Extract arguments
A = result.(args{1});

%% Start plotting
imagesc(A);
axis off;
colorbar;

end