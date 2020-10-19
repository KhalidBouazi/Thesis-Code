% Usage: pgfplot3(x,y,z,[name],[x2,y2,z2,[name]...], filename, folder)
%
% Die Funktionsweise von "pgfplot3(.)" ist (fast) die gleiche, wie die von 
% der Matlab-Funktion "plot3(x,y)".
% 
% Die Angabe von "filename" und "folder" sind zwingend notwendig.  Es wird 
% die Datei "filename" im Ordner "folder" erzeugt, die fertigen tikz-code 
% enthält, der direkt in LaTeX kompilierbar ist. Ausserdem wird ggf. der
% Ordner "folder\TikZData" erstellt, falls er noch nicht vorhanden ist und 
% dort die Dateien abgelegt, die die Daten enthalten.
%
% 'x','y' und 'z' können Vektoren oder Matrizen sein. Die Angabe von 'name'
% ist optional.
% 
% Die Datei "pgfplot3(.)" kann bedenkenlos mehrmals ausgeführt werden, ohne
% dass man Angst haben muss, seine in der "filename" gemachten Formatier-
% ungen zu verlieren, da die Datei, sobald sie einmal existiert, nicht
% überschrieben wird. Nur die Dateien mit den Daten werden überschrieben. 
% Dies hat natürlich auch den Nachteil, dass gegebenenfalls nicht mehr alle
% Datendateien korrekt in der tikz-Datei eingebunden sind, falls sich die 
% Länge der Vektoren bzw. Matrizen x und y ändert.Dies muss man dann per 
% Hand nachholen.
% 
% 
% Beispiele: 
%   z = 0:pi/50:10*pi;
%   x = sin(z);
%   y = cos(z);
%   
%   pgfplot3(x,y,z,'myfile.tikz','d:\myfolder');
%   ...
function [] = pgfplot3(varargin)
% Überprüfen auf korrekte Eingabewerte
if nargin < 5 
    error('not enough input arguments');
end

% folder und filename abspalten
[arguments, filename, fileext, folder] = pgf_separation(varargin);

% x- und y- Vektoren, sowie Linenames extrahieren
[x,y,z, linenames] = pgf_getXYZ(arguments, filename);

% Überprüfen, ob Linenames doppelt vorhanden sind oder verbotene Zeichen enthalten
pgf_checkLinenames(linenames);

% ggf. .\TikZdata\ und .\TikZdata\filename erzeugen
pgf_createFolders(folder, filename);

%% txt-Dateien erzeugen und Datenmenge überprüfen
for i=1:length(linenames)
    [num(i), sets(i), vectorlength(i)] = pgf_files(x{i},y{i},z{i},strcat(folder,'TikZdata\',filename,'\',linenames{i},'.txt'));
end

numprintlines = sum(num);
set = [];
for i=1:length(num)
    set(i) = sets(i);
end

% Überprüfen, ob die Datenmenge zu groß ist:
if sum(vectorlength) > 12000
    warning('Datenmenge vermutlich zu groß!')
end

%% ggf. tikz-Datei erstellen
% relativen Pfad bestimmen
path = pgf_getRelPath(folder, filename);

if ~exist(strcat(folder,filename,fileext),'file')
    cvec = {'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal'};
    
    fid = fopen(strcat(folder,filename,fileext),'w');
    fprintf(fid,'\\renewcommand{\\mywidth}{0.8\\textwidth} \r\n');
    fprintf(fid,'\\renewcommand{\\myheight}{50mm} \r\n \r\n');
    
    fprintf(fid,'\\begin{tikzpicture} \r\n');
    fprintf(fid,'  \\begin{axis}[xlabel=$x$, \r\n');
    fprintf(fid,'               ylabel=$y$, \r\n');
    fprintf(fid,'               zlabel=$z$, \r\n');
    fprintf(fid,'               view={30}{30}, \r\n');
%     fprintf(fid,'               enlarge x limits=false,\r\n');
%     fprintf(fid,'%%               ymin=0, ymax=20,\r\n');
%     fprintf(fid,'%%               minor tick num = 1, %% alternativ: minor x|y|z tick num\r\n');
    fprintf(fid,'               grid=none, %% minor|major|both|none\r\n');
    fprintf(fid,'               legend pos = north east,  %% [outer] south west|south east|north west|north east\r\n');
    fprintf(fid,'               legend cell align=left,   %% Legendeneinträge linksbündig\r\n');
    fprintf(fid,'                       width=\\mywidth, height=\\myheight,\r\n'); 
    fprintf(fid,'               ]\r\n');
    for i=1:numprintlines
      if set(i) == 1
        fprintf(fid,'    \\addplot3[smooth, %s, semithick] table{%s};\r\n',cvec{i},strcat(path,linenames{i},'.txt'));
      else
        fprintf(fid,'    \\addplot3[smooth, %s, semithick] table{%s};\r\n',cvec{i},strcat(path,linenames{i},'-',num2str(1),'.txt'));
        for j=2:set(i)
          fprintf(fid,'    \\addplot3[smooth, %s, semithick, forget plot] table{%s};\r\n',cvec{i},strcat(path,linenames{i},'-',num2str(j),'.txt'));
        end
      end
      fprintf(fid,'      \\addlegendentry{%s};\r\n',linenames{i});
    end
    fprintf(fid,'  \\end{axis}\r\n');
    fprintf(fid,'\\end{tikzpicture}\r\n');
    
    fclose(fid);
end

end