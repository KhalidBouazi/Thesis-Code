% pgfpzmap(G,[name],[G2,[name],...], filename, folder)
%
% TODO: Pole und Nullstellen in txt-Datei speichern!
% 
% Die Funktionsweise von "pgfpzmap(.)" ist (fast) die gleiche, wie die von 
% der Matlab-Funktion "pzmap(G)".
% 
% Die Angabe von "filename" und "folder" sind zwingend notwendig.  Es wird 
% die Datei "filename" im Ordner "folder" erzeugt, die fertigen tikz-code 
% enthält, der direkt in LaTeX kompilierbar ist.
%
% 'G' können beliebige LTI-model sein. Die Angabe von 'name' ist optional.
% 
% Wird "pgfpzmap(.)" ein weiteres Mal ausgeführt, wird die beim ersten Mal
% erstellte tex-Datei NICHT mehr überschrieben. Sollten sich die Pole und
% Nullstellen der Übertragungsfunktionen geändert haben, müssen diese nun
% per Hand in der tex-Datei geändert werden.
% 
% Beispiele: 
%   G1 = tf([2 5 1],[1 2 3]);
%   G2 = zpk([-5],[-2,-10,],10);
%   G(1)=G1; G(2)=G2
% 
%   pgfpzmap(G,'myfile.tikz','d:\myfolder');
%   pgfpzmap(G,'myfile.tikz','d:\myfolder');
%   pgfpzmap(G,'myfile.tikz','d:\myfolder');
%   ...
%   ...
function [] = pgfpzmap(varargin)
% Überprüfen auf korrekte Eingabewerte
if nargin < 3 
    error('not enough input arguments');
end

% folder und filename abspalten
[arguments, filename, fileext, folder] = pgf_separation(varargin);

% Übertragungsfunktionen extrahieren
[G, linenames] = pgf_getXferFcn(arguments, filename);

% Überprüfen, ob Linenames doppelt vorhanden sind oder verbotene Zeichen enthalten
pgf_checkLinenames(linenames);

%% Pole und Nullstellen bestimmen
xmin = 1e10;
xmax = -1e10;
ymin = 1e10;
ymax = -1e10;

for i=1:length(G)
    minreal(G(i));
    p{i} = pole(G(i));
    z{i} = zero(G(i));
    
    xmin = min(xmin, min(min(real(p{i})), min(real(z{i}))));
    xmax = max(xmax, max(max(real(p{i})), max(real(z{i}))));
    ymin = min(ymin, min(min(imag(p{i})), min(imag(z{i}))));
    ymax = max(ymax, max(max(imag(p{i})), max(imag(z{i}))));
end

% 10% Aufschlag für Grenzen des Plots
xmin = xmin-0.1*abs(xmin);
xmax = xmax+0.1*abs(xmax);
ymin = ymin-0.1*abs(ymin);
ymax = ymax+0.1*abs(ymax);


%% ggf. tikz-Datei erstellen
% relativen Pfad bestimmen
path = pgf_getRelPath(folder, filename);

if ~exist(strcat(folder,filename,fileext),'file')
    cvec = {'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal';'blue';'red';'green';'black';'violet';'cyan';'magenta';'gray';'orange';'gray';'olive';'purple';'teal'};
    fid = fopen(strcat(folder,filename,fileext),'w');
    fprintf(fid,'\\renewcommand{\\mywidth}{0.8\\textwidth} \r\n');
    fprintf(fid,'\\renewcommand{\\myheight}{50mm} \r\n \r\n');
        
    fprintf(fid,'%% Definitionen für gamma_max und omega_min (erlaubtes Polgebiet)\r\n');
    fprintf(fid,'\\def\\gammamax{45}\r\n');
    fprintf(fid,'\\def\\omegamin{2}\r\n \r\n');
    
    fprintf(fid,'\\begin{tikzpicture} \r\n');
    fprintf(fid,'  \\begin{axis}[xlabel = $\\operatorname{Re}$, \r\n');
    fprintf(fid,'               ylabel = $\\operatorname{Im}$, \r\n');
    fprintf(fid,'               axis lines = middle, %% middle|box\r\n');
    fprintf(fid,'               axis equal = true,\r\n');
    fprintf(fid,'               %%minor tick num = 1, %% alternativ: minor x|y|z tick num\r\n');
    fprintf(fid,'               axis on top, \r\n');
    fprintf(fid,'               grid=none, %% both|major|minor \r\n');
    fprintf(fid,'               extra y ticks={\\omegamin},\r\n');
    fprintf(fid,'               xmin=%d, xmax=%d, %% \r\n', xmin, xmax);
    fprintf(fid,'               ymin=%d, ymax=%d, \r\n', ymin, ymax);
    fprintf(fid,'               disabledatascaling,\r\n');
    fprintf(fid,'               width=\\mywidth, height=\\myheight,\r\n'); 
    fprintf(fid,'               ]\r\n\r\n');
    
    fprintf(fid,'    %% erlaubtes Polgebiet\r\n');
    fprintf(fid,'    \\path[fill=black!15, rotate=180] (-\\pgfkeysvalueof{/pgfplots/xmin},\\pgfkeysvalueof{/pgfplots/ymax}) -- (-\\pgfkeysvalueof{/pgfplots/xmin},0) -- (0,0) -- ( \\gammamax:-\\pgfkeysvalueof{/pgfplots/xmin}+\\pgfkeysvalueof{/pgfplots/ymax});\r\n');
    fprintf(fid,'    \\path[fill=black!15, rotate=180] (-\\pgfkeysvalueof{/pgfplots/xmin},\\pgfkeysvalueof{/pgfplots/ymin}) -- (-\\pgfkeysvalueof{/pgfplots/xmin},0) -- (0,0) -- (-\\gammamax:-\\pgfkeysvalueof{/pgfplots/xmin}+\\pgfkeysvalueof{/pgfplots/ymax});\r\n');
    fprintf(fid,'    \\draw[thin, fill=white]	(0,\\omegamin) arc (90:270:\\omegamin);\r\n');
    fprintf(fid,'    \\draw[thin, rotate=180] (0,0) -- ( \\gammamax:%d);\r\n',abs(xmin)+abs(ymax));
    fprintf(fid,'    \\draw[thin, rotate=180] (0,0) -- (-\\gammamax:%d);\r\n\r\n',abs(xmin)+abs(ymax));
    
    fprintf(fid,'    %% Beschriftung von ''omega_min'' und ''gamma_max''\r\n');
    fprintf(fid,'    \\node[right] at (0,\\omegamin) {$\\omega_\\mathrm{min}$};\r\n');
    fprintf(fid,'    \\draw[->, very thin, rotate=180] (0.4\\omegamin,0) arc(0:-\\gammamax:0.4\\omegamin) node[pos=1, left, font=\\tiny] {$\\gamma_\\mathrm{max}$};\r\n\r\n');
    
    fprintf(fid,'    %% Pole\r\n');
    for i=1:length(G)
        for j=1:length(p{i})
            fprintf(fid,'    \\node[%s] at (axis cs:%d,%d) {\\small$\\times$};\r\n',cvec{i}, real(p{i}(j)), imag(p{i}(j)));
        end
    end
    fprintf(fid,'\r\n');
    fprintf(fid,'    %% Nullstellen\r\n');
    for i=1:length(G)
        for j=1:length(z{i})
            fprintf(fid,'    \\node[%s] at (axis cs:%d,%d){\\tikz\\draw[semithick] (0,0) circle(3pt);};\r\n',cvec{i}, real(z{i}(j)), imag(z{i}(j)));
        end
    end
    fprintf(fid,'\r\n');
    fprintf(fid,'    %% Legende\r\n');
    for i=1:length(G)
        fprintf(fid,'    \\addlegendimage{empty legend}\r\n');
        fprintf(fid,'    \\addlegendentry{\\textcolor{%s}{$\\times$}, \\tikz\\draw[semithick, %s] (0,0) circle(2.5pt); \\ $G_%s$}\r\n',cvec{i},cvec{i},num2str(i));
    end
    
    fprintf(fid,'    %% Achsen (falls "axis lines = box")\r\n');
    fprintf(fid,'    \\draw[very thin] (axis cs:\\pgfkeysvalueof{/pgfplots/xmin},0) -- (axis cs:\\pgfkeysvalueof{/pgfplots/xmax},0);\r\n');
    fprintf(fid,'    \\draw[very thin] (axis cs:0,\\pgfkeysvalueof{/pgfplots/ymin}) -- (axis cs:0,\\pgfkeysvalueof{/pgfplots/ymax});\r\n\r\n');
    fprintf(fid,'  \\end{axis}\r\n');
    fprintf(fid,'\\end{tikzpicture}\r\n');
    
    fclose(fid);
else
   warning('Datei existiert bereits und wird nicht überschrieben! Änderungen müssen ggf. per Hand in der tex-Datei vorgenommen werden.') 
end

end