function [x,y,z, linenames] = pgf_getXYZ(arguments, filename)

isname =[];


i = 1;
j = 1;
while i <= length(arguments)-2
    if ~isnumeric(arguments{i}) || ~isnumeric(arguments{i+1}) || ~isnumeric(arguments{i+2})
        error('Usage');
    end
    
    % Vektoren zu Spaltenvektoren machen
    X = arguments{i};
    Y = arguments{i+1};
    Z = arguments{i+2};
    if size(X,1) < size(X,2); X = X';  end
    if size(Y,1) < size(Y,2); Y = Y';  end
    if size(Z,1) < size(Z,2); Z = Z';  end

    if (length(X) ~= length(Y)) || (length(X) ~= length(Z))
        error('Vectors must be of same length');
    end
    
    % Vektoren in cells speichern
    if size(X,2) == 1
        if size(Y,2) ~= size(Z,2)
            error('Usage');
        end
        for k=1:size(Y,2)
            x{j+k-1} = X;
            y{j+k-1} = Y(:,k);
            z{j+k-1} = Z(:,k);
        end
    elseif (size(X,2) == size(Y,2)) && (size(X,2) == size(Z,2))
        for k=1:size(X,2)
            x{j+k-1} = X(:,k);
            y{j+k-1} = Y(:,k);
            z{j+k-1} = Z(:,k);
        end
    else
        error('Usage');
    end

    if i<length(arguments)-2 && ischar(arguments{i+3}) % wenn es einen Namen gibt
        if size(Y,2) == 1
            isname(j) = 1;
            linenames{j} = arguments{i+3};
        else
            for k=1:size(Y,2)
                linenames{j+k-1} = strcat(arguments{i+3},num2str(k));
                isname(j+k-1) = 1;
            end
        end
        i = i + 4;
        j = j + size(Y,2);
    elseif i==length(arguments)-2 || isnumeric(arguments{i+3})
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
        i = i + 3;
        j = j + size(Y,2);
    else
        error('Usage');
    end
end        

%% Linenames vergeben, für die Üfkt's die keinen eigenen haben
k = 1;
for i=1:length(isname)
    if ~isname(i)
        if length(isname)-sum(isname) == 1 % wenn nur ein linename fehlt
            linenames{i} = filename;
        else
            linenames{i} = strcat(filename,num2str(k));
            k = k+1;
        end
    end
end
    
end