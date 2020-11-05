function c = cellelements2char(c)

for i = 1:size(c,1)
    for j = 1:size(c,2)
        tempc = c{i,j};        
        if isa(tempc,'double')
            [value,expcnt] = comma2exp(tempc);
            c{i,j} = expdoublearray2char(value,expcnt);
            %c{i,j} = doublearr2char(tempc);
        else
            c{i,j} = char(tempc);
        end
    end
end

end