% Usage: pgfnyquist(G1,[name],[G2, [name], ...], filename, folder)
%
% TODO: Pfeil ändert sich nicht nach neuem Ausführen!!!
% 
% Die Funktionsweise von "pgfnyquist(.)" ist die gleiche, wie von der 
% Matlab Funktion "nyquist(G)". Die Angabe von "name" ist optional.
%
% Die Angabe von "filename" und "folder" sind zwingend notwendig.  Es wird 
% die Datei "filename" im Ordner "folder" erzeugt, die fertigen tikz-code 
% enthält, der direkt in LaTeX kompilierbar ist. Ausserdem wird ggf. der
% Ordner "folder\TikZData" erstellt, falls er noch nicht vorhanden ist und 
% dort die Dateien abgelegt, die die Daten enthalten.
% 
% Die Datei "pgfnyquist(.)" kann bedenkenlos mehrmals ausgeführt werden, 
% ohne dass man Angst haben muss, seine in der "filename" gemachten Forma-
% tierungen zu verlieren, da die Datei, sobald sie einmal existiert, nicht
% überschrieben wird. Nur die Dateien mit den Daten werden überschrieben. 
% Dies hat natürlich auch den Nachteil, dass gegebenenfalls nicht mehr alle
% Datendateien korrekt in der tikz-Datei eingebunden sind, falls sich die 
% Länge der Vektoren bzw. Matrizen x und y ändert.Dies muss man dann per 
% Hand nachholen.
% 
% Beispiele: 
%   G1 = zpk([],[-1],1);
%   G2 = zpk([],[-10],10);
%   G(1)=G1; G(2)=G2
%   pgfnyquist(G1,'myfile.tikz','d:\myfolder');
%   pgfnyquist(G,'myfile.tikz','d:\myfolder');
%   pgfnyquist(G1,'a',G2,'b','myfile.tikz','d:\myfolder');
%   ...
function [] = pgfnyquist(varargin)
re = [];
im = [];

% Überprüfen auf korrekte Eingabewerte
if nargin < 3 
    error('not enough input arguments');
end

% folder und filename abspalten
[arguments, filename, fileext, folder] = pgf_separation(varargin);

% Übertragungsfunktionen und linenames extrahieren
[G, linenames] = pgf_getXferFcn(arguments, filename);

% Überprüfen, ob Linenames doppelt vorhanden sind oder verbotene Zeichen enthalten
pgf_checkLinenames(linenames);

% ggf. .\TikZdata\ und .\TikZdata\filename erzeugen
pgf_createFolders(folder, filename);

%% Ortskurve ermitteln

% Frequenzbereich
w = {1e-10, 1e10};

% RE und IM Werte ermitteln
remax = -1e10;
remin = 1e10;
immax = -1e10;
immin = 1e10;
for i=1:length(linenames)
    [rei, imi] = nyquist(G(i),w);
    re{i} = squeeze(rei);
    im{i} = squeeze(imi); negim{i} = -im{i};
    % maximal und minimal Werte für x- und y-Achse
    remax = max(max(rei),remax);
    remin = min(min(rei),remin);
    immax = max(max(imi),immax);
    immin = min(min(imi),immin);

    %% WTF passiert hier? und warum?
%     if abs(remax+remin) > abs(immax+immin)
%         immax = (immax+immin)/2 + (remax+remin)/2;
%         immin = (immax+immin)/2 - (remax+remin)/2;
%     else
%         remax = (remax+remin)/2 + (immax+immin)/2;
%         remin = (remax+remin)/2 - (immax+immin)/2;
%     end
    %%
    % Koordinaten für Pfeil
    midway = round(length(re{i})/2);
    arrow.re(1,i) = re{i}(midway);
    arrow.re(2,i) = re{i}(midway+1);
    arrow.im(1,i) = im{i}(midway);
    arrow.im(2,i) = im{i}(midway+1);
end

for i=1:length(linenames)
    j = 1;
    while j <= length(re{i})
        if abs(re{i}(j)) < 100 && abs(im{i}(j)) < 100
            j = j+1;
        else
            re{i}(j)    = [];
            im{i}(j)    = [];
            negim{i}(j) = [];
        end
    end
end

%% txt-Dateien erstellen und Datenmenge überprüfen
for i=1:length(linenames)
    [num(i), sets(i), vectorlength(i)] = pgf_files(re{i},im{i},strcat(folder,'TikZdata\',filename,'\',linenames{i},'.txt'));
                                         pgf_files(re{i},negim{i},strcat(folder,'TikZdata\',filename,'\',linenames{i},'_neg.txt'));
end

numprintlines = sum(num);
set = [];
for i=1:length(num)
    set(i) = sets(i);
end

% Überprüfen, ob Datenmenge zu groß ist
if 2*sum(vectorlength) > 12000 % 2* wegen amplitude und phase
    warning('Datenmenge vermutlich zu groß!')
end

%% ggf. tikz-Datei erstellen
% relativen Pfad bestimmen
path = pgf_getRelPath(folder, filename);

if ~exist(strcat(folder,filename,fileext),'file')
    fid = fopen(strcat(folder,filename,fileext),'w');
    fprintf(fid,'\\renewcommand{\\mywidth}{0.8\\textwidth} \r\n');
    fprintf(fid,'\\renewcommand{\\myheight}{50mm} \r\n \r\n');
    
    fprintf(fid,'\\begin{tikzpicture} \r\n');
    fprintf(fid,'  \\begin{axis}[xlabel = Reelle Achse, \r\n');
    fprintf(fid,'               ylabel = Imaginäre Achse, \r\n');
    fprintf(fid,'               axis equal = true, \r\n');
    fprintf(fid,'%%               minor tick num = 1, %% alternativ: minor x|y|z tick num\r\n');
    fprintf(fid,'               grid=both, %% minor|major|both|none\r\n');
    fprintf(fid,'               legend pos = north east,  %% [outer] south west|south east|north west|north east\r\n');
    fprintf(fid,'               legend cell align=left,   %% Legendeneinträge linksbündig\r\n');
    fprintf(fid,'               disabledatascaling,\r\n');
    fprintf(fid,'                       width=\\mywidth, height=\\myheight,\r\n'); 
    
    fprintf(fid,'               ]\r\n');
    for i=1:numprintlines
        if set(i) == 1
            fprintf(fid,'    \\addplot[smooth, line width=1pt] table{%s};\r\n',strcat(path,linenames{i},'.txt'));
            fprintf(fid,'    %%\\addplot[smooth, line width=1pt, dashed] table{%s};\r\n',strcat(path,linenames{i},'_neg.txt'));
        else
            fprintf(fid,'    \\addplot[smooth, line width=1pt]              table{%s};\r\n',strcat(path,linenames{i},'-1','.txt'));
            for j=2:set(i)
                fprintf(fid,'    \\addplot[smooth, line width=1pt, forget plot] table{%s};\r\n',strcat(path,linenames{i},'-',num2str(j),'.txt'));
            end
            fprintf(fid,'    %%\\addplot[smooth, line width=1pt, dashed]              table{%s};\r\n',strcat(path,linenames{i},'-1','_neg.txt'));
            for j=2:set(i)
                fprintf(fid,'    %%\\addplot[smooth, line width=1pt, forget plot, dashed] table{%s};\r\n',strcat(path,linenames{i},'-',num2str(j),'_neg.txt'));
            end
        end
        fprintf(fid,'      \\draw[draw=none, decoration={markings,mark=at position 1 with {\\arrow[scale=2]{>}}},\r\n');
        fprintf(fid,'            postaction={decorate}\r\n');
        fprintf(fid,'            ] (axis cs: %s,%s) -- (axis cs: %s,%s);\r\n',arrow.re(1,i),arrow.im(1,i),arrow.re(2,i),arrow.im(2,i));
        fprintf(fid,'      %%\\draw[draw=none, decoration={markings,mark=at position 1 with {\\arrow[scale=2]{>}}},\r\n');
        fprintf(fid,'      %%      postaction={decorate}\r\n');
        fprintf(fid,'      %%      ] (axis cs: %s,%s) -- (axis cs: %s,%s);\r\n',arrow.re(2,i),-arrow.im(2,i),arrow.re(1,i),-arrow.im(1,i));
        
        if numprintlines > 1
            fprintf(fid,'    \\addlegendentry{%s};\r\n',strrep(linenames{i},'_','-'));
        end
    end
    fprintf(fid,'\r\n');
    fprintf(fid,'    %% Koordinatenachsen\r\n');
    fprintf(fid,'    \\draw[very thin] (axis cs:\\pgfkeysvalueof{/pgfplots/xmin},0) -- (axis cs:\\pgfkeysvalueof{/pgfplots/xmax},0);\r\n');
    fprintf(fid,'    \\draw[very thin] (axis cs:0,\\pgfkeysvalueof{/pgfplots/ymin}) -- (axis cs:0,\\pgfkeysvalueof{/pgfplots/ymax});\r\n\r\n');
    fprintf(fid,'    %% Einheitskreis \r\n');
    fprintf(fid,'    \\draw[dashed] (0,0) circle (1);\r\n');
    fprintf(fid,'\r\n');
    fprintf(fid,'  \\end{axis}\r\n');
    fprintf(fid,'\\end{tikzpicture}\r\n');
    
    fclose(fid);
end

end

