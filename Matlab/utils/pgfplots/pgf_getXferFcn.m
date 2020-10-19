function [G, linenames, w] = pgf_getXferFcn(arguments, filename)

w = [];
if iscell(arguments{end}) && length(arguments{end})==2
    w = arguments{end};
    arguments = arguments(1:end-1);
elseif isnumeric(arguments{end}) && (length(arguments{end})==1)
    w = arguments{end};
    arguments = arguments(1:end-1);
end

i = 1;
j = 1;
while i <= length(arguments)
    if isobject(arguments{i}) % wenn Üfkt
        for k=1:length(arguments{i})
            G{j+k-1} = arguments{i}(k);
        end
        if i<length(arguments) && ischar(arguments{i+1}) % wenns einen Namen gibt 
            for k=1:length(arguments{i})
                isname(j+k-1) = 1;
                if length(arguments{i}) == 1 % wenn nur eine Üfkt
                    linenames{j+k-1} = arguments{i+1};
                else
                    linenames{j+k-1} = strcat(arguments{i+1},num2str(k));
                end
            end
            j = j+length(arguments{i});
            i = i+2;
        elseif i==length(arguments) || isobject(arguments{i+1}) % wenns keinen Namen gibt
            evalstr = strcat('inputname(',num2str(i),');');
            name    = evalin('caller',evalstr);
            if isempty(name) % wenn auch die Variable keinen Namen hatte
                for k=1:length(arguments{i})
                    isname(j+k-1) = 0;
                    linenames{j+k-1} = '';
                end
            else
                if length(arguments{i}) == 1
                    isname(j) = 1;
                    linenames{j} = name;
                else
                    for k=1:length(arguments{i})
                        isname(j+k-1) = 1;
                        linenames{j+k-1} = strcat(name,'_',num2str(k));
                    end
                end
            end
            j = j+length(arguments{i});
            i = i+1;
        else
            error('ErrorTests:convertTest','Usage: pgfbodeDB(G1,[name],[G2, [name], ...], [w], filename, folder)\n or\nUsage: pgfbodeDB(mag, phase, freq, [name], filename, folder)');
        end
    else
        error('ErrorTests:convertTest','Usage: pgfbodeDB(G1,[name],[G2, [name], ...], [w], filename, folder)\n or\nUsage: pgfbodeDB(mag, phase, freq, [name], filename, folder)');
    end
end

%% Linenames vergeben, für die Üfkt's die keinen eigenen haben
k = 1;
for i=1:length(isname)
    if ~isname(i)
        if length(isname)-sum(isname) == 1 % wenn nur ein linename fehlt
            linenames{i} = filename;
        else
            linenames{i} = strcat(filename,'_',num2str(k));
            k = k+1;
        end
    end
end

%% w-Vektor erstellen
if isempty(w)
    [~,~, freq] = bode(G{1});
    wmin = min(freq);
    wmax = max(freq);
    for i=2:length(G)
        [~,~, freq] = bode(G{i});
        wmin = min(wmin, min(freq));
        wmax = max(wmax, max(freq));
    end
    w = {wmin, wmax};
end

end