% Usage: pgfasymp(G1,[name],[G2, [name], ...], [w], filename, folder)
%
% Die Funktionsweise von "pgfasymp(.)" ist die gleiche, wie die von der 
% Matlab-Funktion "bode(G)", nur dass zusätzlich noch die Asymptoten ge-
% plottet werden.
%
% Die Angabe von "filename" und "folder" sind zwingend notwendig.  Es wird 
% die Datei "filename" im Ordner "folder" erzeugt, die fertigen tikz-code 
% enthält, der direkt in LaTeX kompilierbar ist. Ausserdem wird ggf. der 
% Ordner "folder\TikZData" erstellt, falls er noch nicht vorhanden ist und 
% dort Dateien abgelegt, die die Daten enthalten.
% 
% Die Datei "pgfasymp(.)" kann bedenkenlos mehrmals ausgeführt werden,
% ohne dass man Angst haben muss, seine in der "filename" gemachten
% Formatierungen zu verlieren, da die Datei, sobald sie einmal existiert,
% nicht überschrieben wird. Nur die Dateien mit den Daten werden über
% -schrieben. Dies hat natürlich auch den Nachteil, dass gegebenenfalls 
% nicht mehr alle Datendateien korrekt in der tikz-Datei eingebunden sind, 
% falls sich die Komplexität der Übertragungsfunktionen G ändert.Dies muss 
% man dann per Hand nachholen.
% 
% Beispiele: 
%   G1 = zpk([],[-1],1);
%   G2 = zpk([],[-10],10);
%   G(1)=G1; G(2)=G2
%   
%   pgfasymp(G1,'myfile.tikz','d:\myfolder');
%   pgfasymp(G1,'a',G2,'b',{1e0,1e2},'myfile.tikz','d:\myfolder');
%   pgfasymp(G,'ab','myfile.tikz','d:\myfolder');
%   ...
function [] = pgfasymp(varargin)
mag = [];
phase = [];
freq = [];
w = [];

% Überprüfen auf korrekte Eingabewerte
if nargin < 3 
    error('not enough input arguments');
end

% folder und filename abspalten
[arguments, filename, fileext, folder] = pgf_separation(varargin);

%% Üfkts extrahieren
[G, linenames, w] = pgf_getXferFcn(arguments, filename);

% Überprüfen, ob Linenames doppelt vorhanden sind oder verbotene Zeichen enthalten
pgf_checkLinenames(linenames);

% ggf. .\TikZdata\ und .\TikZdata\filename erzeugen
pgf_createFolders(folder, filename);

%% txt-Dateien schreiben und Datenmenge überprüfen
for i=1:length(G)
    [mag, phase, freq, amag, amagfreq, aphase, aphasefreq] = asymp(G{i},w);
    mag   = squeeze(mag);
    phase = squeeze(phase); 
    % Phase-Wrapping
    if phase(1) > 180
        phase = phase-360;
    end
        
    [num(i), sets(i), vectorlength(i)] = pgf_files(freq,mag,strcat(folder,'TikZdata\',filename,'\',linenames{i},'_mag.txt'));
    pgf_files(amagfreq,amag,strcat(folder,'TikZdata\',filename,'\',linenames{i},'_amag.txt'));
    pgf_files(freq,phase,strcat(folder,'TikZdata\',filename,'\',linenames{i},'_phase.txt'));
    pgf_files(aphasefreq,aphase,strcat(folder,'TikZdata\',filename,'\',linenames{i},'_aphase.txt'));
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
    fprintf(fid,'%% Amplitudengang \r\n');
    fprintf(fid,'  \\begin{bodeAmpDB}[mark size = 0.8mm,        %% Radius der Marker\r\n');
    fprintf(fid,'                    enlarge x limits = false,\r\n');
    fprintf(fid,'                    grid=both,                %% minor|major|both|none\r\n');
    fprintf(fid,'                    legend pos = north east,  %% [outer] south west|south east|north west|north east\r\n');
    fprintf(fid,'                    legend cell align=left,   %% Legendeneinträge linksbündig\r\n');
    fprintf(fid,'                    ]\r\n');
    for i=1:numprintlines
      if set(i) == 1
        fprintf(fid,'    \\addplot[red, dashed, thick, forget plot] table{%s};\r\n',strcat(path,linenames{i},'_amag','.txt'));
        fprintf(fid,'    \\addplot[red, only marks, forget plot]    table{%s};\r\n',strcat(path,linenames{i},'_amag','.txt'));
        fprintf(fid,'    \\addplot[black, smooth, line width=1pt]   table{%s};\r\n',strcat(path,linenames{i},'_mag','.txt'));
      else
        fprintf(fid,'    \\addplot[red, dashed, thick, forget plot]            table{%s};\r\n',strcat(path,linenames{i},'_amag-',num2str(1),'.txt'));
        fprintf(fid,'    \\addplot[red, only marks, forget plot]               table{%s};\r\n',strcat(path,linenames{i},'_amag-',num2str(1),'.txt'));
        fprintf(fid,'    \\addplot[black, smooth, line width=1pt]              table{%s};\r\n',strcat(path,linenames{i},'_mag-',num2str(1),'.txt'));
        for j=2:set(i)
          fprintf(fid,'    \\addplot[red, dashed, thick, forget plot]            table{%s};\r\n',strcat(path,linenames{i},'_amag-',num2str(j),'.txt'));
          fprintf(fid,'    \\addplot[red, only marks, forget plot]               table{%s};\r\n',strcat(path,linenames{i},'_amag-',num2str(j),'.txt'));
          fprintf(fid,'    \\addplot[black, smooth, line width=1pt, forget plot] table{%s};\r\n',strcat(path,linenames{i},'_mag-',num2str(j),'.txt'));
        end
      end
      fprintf(fid,'    \\addlegendentry{%s};\r\n',linenames{i});
    end    
    fprintf(fid,'  \\end{bodeAmpDB}\r\n');
    
    fprintf(fid,' \r\n');
    fprintf(fid,'%% Phasengang \r\n');
    fprintf(fid,'  \\begin{bodePhase}[mark size = 0.8mm,    %% Radius der Marker\r\n');
    fprintf(fid,'                    enlarge x limits = false,\r\n');
    fprintf(fid,'                    ]\r\n');
    for i=1:numprintlines
        if set(i) == 1
            fprintf(fid,'    \\addplot[red,   dashed, thick]          table{%s};\r\n',strcat(path,linenames{i},'_aphase','.txt'));
            fprintf(fid,'    \\addplot[red,   only marks]             table{%s};\r\n',strcat(path,linenames{i},'_aphase','.txt'));
            fprintf(fid,'    \\addplot[black, smooth, line width=1pt] table{%s};\r\n',strcat(path,linenames{i},'_phase','.txt'));
        else
            for j=1:set(i)
                fprintf(fid,'    \\addplot[red,   dashed, thick]          table{%s};\r\n',strcat(path,linenames{i},'_aphase-',num2str(j),'.txt'));
                fprintf(fid,'    \\addplot[red,   only marks]             table{%s};\r\n',strcat(path,linenames{i},'_aphase-',num2str(j),'.txt'));
                fprintf(fid,'    \\addplot[black, smooth, line width=1pt] table{%s};\r\n',strcat(path,linenames{i},'_phase-',num2str(j),'.txt'));
            end
        end
    end
    fprintf(fid,'  \\end{bodePhase}\r\n');
    fprintf(fid,'\\end{tikzpicture}\r\n');
    
    fclose(fid);
end

close
end

