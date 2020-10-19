% pgfstep(G,[name],[G2,[name],...], [Tend / Tvec], filename, folder)
%
% Die Funktionsweise von "pgfstep(.)" ist (fast) die gleiche, wie die von 
% der Matlab-Funktion "step(.)".
% 
% Die Angabe von "filename" und "folder" sind zwingend notwendig.  Es wird 
% die Datei "filename" im Ordner "folder" erzeugt, die fertigen tikz-code 
% enthält, der direkt in LaTeX kompilierbar ist. Ausserdem wird ggf. der
% Ordner "folder\TikZData" erstellt, falls er noch nicht vorhanden ist und 
% dort die Dateien abgelegt, die die Daten enthalten.
%
% 'G' können beliebige LTI-model sein. Die Angabe von 'name' ist optional.
% Optional kann noch eine Endzeit 'Tend' oder ein Zeitvektor "Tvec"
% übergeben werden.
% 
% Die Datei "pgfstep(.)" kann bedenkenlos mehrmals ausgeführt werden, ohne
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
%   G1 = zpk([],[-1],1);
%   G2 = zpk([],[-10],10);
%   G(1)=G1; G(2)=G2
%   Tend = 12;
%   Tvec = linspace(0,Tend,100);
% 
%   pgfstep(G1,'myfile.tikz','d:\myfolder');
%   pgfstep(G1,'a',G2,'b',Tend,'myfile.tikz','d:\myfolder');
%   pgfstep(G,'ab',Tvec,'myfile.tikz','d:\myfolder');
%   ...
%   ...
function [] = pgfstep(varargin)
Tend = [];
Tvec = [];

% Überprüfen auf korrekte Eingabewerte
if nargin < 3 
    error('not enough input arguments');
end

% folder und filename abspalten
[arguments, filename, fileext, folder] = pgf_separation(varargin);

% Übertragungsfunktionen extrahieren, ggf. Tend oder Tvec ermitteln
if isnumeric(arguments{end})
    [G, linenames] = pgf_getXferFcn(arguments(1:end-1), filename);
    if length(arguments{end}) == 1
        Tend = arguments{end};
    elseif min(size(arguments{end}))==1
        Tvec = arguments{end};
    else
        error('Usage');
    end
else
    [G, linenames] = pgf_getXferFcn(arguments, filename);
end

% Überprüfen, ob Linenames doppelt vorhanden sind oder verbotene Zeichen enthalten
pgf_checkLinenames(linenames);

% ggf. .\TikZdata\ und .\TikZdata\filename erzeugen
pgf_createFolders(folder, filename);


%% txt-Dateien schreiben und ggf. Tend ermitteln

% ggf. Tend ermitteln
if isempty(Tend) && isempty(Tvec)
    Tend = 0;
    for i=1:length(G)
        [~,t] = step(G{i});
        Tend = max(Tend,t(end));
    end
end

for i=1:length(G)
    if isempty(Tvec)
        [y,t]   = step(G{i},Tend);
    else
        [y,t]   = step(G{i},Tvec);
    end
    yend(i) = dcgain(G{i});
    
    [num(i), sets(i), vectorlength(i)] = pgf_files(t,y,strcat(folder,'TikZdata\',filename,'\',linenames{i},'.txt'));
    if ~isinf(yend(i))
        pgf_files([t(1) t(end)],[yend(i), yend(i)],strcat(folder,'TikZdata\',filename,'\',linenames{i},'_end.txt'));
    end
end

numprintlines = sum(num);
set = [];
for i=1:length(num)
    set(i) = sets(i);
end

%% ggf. tikz-Datei erstellen
% relativen Pfad bestimmen
path = pgf_getRelPath(folder, filename);

if ~exist(strcat(folder,filename,fileext), 'file')
    cvec = {'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal'};
    
    fid = fopen(strcat(folder,filename,fileext),'w');
    fprintf(fid,'\\renewcommand{\\mywidth}{0.6\\textwidth} \r\n');
    fprintf(fid,'\\renewcommand{\\myheight}{50mm} \r\n');
    fprintf(fid,'\r\n');
    fprintf(fid,'\\begin{tikzpicture} \r\n');
    fprintf(fid,'  \\begin{axis}[xlabel=Zeit $t$ in s, \r\n');
    fprintf(fid,'               ylabel=Sprungantwort $y$, \r\n');
    fprintf(fid,'               enlarge x limits=false,\r\n');
    fprintf(fid,'%%               ymin=0, ymax=20,\r\n');
    fprintf(fid,'%%               minor tick num = 1,       %% alternativ: minor x|y|z tick num\r\n');
    fprintf(fid,'               grid=none,                %% minor|major|both|none\r\n');
    fprintf(fid,'               legend pos = north east,  %% [outer] south west|south east|north west|north east\r\n');
    fprintf(fid,'               legend cell align=left,   %% Legendeneinträge linksbündig\r\n');
    fprintf(fid,'               width=\\mywidth, height=\\myheight,\r\n'); 
    fprintf(fid,'               ]\r\n');
    for i=1:numprintlines
      if set(i) == 1
        fprintf(fid,'    \\addplot[smooth, %s, semithick] table{%s};\r\n',cvec{i},strcat(path,linenames{i},'.txt'));
      else
        fprintf(fid,'    \\addplot[smooth, %s, semithick] table{%s};\r\n',cvec{i},strcat(path,linenames{i},'-',num2str(1),'.txt'));
        for j=2:set(i)
          fprintf(fid,'    \\addplot[smooth, %s, semithick, forget plot] table{%s};\r\n',cvec{i},strcat(path,linenames{i},'-',num2str(j),'.txt'));
        end
      end
      fprintf(fid,'      \\addlegendentry{%s};\r\n',linenames{i});
      if ~isinf(yend(i))
          fprintf(fid,'      \\addplot[dashed, %s, forget plot] table{%s};\r\n',cvec{i},strcat(path,linenames{i},'_end.txt'));
      end
    end
    fprintf(fid,'  \\end{axis}\r\n');
    fprintf(fid,'\\end{tikzpicture}\r\n');
    
    fclose(fid);
end

end