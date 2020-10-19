function [x,y, linenames] = pgf_getXY(arguments, filename)

isname =[];


i = 1;
j = 1;
while i <= length(arguments)-1
    if ~isnumeric(arguments{i}) || ~isnumeric(arguments{i+1})
        error('Usage...');
    end
    
    % Vektoren zu Spaltenvektoren machen
    X = arguments{i};
    Y = arguments{i+1};
    if size(X,1) < size(X,2); X = X';  end
    if size(Y,1) < size(Y,2); Y = Y';  end

    if (length(X) ~= length(Y))
        error('Vectors must be of same length');
    end
    
    % Vektoren in cells speichern
    if size(X,2) == 1
        for k=1:size(Y,2)
            x{j+k-1} = X;
            y{j+k-1} = Y(:,k);
        end
    elseif size(X,2) == size(Y,2)
        for k=1:size(X,2)
            x{j+k-1} = X(:,k);
            y{j+k-1} = Y(:,k);
        end
    else
        error('"x" muss entweder nur einspaltig sein oder genauso viele Spalten haben, wie "y"');
    end

    if i<length(arguments)-1 && ischar(arguments{i+2}) % wenn es einen Namen gibt
        if size(Y,2) == 1
            isname(j) = 1;
            linenames{j} = arguments{i+2};
        else
            for k=1:size(Y,2)
                isname(j+k-1) = 1;
                linenames{j+k-1} = strcat(arguments{i+2},num2str(k));
            end
        end
        i = i + 3;
        j = j + size(Y,2);
    elseif i==length(arguments)-1 || isnumeric(arguments{i+2}) % wenn es keinen Namen gibt
        evalstr = strcat('inputname(',num2str(i+1),');');
        name    = evalin('caller',evalstr);
        if isempty(name) % wenn auch die Variable keinen Namen hatte
            for k=1:size(Y,2)
                isname(j+k-1) = 0;
                linenames{j+k-1} = '';
            end
        else
            if size(Y,2) == 1
                linenames{j} = name;
                isname(j) = 1;
            else
                for k=1:size(Y,2)
                    isname(j+k-1) = 1;
                    linenames{j+k-1} = strcat(name,'_',num2str(k));
                end
            end
        end
        i = i + 2;
        j = j + size(Y,2);
    else
        error('Usage...');
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
    
end

