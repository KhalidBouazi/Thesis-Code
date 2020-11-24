function [exists,idx] = structexists(s,inputs)

exists = false;
idx = 0;

for i = 1:length(s)
    if isequal(s{i},inputs)
        exists = true;
        idx = i;
        return;
    end
end

end