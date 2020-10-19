% Usage: pgfsemilogx(x,y,[linename, x2,y2,...], filename, folder)
%
% Die Funktionsweise von "pgfsemilogx(.)" ist (fast) die gleiche, wie die 
% von der Matlab-Funktion "semilogx(x,y)".
% 
% Die Angabe von "filename" und "folder" sind zwingend notwendig.  Es wird 
% die Datei "filename" im Ordner "folder" erzeugt, die fertigen tikz-code 
% enth�lt, der direkt in LaTeX kompilierbar ist. Ausserdem wird ggf. der
% Ordner "folder\TikZData" erstellt, falls er noch nicht vorhanden ist und 
% dort die Dateien abgelegt, die die Daten enthalten.
%
% 'x' und 'y' k�nnen Vektoren oder Matrizen sein. Die Angabe von 'name' ist
% optional.
% 
% Die Datei "pgfsemilogx(.)" kann bedenkenlos mehrmals ausgef�hrt werden, ohne
% dass man Angst haben muss, seine in der "filename" gemachten Formatier-
% ungen zu verlieren, da die Datei, sobald sie einmal existiert, nicht
% �berschrieben wird. Nur die Dateien mit den Daten werden �berschrieben. 
% Dies hat nat�rlich auch den Nachteil, dass gegebenenfalls nicht mehr alle
% Datendateien korrekt in der tikz-Datei eingebunden sind, falls sich die 
% L�nge der Vektoren bzw. Matrizen x und y �ndert.Dies muss man dann per 
% Hand nachholen.
% 
% 
% Beispiele: 
%   x  = logspace(0,2);
%   y1 = log10(x);
%   y2 = 2*log10(x);
%   
%   pgfsemilogx(x,y1,'myfile.tikz','d:\myfolder');
%   pgfsemilogx(x,y1,'a',x,y2,'b','myfile.tikz','d:\myfolder');
%   pgfsemilogx(x,[y1;y2],'a und b','myfile.tikz','d:\myfolder');
%   ...
function [] = pgfsemilogx(varargin)

% �berpr�fen auf korrekte Eingabewerte
if nargin < 4 
    error('not enough input arguments');
end

% folder und filename abspalten
[arguments, filename, fileext, folder] = pgf_separation(varargin);

% x- und y- Vektoren, sowie Linenames extrahieren
[x,y, linenames] = pgf_getXY(arguments, filename);

% �berpr�fen, ob Linenames doppelt vorhanden sind oder verbotene Zeichen enthalten
pgf_checkLinenames(linenames);

% ggf. .\TikZdata\ und .\TikZdata\filename erzeugen
pgf_createFolders(folder, filename);

%% txt-Dateien erzeugen und Datenmenge �berpr�fen
for i=1:length(linenames)
    [num(i), sets(i), vectorlength(i)] = pgf_files(x{i},y{i},strcat(folder,'TikZdata\',filename,'\',linenames{i},'.txt'));
end

numprintlines = sum(num);
set = [];
for i=1:length(num)
    set(i) = sets(i);
end

% �berpr�fen, ob die Datenmenge zu gro� ist:
if sum(vectorlength) > 12000
    warning('Datenmenge vermutlich zu gro�!')
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
    fprintf(fid,'  \\begin{semilogxaxis}[xlabel=$x$, \r\n');
    fprintf(fid,'                       ylabel=$y$, \r\n');
    fprintf(fid,'                       enlarge x limits=false,\r\n');
    fprintf(fid,'%%                       ymin=0, ymax=20,\r\n');
    fprintf(fid,'%%                       minor tick num = 1, %% alternativ: minor x|y|z tick num\r\n');
    fprintf(fid,'                       grid=both, %% minor|major|both|none\r\n');
    fprintf(fid,'                       legend pos = north east,  %% [outer] south west|south east|north west|north east\r\n');
    fprintf(fid,'                       legend cell align=left,   %% Legendeneintr�ge linksb�ndig\r\n');
    fprintf(fid,'                       width=\\mywidth, height=\\myheight,\r\n'); 
    fprintf(fid,'                       ]\r\n');
    for i=1:numprintlines
      if set(i) == 1
        fprintf(fid,'    \\addplot[smooth, %s, semithick] table{%s};\r\n',cvec{i},strcat(path,linenames{i},'.txt'));
      else
        fprintf(fid,'    \\addplot[smooth, %s, semithick]              table{%s};\r\n',cvec{i},strcat(path,linenames{i},'-',num2str(1),'.txt'));
        for j=2:set(i)
          fprintf(fid,'    \\addplot[smooth, %s, semithick, forget plot] table{%s};\r\n',cvec{i},strcat(path,linenames{i},'-',num2str(j),'.txt'));
        end
      end
      fprintf(fid,'      \\addlegendentry{%s};\r\n',linenames{i});
    end
    fprintf(fid,'  \\end{semilogxaxis}\r\n');
    fprintf(fid,'\\end{tikzpicture}\r\n');
    
    fclose(fid);
end

end