function datastruct = datastructbyfields(data,fields)

for i = 1:length(fields)
    datastruct.(fields{i}) = data.(fields{i});
end

end