function c = structarr2cell(s)

c = cell(length(s),length(fieldnames(s)));

for i = 1:length(s)
    c(i,:) = struct2cell(s(i))';
end

end