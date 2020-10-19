% pgfbode([G1,G2],'name_test','d:\TikZ\Test\Bilder');% Usage: pgfbode(G1,[name],[G2, [name], ...], [w], filename, folder)
% Usage: pgfbode(mag,phase,freq,[name], [mag,phase,freq,[name],...], filename, folder)
%
% Die Funktionsweise von "pgfbode(.)" ist die gleiche, wie von der Matlab
% Funktion "bode(G)". Statt Übertragungsfunktionen G können auch direkt 
% Amplitude, Phase und Frequenz übergeben werden.
%
% Die Angabe von "filename" und "folder" sind zwingend notwendig.  Es wird 
% die Datei "filename" im Ordner "folder" erzeugt, die fertigen tikz-code 
% enthält, der direkt in LaTeX kompilierbar ist. Ausserdem wird ggf. der
% Ordner "folder\TikZData" erstellt, falls er noch nicht vorhanden ist und 
% dort die Dateien abgelegt, die die Daten enthalten.
% 
% 'mag', 'phase' und 'freq' können Vektoren oder Matrizen sein. Die Angabe 
% von 'name' ist (jeweils) optional.
%
% Die Datei "pgfbode(.)" kann bedenkenlos mehrmals ausgeführt werden, ohne
% dass man Angst haben muss, seine in der "filename" gemachten Formatier-
% ungen zu verlieren, da die Datei, sobald sie einmal existiert, nicht
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
% 
%   pgfbode(G1,'myfile.tikz','d:\myfolder');
%   pgfbode(G1,'a',G2,'b',{1e0,1e2},'myfile.tikz','d:\myfolder');
%   pgfbode(G,'ab','myfile.tikz','d:\myfolder');
%   ...
% 
% ODER
%   [mag, phase, freq] = bode(G1);
%   mag=squeeze(mag); phase=squeeze(phase);
% 
%   pgfbode(mag,phase,freq,'myBode','myfile','d:\myfolder');
% 
function pgfbode(varargin)
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

%% Argumente (Üfkt's bzw. [mag,phase,freq]) extrahieren

% pgfbode(G1,G2,...)
if isobject(arguments{1})
   [G, linenames, w] = pgf_getXferFcn(arguments, filename);

   % mag, phase und freq für alle Üfkts schreiben
   for i=1:length(G)
        [magi, phasei, freq{i}] = bode(G{i},w);
        mag{i}   = mag2db(squeeze(magi));
        phase{i} = squeeze(phasei); 
        % Phase-Wrapping
        if phase{i}(1) > 180
            phase{i} = phase{i} -360;
        end
   end
    
% pgfbode(mag,phase,freq,...)
elseif isnumeric(arguments{1})
    [mag,phase,freq, linenames] = pgf_getXYZ(arguments, filename);
else
    error('Usage');
end

% Überprüfen, ob Linenames doppelt vorhanden sind oder verbotene Zeichen enthalten
pgf_checkLinenames(linenames);

% ggf. .\TikZdata\ und .\TikZdata\filename erzeugen
pgf_createFolders(folder, filename);

%% txt-Dateien erstellen und Datenmenge überprüfen

for i=1:length(linenames)
    [num(i), sets(i), vectorlength(i)] = pgf_files(freq{i},mag{i},strcat(folder,'TikZdata\',filename,'\',linenames{i},'_mag.txt'));
                                         pgf_files(freq{i},phase{i},strcat(folder,'TikZdata\',filename,'\',linenames{i},'_phase.txt'));
end
if ~isobject(arguments{1})
    warning('Wenn der Plot komisch aussieht, ist ggf. "mag" nicht in dB...!');
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
    cvec = {'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal'};
    
    fid = fopen(strcat(folder,filename,fileext),'w');
    fprintf(fid,'\\renewcommand{\\mywidth}{0.8\\textwidth} \r\n');
    fprintf(fid,'\\renewcommand{\\myheight}{50mm} \r\n \r\n');
    
    fprintf(fid,'\\begin{tikzpicture} \r\n');
    fprintf(fid,'%% Amplitudengang \r\n');
    fprintf(fid,'  \\begin{bodeAmpDB}[\r\n');
    fprintf(fid,'                    enlarge x limits = false,\r\n');
    fprintf(fid,'                    grid=both, %% minor|major|both|none\r\n');
    fprintf(fid,'                    legend pos = north east,  %% [outer] south west|south east|north west|north east\r\n');
    fprintf(fid,'                    legend cell align=left,   %% Legendeneinträge linksbündig\r\n');
    fprintf(fid,'                    ]\r\n');
    for i=1:numprintlines
        if set(i) == 1
            fprintf(fid,'    \\addplot[smooth, %s, line width=1pt] table{%s};\r\n',cvec{i},strcat(path,linenames{i},'_mag.txt'));
        else
            fprintf(fid,'    \\addplot[smooth, %s, line width=1pt]              table{%s};\r\n',cvec{i},strcat(path,linenames{i},'_mag-',num2str(1),'.txt'));
            for j=2:set(i)
                fprintf(fid,'    \\addplot[smooth, %s, line width=1pt, forget plot] table{%s};\r\n',cvec{i},strcat(path,linenames{i},'_mag-',num2str(j),'.txt'));
            end
        end
        if numprintlines > 1
            fprintf(fid,'    \\addlegendentry{%s};\r\n',strrep(linenames{i},'_','-'));
        end
    end
    fprintf(fid,'  \\end{bodeAmpDB}\r\n');
    
    fprintf(fid,' \r\n');
    fprintf(fid,'%% Phasengang \r\n');
    fprintf(fid,'  \\begin{bodePhase}[\r\n');
    fprintf(fid,'                    enlarge x limits = false,\r\n');
    fprintf(fid,'                    grid=both, %% minor|major|both|none\r\n');
    fprintf(fid,'                    ]\r\n');
    for i=1:numprintlines
        if set(i) == 1
            fprintf(fid,'    \\addplot[smooth, %s, line width=1pt] table{%s};\r\n',cvec{i},strcat(path,linenames{i},'_phase.txt'));
        else
            for j=1:set(i)
                fprintf(fid,'    \\addplot[smooth, %s, line width=1pt] table{%s};\r\n',cvec{i},strcat(path,linenames{i},'_phase-',num2str(j),'.txt'));
            end
        end
    end
    fprintf(fid,'  \\end{bodePhase}\r\n');
    fprintf(fid,'\\end{tikzpicture}\r\n');
    
    fclose(fid);
end

end

