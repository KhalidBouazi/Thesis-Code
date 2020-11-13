function phaseplot(result,args)

%% Extract arguments
X = result.(args{1});
x = args{2};

%%
if strcmp(args{1},'V') && size(result.X,1) <= size(result.V,2)
    X = result.V(:,1:size(result.X,1))';
elseif strcmp(args{1},'V') && size(result.X,1) > size(result.V,2)
    return;
end

%% Check state dimension
m = size(X,1);

if m < 2 || m > 3
    error('State dimension: Must be 2 or 3.');
end

%% Start plotting
if m == 2
    plot(X(1,:),X(2,:));
elseif m == 3
    plot3(X(1,:),X(2,:),X(3,:));
    zlabel(['$' x '_3$']);
end
xlabel(['$' x '_1$']);
ylabel(['$' x '_2$']);

end



