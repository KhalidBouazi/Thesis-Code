% Usage: [num, sets, vectorlength, linenames] = pgffiles(X,Y,[Z],FilenameWithFolder)
% 
% num            = Anzahl an Vektoren, die geplottet werden (falls eine Matrix �bergeben wird)
% sets           = Anzahl an Dateien pro Vektor
% vectorlength   = Gesamtl�nge aller Dateien (pfgplots kann maximal 12'000 verarbeiten)
% linenames      = Namen der Dateien

function [num, sets, vectorlength, linenames] = pgffiles(x, y, varargin)
%% Korrektheit der Eingaben pr�fen
if nargin < 3 || nargin > 4
    error('Too many or too few input arguments');
end
index_slash = findstr(varargin{nargin-2},'\');
index_dot   = findstr(varargin{nargin-2},'.');
if ~isempty(index_dot)
    filename = varargin{nargin-2}(index_slash(end)+1:index_dot-1);
    filepath = varargin{nargin-2}(1:index_slash(end));
    filesuffix = varargin{nargin-2}(index_dot:end);
else
    filename = varargin{nargin-2}(index_slash(end)+1:end);
    filepath = varargin{nargin-2}(1:index_slash(end));
    filesuffix = '.txt';
end

if nargin == 4
    z = varargin{1};
    if ~isnumeric(z)
        error('Usage: [num, sets, vectorlength, linenames] = pgffiles(X,Y,FilenameWithFolder)');
    end
else
    z = [];
end

if ~isnumeric(x) || ~isnumeric(y)
	error('Usage: [num, sets, vectorlength, linenames] = pgffiles(X,Y,FilenameWithFolder)');
end

%% Vektoren, bzw. Matrizen ausrichten
if min(size(x))==1 && min(size(y))==1
    x = x(:);
    y = y(:);
elseif size(x,2) > size(x,1)
    x = x';
    if size(y,2) > size(y,1)
        y = y';
    end
    if ~isempty(z)  z = z';  end
end
if size(y,2) ~= size(x,2)
    if size(x,2) ~= 1
        error('wenn y eine Matrix ist, muss x entweder eine Matrix gleicher Gr��e oder ein Vektor sein')
    end
    for i=2:size(y,2)
        x(:,i) = x(:,1);
    end
end

if ~isempty(z)
    if size(z) ~= size(y)
        error('y und z m�ssen von gleicher Dimension sein!')
    end
end

if length(x) ~= length(y)
    error('x and y must be of same length');
end

if min(size(y)) > 1
    matrix = 1;
else
    matrix = 0;
end

%% Dateien schreiben
num = size(y,2);
sets = ceil(length(x)/2000);
filelength = ceil(length(x)/sets);
vectorlength = length(x)*num;

for i=1:num
    if matrix
        dataname = strcat(filename,num2str(i));
    else
        dataname = filename;
    end
    linenames{i} = dataname;
    
    if sets == 1    % wenn nur eine Datei pro Vektor
        fid = fopen(strcat(filepath,dataname,filesuffix),'w');
        for k=1:filelength
            if ~isempty(z)
%                 fprintf(pfid, '%g %g %g \r\n',x(k), y(k,i),z(k,i));
                fprintf(fid, '%d %d %d \r\n',x(k,i),y(k,i),z(k,i));
            else
%                 fprintf(pfid, '%g %g \r\n',x(k), y(k,i));
                fprintf(fid, '%d %d\r\n',x(k,i),y(k,i));
            end                
        end
        fclose(fid);  
    else    % wenn mehrere Dateien pro Vektor
        % erste Satz
        j = 1;
        fid = fopen(strcat(filepath,dataname,'-',num2str(j),filesuffix),'w');
        for k = 1 : filelength
            if ~isempty(z)
%                fprintf(pfid, '%g %g %g \r\n',x(k,i), y(k,i), z(k,i));
                fprintf(fid, '%d %d %d \r\n',x(k,i),y(k,i), z(k,i));
            else
%                fprintf(pfid, '%g %g \r\n',x(k,i), y(k,i));
                fprintf(fid, '%d %d \r\n',x(k,i),y(k,i));
            end
        end
        fclose(fid);
        % die mittleren S�tze
        for j = 2 : sets-1
            fid = fopen(strcat(filepath,dataname,'-',num2str(j),filesuffix),'w');
            for k = (j-1)*filelength : j*filelength
                if ~isempty(z)
%                    fprintf(pfid, '%g %g %g \r\n',x(k,i), y(k,i), z(k,i));
                    fprintf(fid, '%d %d %d \r\n',x(k,i),y(k,i), z(k,i));
                else
%                    fprintf(pfid, '%g %g \r\n',x(k,i), y(k,i));
                    fprintf(fid, '%d %d \r\n',x(k,i),y(k,i));
                end 
            end
            fclose(fid);
        end
        % letzter Satz
        j = sets;
        fid = fopen(strcat(filepath,dataname,'-',num2str(j),filesuffix),'w');
        for k = (j-1)*filelength : length(x)
            if ~isempty(z)
%                fprintf(pfid, '%g %g %g \r\n',x(k,i), y(k,i), z(k,i));
                fprintf(fid, '%d %d %d \r\n',x(k,i),y(k,i), z(k,i));
            else
%                fprintf(pfid, '%g %g \r\n',x(k,i), y(k,i));
                fprintf(fid, '%d %d \r\n',x(k,i),y(k,i));
            end 
        end
        fclose(fid);
    end
end

end