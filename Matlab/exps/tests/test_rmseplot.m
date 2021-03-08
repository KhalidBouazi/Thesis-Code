% rmse, delays, rank
res = {hdmdresult{4:4:end}};
% res = {hdmdcresult{5:5:end}};
% res = havok__result;
% res = havok___result;
havok = 0;
cha = '5_';
alg = res{1}.algorithm;
forrank = 0;
name = 'ttank';

meas = {};
algres = {};

for i = 1:length(res)
    exists = false;
    for j = 1:length(meas)
        if length(meas{j}) == length(res{i}.measured)
            if all(meas{j} == res{i}.measured)
                exists = true; 
            end
        end
    end
    if ~exists
        meas{end+1} = res{i}.measured; 
    end
end

%%
delays = {};
rmseYr = {};
rmseYp = {};
rank = {};
omega = {};
for i = 1:length(meas)
    idx = 0;
    d = [];
    R = [];
    Rp = [];
    r = [];
    o = {};
    for j = 1:length(res)
        if length(meas{i}) == length(res{j}.measured) & meas{i} == res{j}.measured
            d = [d res{j}.delays];
            if havok
                R = [R res{j}.RMSEV];
                Rp = [Rp res{j}.RMSEVp];            
            else
                R = [R res{j}.RMSEY];
                Rp = [Rp res{j}.RMSEYp];    
            end
            
            r = [r res{j}.rank];
            o = [o {res{j}.omega}];
        end
    end
    delays{i} = d;
    RMSEY{i} = R;
    RMSEYp{i} = Rp;
    rank{i} = r;
    omega{i} = o;
end

%% rmse, delays, rank
if ~forrank
    figure;
    for i = 1:length(meas)
        nmeas = length(meas{i});
        subplot(2,length(meas),i);
        for j = 1:nmeas
            semilogy(delays{i},RMSEY{i}(j,:));
            hold on;
            if j == nmeas
                yyaxis right;
                plot(delays{i},rank{i});
            end
        end
        subplot(2,length(meas),length(meas)+i);
        for j = 1:nmeas
            semilogy(delays{i},RMSEYp{i}(j,:));
            hold on;
            if j == nmeas
                yyaxis right;
                plot(delays{i},rank{i});
            end
        end
    end
end

%% rmse, rank
if forrank
    figure;
    for i = 1:length(meas)
        nmeas = length(meas{i});
        subplot(2,length(meas),i);
        for j = 1:nmeas
            semilogy(rank{i},RMSEY{i}(j,:));
            hold on;
        end
        subplot(2,length(meas),length(meas)+i);
        for j = 1:nmeas
            semilogy(rank{i},RMSEYp{i}(j,:));
            hold on;
        end
    end
end

%% Eigenwerte
% eigfromback = 2;
eigfromstart = [1,1,1,1,1,2];
figure;
markers = {'x','o','*','^','v','s'};
colors = {'green','red','blue','magenta','black','cyan'};
for i = 1:length(meas)
%     subplot(2,length(meas),i);
    scatter(real(omega{i}{eigfromstart(i)}),imag(omega{i}{eigfromstart(i)}),markers{i}',colors{i});
    hold on;
end
ylim([-1,1]);

% cleanfigure;
% matlab2tikz('C:\Users\bouaz\Desktop\Thesis\pics\myfile.tikz');

%%

if ~forrank
    for i = 1:length(meas)
        if ~havok
        % eigs
%             pgfplot(real(omega{i}{end-eigfromback}),imag(omega{i}{end-eigfromback}),'1',...
%             [cha name '_eigsfull' num2str(i)],'C:\Users\bouaz\Desktop\Thesis\pics');
%             rmse
            if length(meas{i}) == 2
                pgfplot(delays{i},RMSEYp{i}(1,:),'1',...
                delays{i},RMSEYp{i}(2,:),'2',...
                [cha name '_rmsedelay' num2str(i)],'C:\Users\bouaz\Desktop\Thesis\pics');

            else
                pgfplot(delays{i},RMSEYp{i},'1',...
                [cha name '_rmsedelay' num2str(i)],'C:\Users\bouaz\Desktop\Thesis\pics');
            end
        else
            folder = ['C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\' cha name '_rmsedelay_' alg num2str(i)];
            mkdir(folder);
            if length(meas{i}) == 3
                table = [delays{i}', RMSEYp{i}(1,:)'];
                save([folder '\1.txt'], 'table', '-ascii', '-double', '-tabs');
                table = [delays{i}', RMSEYp{i}(2,:)'];
                save([folder '\2.txt'], 'table', '-ascii', '-double', '-tabs');
                table = [delays{i}', RMSEYp{i}(3,:)'];
                save([folder '\3.txt'], 'table', '-ascii', '-double', '-tabs');
            elseif length(meas{i}) == 2
                table = [delays{i}', RMSEYp{i}(1,:)'];
                save([folder '\1.txt'], 'table', '-ascii', '-double', '-tabs');
                table = [delays{i}', RMSEYp{i}(2,:)'];
                save([folder '\2.txt'], 'table', '-ascii', '-double', '-tabs');
            else
                table = [delays{i}', RMSEYp{i}'];
                save([folder '\1.txt'], 'table', '-ascii', '-double', '-tabs');
            end
        end
    end
end

if forrank
    for i = 1:length(meas)
         % eigs
         if ~havok
            pgfplot(real(omega{i}{eigfromstart(i)}),imag(omega{i}{eigfromstart(i)}),'1',...
            [cha name '_eigs' num2str(i)],'C:\Users\bouaz\Desktop\Thesis\pics');
            % rank rmse
            if length(meas{i}) == 2
                pgfplot(rank{i},RMSEYp{i}(1,:),'1',...
                rank{i},RMSEYp{i}(2,:),'2',...            
                [cha name '_rankrmse' num2str(i)],'C:\Users\bouaz\Desktop\Thesis\pics');
            else
                pgfplot(rank{i},RMSEYp{i},'1',...
                [cha name '_rankrmse' num2str(i)],'C:\Users\bouaz\Desktop\Thesis\pics');        
            end
        else
            folder = ['C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\' cha name '_eigs_' alg num2str(i)];
            mkdir(folder);
            table = [real(omega{i}{eigfromstart(i)}), imag(omega{i}{eigfromstart(i)})];
            save([folder '\1.txt'], 'table', '-ascii', '-double', '-tabs');

            folder = ['C:\Users\bouaz\Desktop\Thesis\pics\TikZdata\' cha name '_rankrmse_' alg num2str(i)];
            mkdir(folder);
            if length(meas{i}) == 3
                table = [rank{i}', RMSEYp{i}(1,:)'];
                save([folder '\1.txt'], 'table', '-ascii', '-double', '-tabs');
                table = [rank{i}', RMSEYp{i}(2,:)'];
                save([folder '\2.txt'], 'table', '-ascii', '-double', '-tabs');
                table = [rank{i}', RMSEYp{i}(3,:)'];
                save([folder '\3.txt'], 'table', '-ascii', '-double', '-tabs');
            elseif length(meas{i}) == 2
                table = [rank{i}', RMSEYp{i}(1,:)'];
                save([folder '\1.txt'], 'table', '-ascii', '-double', '-tabs');
                table = [rank{i}', RMSEYp{i}(2,:)'];
                save([folder '\2.txt'], 'table', '-ascii', '-double', '-tabs');
            else
                table = [rank{i}', RMSEYp{i}'];
                save([folder '\1.txt'], 'table', '-ascii', '-double', '-tabs');
            end
         end
    end
end





