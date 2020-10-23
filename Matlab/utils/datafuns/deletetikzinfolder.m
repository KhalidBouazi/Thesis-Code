function deletetikzinfolder(path)

filepattern = fullfile(path, '*.tikz'); % Change to whatever pattern you need.
files = dir(filepattern);
for k = 1 : length(files)
    baseFileName = files(k).name;
    fullFileName = fullfile(path, baseFileName);
    fprintf(1, 'Now deleting %s\n', fullFileName);
    delete(fullFileName);
end

end