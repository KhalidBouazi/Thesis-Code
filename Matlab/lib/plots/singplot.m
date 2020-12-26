function singplot(result,args)

%% Extract arguments
sn = result.(args{1});
sn_ = result.(args{2});

%% Plot config
SingValColor = 'k';
SingValColor_ = [0.6350, 0.0780, 0.1840];
SingValMarker = 'o';

%% Start plotting
idx = sn > 1e-3;
if length(sn(idx)) < length(sn_)
    sn = sn(1:length(sn_));
else
    sn = sn(idx);
end

plot(1:length(sn),real(sn),'LineStyle','none','Marker',SingValMarker,'Color',SingValColor);
hold on;
plot(1:length(sn_),real(sn_),'LineStyle','none','Marker',SingValMarker,'Color',SingValColor_);
xlabel('Rang');
ylabel('Norm. Singulaerwert');
xlim([0 length(sn)+1])
ylim([0 1])
% grid on;
if length(sn) >= 10
    gap = round(length(sn)/10);
else
    gap = 1; 
end
xlabels = gap:gap:length(sn);
set(gca,'XTick',xlabels);

end