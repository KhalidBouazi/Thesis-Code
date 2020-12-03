function basisplot(result,args)

%% Extract arguments
U = result.(args{1});

%% Start plotting
if size(U,2) < 5
    l = 1:size(U,2);
else
    l = [1 round(linspace(2,size(U,2),4))];
end
n = length(l);

legendstr = {};
for i = 1:n
    legendstr = [legendstr, ['$\mathrm{u}_{' num2str(l(i)) '}$']];
    plot(U(:,l(i)));
    hold on;
end
ylabel('unbenannt');
xlabel('unbenannt');
legend(legendstr);

end