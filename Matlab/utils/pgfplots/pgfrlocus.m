% Usage: pgfrlocus(G, filename, folder)
%        pgfrlocus(G, filename, folder, plotRange)
%
% Die Funktionsweise von "pgfrlocus(.)" ist (fast) die gleiche, wie die von 
% der Matlab-Funktion "rlocus(G)".
% 
% Die Angabe von 'filename' und 'folder' sind zwingend notwendig. Es wird 
% die Datei "filename" im Ordner "folder" erzeugt, die fertigen tikz-code 
% enthält, der direkt in LaTeX kompilierbar ist. Ausserdem wird ggf. der
% Ordner "TikZData\folder" erstellt, falls er noch nicht vorhanden ist und 
% dort dann die Dateien "filename.txt" erstellt.
%
% "G" muss eine Übertragungsfunktion sein.
%
% "plotRange" ist optional. Hier können die sichtbaren Achsenabschnitte
% im Plot festgelegt werden. plotRange kann als 1D Zahl angegeben werden,
% um ein Quadrat um den Ursprung zu definieren, oder als Vektor der Form
% [xmin, ymax, xmax, ymin]. Ist ein Wert "inf" bzw. "-inf" wird der Wert
% anhand der WOK automatisch angepasst.
% Ausserdem wird durch die Verwendung von "plotRange" ein verkürzte Daten-
% Datei erstellt, in der für gerade Liniensegmente nur die Eckpunkte
% eingetragen werden.
% 
% Die Datei "pgfrlocus(.)" kann bedenkenlos mehrmals ausgeführt werden,
% ohne dass man Angst haben muss, seine in der "filename" gemachten
% Formatierungen zu verlieren, da die Datei, sobald sie einmal existiert,
% nicht überschrieben wird. Nur die Wertedateien "TikZdata\folder\filenameX.txt"
% werden überschrieben.
% 
% 
% Beispiele: 
%   G  = tf([2 5 1],[1 2 3]);
% 
%   pgfrlocus(G,'myfile.tikz','d:\myfolder');
%   pgfrlocus(G,'myfile.tikz','d:\myfolder',plotRange);
%   ...
%
% v2    24.08.2015   Ingmar Gundlach:
%       - k-Bereich angepasst (ehemals fester Bereich 1e-3 <= k <= 1e3)
%       - Abzweigpunkte hinzufügen
%       - Duplikate in rlocus?.txt-Datei entfernen
%       - Sehr große Werte entfernen, da diese zu TikZ-Fehler führen
%       - Asymptote wird nicht gezeichnet, wenn es nur 1 mit phi = 180° gibt.
%       - Einheitskreis bei diskreten Ü-Fkt. zeichnen.
%
% v3    11.03.2016   Ingmar Gundlach:
%       - Zusätzliches Eingabeargument maximaler Plotbereich (erfordert neue Version von pgf_files!!!)
%       - Bugfix beim Berechnen des VZP.
%       - Bugfix wenn keine Asymptoten existieren.
%       - try...catch eingefügt, damit .tikz-Datei auch bei einem Fehler geschlossen wird.

function [] = pgfrlocus(varargin)
%% Überprüfen auf korrekte Eingabewerte
narginchk(3,5);
if nargin >= 4 && isnumeric(varargin{end})
	% folder und filename abspalten
	[arguments, filename, fileext, folder] = pgf_separation(varargin(1:end-1));
	plotRange = varargin{end};
	plotRange = reshape(plotRange,1,[]);
	if length(plotRange) == 1
		plotRange = plotRange * [-1 1 1 -1];
	elseif length(plotRange) ~= 4 || any(imag(plotRange))
		error('Wert für plotRange muss eine reelle Zahl oder ein Vektor mit 4 reellen Zahlen sein.');
	end
else
	% folder und filename abspalten
	[arguments, filename, fileext, folder] = pgf_separation(varargin);
	plotRange = [-inf inf inf -inf];
end
xmin = plotRange(1); xmax = plotRange(3);
ymin = plotRange(4); ymax = plotRange(2);

% Übertragungsfunktionen extrahieren
G = pgf_getXferFcn(arguments, filename);
G = G{1};
if length(G)~=1
    error('G darf nur eine Üfkt enthalten!');
end

% ggf. .\TikZdata\ und .\TikZdata\filename erzeugen
pgf_createFolders(folder, filename);


%% Pole und Nullstellen berechnen

[z, p, v] = zpkdata(G, 'v');

%% Abzweigpunkte berechnen und einfügen

[num, den] = tfdata(G,'v');
AA = conv(num,polyder(den));
BB = conv(polyder(num),den);
a = find(AA~=0,1,'first');
b = find(BB~=0,1,'first');
A = AA(a:end);
B = BB(b:end);
if isempty(A)
	A = 0;
end
if isempty(B)
	B = 0;
end
points = roots(A - B);

% komplexe Abzweigpunkte entfernen
k = 1;
abzweigpunkte = [];
for i=1:length(points)
    if ~imag(points(i))
        abzweigpunkte(k) = points(i); %#ok<AGROW>
        k = k+1;
    end
end

%% Wok-Äste erzeugen
[~,k] = rlocus(G);
if isinf(k(end))
	k(end) = max([2*k(end-1) + k(end-2), 1e8]);
end
if k(1)==0
	k(1)   = min([2*k(2) - k(3), 1e-8]);
end
k = logspace(log10(k(1)),log10(k(end)),1000);

% Abzweigpunkte einfügen
kazp = zeros(1, length(abzweigpunkte));
for i = 1:length(abzweigpunkte)
    kazp(i) = prod(abs(abzweigpunkte(i) - p))/(v * prod(abs(abzweigpunkte(i) - z)));
end
k = sort([k, kazp]);

% WOK berechnen
r = rlocus(G,k);

% Real- und Imaginärwerte in x und y speichern
if size(r,1) < size(r,2)
    % Duplikate entfernen
    r = unique(round(r, 7)', 'rows', 'stable')';
    % zu große Werte führen zu TiKZ-Fehlern
    r(:,sum(abs(r)) > 100) = [];
    for i=1:size(r,1)
        allx = real(r(i,:));
		  ally = imag(r(i,:));
		  if ~all(isinf(plotRange))
			  % Zu große Werte löschen, d. h. auf NaN setzen (der 1. Wert wird nie gelöscht)
			  loeschen = false;
			   tmpx0 = allx(1);
				tmpy0 = ally(1);
			  for j = 2:length(allx)
				  tmpx = allx(j);
				  tmpy = ally(j);
				  if tmpx < xmin || tmpx > xmax || tmpy < ymin || tmpy > ymax
					  if loeschen
						  % Erst löschen, wenn mind. 1 Wert darüber ist.
					     allx(j) = NaN;
					     ally(j) = NaN;
					  else
						  loeschen = true;
					  end
				  elseif j < length(allx) && ...
						  (tmpx == tmpx0 && tmpx == allx(j+1) || tmpy == tmpy0 && tmpy == ally(j+1))
					  % Auf geraden Linien nur Eckelemente speichern.
					  allx(j) = NaN;
					  ally(j) = NaN;
				  else
					  tmpx0 = allx(j);
					  tmpy0 = ally(j);
				  end
			  end
		  end
	     x(:,i) = allx; %#ok<AGROW>
        y(:,i) = ally; %#ok<AGROW>
    end
else
    % Wann kommt das vor???
    for i=1:size(r,2)
        x(:,i) = real(r(:,i));
        y(:,i) = imag(r(:,i));
    end
end


%% Asymptotenschnittpunkt und -winkel berechnen
% Wurzelschwerpunkt
Apunkt = 1/(length(z)-length(p)) * (sum(real(z)) - sum(real(p)));

% Winkel
phi = [];
for i=1:length(p)-length(z)
    phi(i) = (2*i-1)*180/(length(p)-length(z));
end


%% txt-Dateien erstellen
pgf_files(x,y,strcat(folder,'TikZdata\',filename,'\','rlocus.txt'));



%% ggf. tikz-Datei erstellen
% relativen Pfad bestimmen
path = pgf_getRelPath(folder, filename);

% Plotbereich
if isinf(xmin)
	xmin = min(min(x));
end
if isinf(xmax)
	xmax = max(max(x));
end
if isinf(ymin)
	ymin = min(min(y));
end
if isinf(ymax)
	ymax = max(max(y));
end

if ~exist(strcat(folder,filename,fileext),'file')
    fid = fopen(strcat(folder,filename,fileext),'w');
	try
		fprintf(fid,'\\begin{tikzpicture} \r\n');
		fprintf(fid,'  \\begin{axis}[xlabel = $\\operatorname{Re\\{z\\}}$, \r\n');
		fprintf(fid,'               ylabel = $\\operatorname{Im\\{z\\}}$, \r\n');
		fprintf(fid,'               axis lines = middle, %% middle|box\r\n');
		fprintf(fid,'               axis equal = true,\r\n');
		fprintf(fid,'               axis on top, \r\n');
		fprintf(fid,'               grid=none, %% both|major|minor \r\n');
		fprintf(fid,'               %%minor tick num = 1, %% alternativ: minor x|y|z tick num\r\n');
		fprintf(fid,'               %%enlarge y limits = false,\r\n');
		fprintf(fid,'               xmin=%d, xmax=%d, \r\n', xmin, xmax);
		fprintf(fid,'               ymin=%d, ymax=%d, \r\n', ymin, ymax);
		fprintf(fid,'               width=0.8\\textwidth, height=50mm,\r\n'); 
		fprintf(fid,'               ]\r\n');
		fprintf(fid,'    %% Asymptoten\r\n');
		if ~isempty(phi) && (length(phi) > 1 || phi(1) ~= 180)
		  for i=1:length(phi)
				if (phi(i) < 180)
					 fprintf(fid,'    \\draw[blue, dashed] (axis cs:%.2f,0) -- (axis cs:%.2f,%.2f); \r\n',Apunkt, Apunkt+max(max(y))/tand(phi(i)), max(max(y)));
				elseif (phi(i) > 180)
					 fprintf(fid,'    \\draw[blue, dashed] (axis cs:%.2f,0) -- (axis cs:%.2f,-%.2f); \r\n',Apunkt, Apunkt-max(max(y))/tand(phi(i)-360), max(max(y)));
				elseif (phi(i) == 180)
					 fprintf(fid,'    \\draw[blue, dashed] (axis cs:%.2f,0) -- (axis cs:%.2f,0); \r\n',Apunkt, min(min(x)));
				end
		  end
		end
		fprintf(fid,'    %% Winkel der Asymptoten\r\n'); 
		for i=1:length(phi)
		  if (phi(i) < 180)
				fprintf(fid,'    \\draw[blue, thin] (axis cs:%.2f,0) ++(10mm,0) node[above, xshift=-4mm] {\\footnotesize$%d^\\circ$} arc (0:%d:10mm); \r\n',Apunkt, phi(i), phi(i));
		  elseif (phi(i) > 180)
				fprintf(fid,'    \\draw[blue, thin] (axis cs:%.2f,0) ++(10mm,0) node[below, xshift=-4mm] {\\footnotesize$%d^\\circ$} arc (0:%d:10mm); \r\n',Apunkt, phi(i)-360, phi(i)-360);
		  end
		end

		fprintf(fid,'    %% Wok-Äste\r\n');
		for i=1:size(r,1)
		fprintf(fid,'    \\addplot[black, very thick] table{%s};\r\n',strcat(path,'rlocus',num2str(i),'.txt'));
		end
		fprintf(fid,'    %% Pole\r\n');
		for i=1:length(p)
		  fprintf(fid,'    \\node at (axis cs:%d,%d) {\\small$\\times$};\r\n',real(p(i)), imag(p(i)));
		end
		fprintf(fid,'    %% Nullstellen\r\n');
		for i=1:length(z)
		  fprintf(fid,'    \\node at (axis cs:%d,%d){\\tikz\\draw[semithick] (0,0) circle(3pt);};\r\n',real(z(i)), imag(z(i)));
		end
		if G.Ts > 0
		 fprintf(fid,'    %% Einheitskreis\r\n');
		 fprintf(fid,'    \\draw[dashed] (0,0) circle(1);\r\n');
		end
		fprintf(fid,'  \\end{axis}\r\n');
		fprintf(fid,'\\end{tikzpicture}\r\n');
	catch me
	end
    fclose(fid);
	 if exist('me','var')
		 error(['Fehler beim Schreiben der Datei: ' me.message]);
	 end
end

end
