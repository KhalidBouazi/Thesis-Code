function s = fillstruct(s,input)

f = fieldnames(input);

for i = 1:length(f)
    s.(f{i}) = input.(f{i}); 
end

end