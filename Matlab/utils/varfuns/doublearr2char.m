function c = doublearr2char(arr)

if length(arr) > 1
    c = '[';
    for i = 1:size(arr,1)
         c = [c num2str(arr(i,:)) ';'];
    end
    c(end) = ']';
else
    c = char(string(arr));
end

end