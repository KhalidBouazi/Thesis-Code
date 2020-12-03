function exists = isincell(c,inputc)

exists = false;

for i = 1:length(c)
    if isequal(c{i},inputc)
        exists = true;
        return;
    end
end

end