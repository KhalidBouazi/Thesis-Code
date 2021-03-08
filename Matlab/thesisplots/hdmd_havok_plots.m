
close all;

hdmd = hdmdresult;
havok = havok__result;
delays = [1,2,3,4];
rrmsehdmd = cell(1,length(hdmd)/length(delays));
rrmsehavok = cell(1,length(havok)/length(delays));
eigshdmd = cell(1,length(hdmd)/length(delays));
eigshavok = cell(1,length(havok)/length(delays));
legends = {{'HDMD $x_1$','HAVOK $x_1$'},{'HDMD $x_2$','HAVOK $x_2$'},{'HDMD $x_1$','HAVOK $x_1$','HDMD $x_2$','HAVOK $x_2$'}};
markers = {{'-o'},{'-^'},{'-o','-^'}};
eigmarkers = {'o','^'};

%% results
for i = 1:length(hdmd)
    if mod(i,3) == 0
        k = 3;
    else
        k = mod(i,3);
    end
    rrmsehdmd{k} = [rrmsehdmd{k} hdmd{i}.RMSEYp];
end
for i = 1:length(havok)
    if mod(i,3) == 0
        k = 3;
    else
        k = mod(i,3);
    end
    rrmsehavok{k} = [rrmsehavok{k} havok{i}.RMSEVp];
end

%% plot rrmse against delays
for k = 1:length(legends)
    figure;
    set(gca,'yscale','log')
    hold on;
    for j = 1:rows(rrmsehdmd{k})
        h = semilogy(delays,rrmsehdmd{k}(j,:),markers{k}{j});
        set(h, 'MarkerFaceColor', get(h,'Color')); 
        h = semilogy(delays,rrmsehavok{k}(j,:),markers{k}{j});
        set(h, 'MarkerFaceColor', get(h,'Color')); 
    end
    ylim([1e-18,10]);
    xlim([min(delays),max(delays)]);
    xlabel('$d$');
    if k == 1
        ylabel('RRMSE');
    end
    legend(legends{k});
    box on;
    grid on;
%     cleanfigure;
%     matlab2tikz(['C:\Users\bouaz\Desktop\Thesis\pics\4_' hdmd{end}.system '_rrmse_hdmd_havok' num2str(k) '.tikz']);
end

% cleanfigure;
% matlab2tikz(['C:\Users\bouaz\Desktop\Thesis\pics\4_' hdmd{end}.system '_rrmse_hdmd_havok.tikz']);

%% plot eigenvalues
eigshdmd{1} = hdmd{1}.omega;
eigshavok{1} = havok{4}.omega;
eigshdmd{2} = hdmd{5}.omega;
eigshavok{2} = havok{8}.omega;
eigshdmd{3} = hdmd{6}.omega;
eigshavok{3} = havok{9}.omega;
figure;
for k = 1:length(legends)
    subplot(1,3,k);
    title('y=x');
    hold on;
    scatter([-1 -0.2 -0.1],[0 0 0],'x');
    scatter(real(eigshdmd{k}),imag(eigshdmd{k}),eigmarkers{1});
    scatter(real(eigshavok{k}),imag(eigshavok{k}),eigmarkers{2});
    ylim([-1 1]);
    xlim([-1 0]);
    xlabel('$\mathrm{Re}\,\omega$');
    if k == 1
        ylabel('$\mathrm{Im}\,\omega$');
    end
    legend(legends{k});
    box on;
    grid on;
%     cleanfigure;
%     matlab2tikz(['C:\Users\bouaz\Desktop\Thesis\pics\4_' hdmd{end}.system '_eigs_hdmd_havok' num2str(k) '.tikz']);
end








