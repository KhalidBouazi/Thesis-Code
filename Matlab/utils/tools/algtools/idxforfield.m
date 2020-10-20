function idxs = idxforfield(C,fields)

numf = length(fields);
idxs = zeros(numf,1);
for i = 1:length(numf)
    idxs(i) = find([C{:}] == fields{i});
end

end