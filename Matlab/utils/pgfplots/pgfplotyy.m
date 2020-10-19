% Usage: pgfplotyy(x1,y1,[name],x2,y2,[name], filename, folder)
%
% Die Funktionsweise von "pgfplotyy(.)" ist (fast) die gleiche, wie die
% von der Matlab-Funktion "plotyy(x1,y1,x2,y2)". 
% 
% Die Angabe von "filename" und "folder" sind zwingend notwendig.  Es wird 
% die Datei "filename" im Ordner "folder" erzeugt, die fertigen tikz-code 
% enthält, der direkt in LaTeX kompilierbar ist. Ausserdem wird ggf. der
% Ordner "folder\TikZData" erstellt, falls er noch nicht vorhanden ist und 
% dort die Dateien abgelegt, die die Daten enthalten.
% 
% x1, x2, y1 und y2 können Vektoren oder Matrizen sein. Die Angabe von 
% 'name' ist optional.
% 
% Die Datei "pgfplotyy(...)" kann bedenkenlos mehrmals ausgeführt werden, 
% ohne dass man Angst haben muss, seine in der "filename" gemachten Forma-
% tierungen zu verlieren, da die Datei, sobald sie einmal existiert, nicht
% überschrieben wird. Nur die Dateien mit den Daten werden überschrieben. 
% Dies hat natürlich auch den Nachteil, dass gegebenenfalls nicht mehr alle
% Datendateien korrekt in der tikz-Datei eingebunden sind, falls sich die 
% Länge der Vektoren bzw. Matrizen x und y ändert.Dies muss man dann per 
% Hand nachholen.
% 
% 
% Beispiele: 
%   x1 = linspace(0,2*pi);
%   x2 = linspace(0,4*pi);
%   y11 = sin(x1);
%   y12 = cos(x1);
%   y21 = cos(x2)+10;
%   y22 = sin(x2)+10;
%   
%   pgfplotyy(x1,y11,x2,y21,'myfile.tikz','d:\myfolder');
%   pgfplotyy(x1,y11,'Sinus',x2,y21,'Cosinus','myfile.tikz','d:\myfolder');
%   pgfplotyy(x1,[y11;y12],x2,[y21;y22],'myfile.tikz','d:\myfolder');
%   ...
function [] = pgfplotyy(varargin)
%% Überprüfen auf korrekte Eingabewerte
if nargin < 6 
    error('not enough input arguments');
end
if nargin > 8 
    error('too many input arguments');
end

% folder und filename abspalten
[arguments, filename, fileext, folder] = pgf_separation(varargin);

if ischar(arguments{3})
    [x1,y1,linenames1] = pgf_getXY(arguments(1:3), filename);
    if length(arguments) == 6
        [x2,y2,linenames2] = pgf_getXY(arguments(4:6), filename);
    elseif length(arguments) == 5
        [x2,y2,linenames2] = pgf_getXY(arguments(4:5), filename);
    else
        error('Usage'),
    end
elseif isnumeric(arguments{3})
    [x1,y1,linenames1] = pgf_getXY([arguments(1:2) strcat(filename,'1')], filename);
    if length(arguments) == 5
        [x2,y2,linenames2] = pgf_getXY(arguments(3:5), filename);
    elseif length(arguments) == 4
        [x2,y2,linenames2] = pgf_getXY([arguments(3:4) strcat(filename,'2')], filename);
    else
        error('Usage'),
    end
else
    error('Usage');
end

% Überprüfen, ob Linenames doppelt vorhanden sind oder verbotene Zeichen enthalten
pgf_checkLinenames([linenames1 linenames2]);

% ggf. .\TikZdata\ und .\TikZdata\filename erzeugen
pgf_createFolders(folder, filename);

%% txt-Files erstellen und Datenmenge überprüfen

for i=1:length(linenames1)
    [num1(i), sets1(i), vectorlength1(i)] = pgf_files(x1{i},y1{i},strcat(folder,'TikZdata\',filename,'\',linenames1{i},'.txt'));
end
numprintlines1 = sum(num1);
set1 = [];
for i=1:length(num1)
    set1(i) = sets1(i);
end

for i=1:length(linenames2)
    [num2(i), sets2(i), vectorlength2(i)] = pgf_files(x2{i},y2{i},strcat(folder,'TikZdata\',filename,'\',linenames2{i},'.txt'));
end
numprintlines2 = sum(num2);
set2 = [];
for i=1:length(num2)
    set2(i) = sets2(i);
end


% Überprüfen, ob die Datenmenge zu groß ist:
if (sum(vectorlength1) + sum(vectorlength2)) > 12000
    warning('Datenmenge vermutlich zu groß!')
end

%% MIN und MAX-Werte für die x-Achse
minx = 1e10; 
miny = 1e10;
maxx = -1e10;
maxy = -1e10;
for i=1:length(linenames1)
    minx = min(minx, min(x1{i}));
    miny = min(miny, min(y1{i}));
    maxx = max(maxx, max(x1{i}));
    maxy = max(maxy, max(y1{i}));
end
for i=1:length(linenames2)
    minx = min(minx, min(x2{i}));
    miny = min(miny, min(y2{i}));
    maxx = max(maxx, max(x2{i}));
    maxy = max(maxy, max(y2{i}));
end

%% ggf. tikz-Datei erstellen
% relativen Pfad bestimmen
path = pgf_getRelPath(folder, filename);

if ~exist(strcat(folder,filename,fileext),'file')
    fid = fopen(strcat(folder,filename,fileext),'w');
    fprintf(fid,'\\renewcommand{\\mywidth}{\\textwidth-20mm} %% HIER die Breite und Höhe des Bildes ändern\r\n');
    fprintf(fid,'\\renewcommand{\\myheight}{50mm}            %% diese bieden Zeilen NICHT löschen!\r\n \r\n');
    
    fprintf(fid,'\\begin{tikzpicture} \r\n');
    fprintf(fid,'  \\begin{plotyyLeft}[xlabel=$x$, \r\n');
    fprintf(fid,'                     ylabel=$y_1$, \r\n');
    fprintf(fid,'                     xmin=%d, xmax=%d,  %% Diese Zeile NICHT löschen\r\n',minx,maxx);
    fprintf(fid,'%%                     ymin=0, ymax=20, \r\n');
    fprintf(fid,'%%                     y label style = {blue}, y axis line style={blue}, y tick label style={blue},\r\n');
    fprintf(fid,'                     ]\r\n');
    for i=numprintlines1:-1:1
      if set1(i) == 1
        fprintf(fid,'    \\addplot[smooth, blue, semithick] table{%s}; \\label{%s}\r\n',strcat(path,linenames1{i},'.txt'),linenames1{i});
      else
        fprintf(fid,'    \\addplot[smooth, blue, semithick]              table{%s}; \\label{%s}\r\n',strcat(path,linenames1{i},'-',num2str(1),'.txt'),linenames1{i});
        for j=2:set1(i)
          fprintf(fid,'    \\addplot[smooth, blue, semithick, forget plot] table{%s};\r\n',strcat(path,linenames1{i},'-',num2str(j),'.txt'));
        end
      end
    end
    fprintf(fid,'  \\end{plotyyLeft}\r\n');
    fprintf(fid,'%% \r\n');
    fprintf(fid,'  \\begin{plotyyRight}[ylabel=$y_2$, \r\n');
    fprintf(fid,'                      xmin=%d, xmax=%d,  %% Diese Zeile NICHT löschen\r\n',minx,maxx);
    fprintf(fid,'%%                      ymin=0, ymax=20, \r\n');
    fprintf(fid,'%%                      y label style = {red}, y axis line style={red}, y tick label style={red},\r\n');
    fprintf(fid,'                      reverse legend, \r\n');
    fprintf(fid,'                      legend pos = north east,  %% [outer] south west|south east|north west|north east\r\n');
    fprintf(fid,'                      legend cell align=left,   %% Legendeneinträge linksbündig\r\n');
    fprintf(fid,'                      ]\r\n');
    for i=numprintlines2:-1:1
      if set2(i) == 1
        fprintf(fid,'    \\addplot[smooth, red, semithick] table{%s};\r\n',strcat(path,linenames2{i},'.txt'));
      else
        fprintf(fid,'    \\addplot[smooth, red, semithick]              table{%s};\r\n',strcat(path,linenames2{i},'-',num2str(1),'.txt'));
        for j=2:set2(i)
          fprintf(fid,'    \\addplot[smooth, red, semithick, forget plot] table{%s};\r\n',strcat(path,linenames2{i},'-',num2str(j),'.txt'));
        end
      end
      fprintf(fid,'      \\addlegendentry{%s};\r\n',linenames2{i});
    end
    fprintf(fid,'\r\n',linenames2{i});
    fprintf(fid,'  %% Legende für y1\r\n',linenames2{i});
    for i=numprintlines1:-1:1
        fprintf(fid,'    \\addlegendimage{/pgfplots/refstyle=%s} \\addlegendentry{%s}\r\n',linenames1{i},linenames1{i});
    end
        
    fprintf(fid,'\r\n');
    fprintf(fid,'  \\end{plotyyRight}\r\n');
    fprintf(fid,'\\end{tikzpicture}\r\n');
    
    fclose(fid);
end

end

