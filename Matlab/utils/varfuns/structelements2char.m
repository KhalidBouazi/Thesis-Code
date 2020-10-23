function s = structelements2char(s)

fields = fieldnames(s);

for i = 1:length(s)
    for j = 1:length(fields)
        tempc = s(i).(fields{j});        
        if isa(tempc,'double')
            [value,expcnt] = comma2exp(tempc);
            s(i).(fields{j}) = expdoublearray2char(value,expcnt);
            %s(i).(fields{j}) = doublearr2char(tempc);
        else
            s(i).(fields{j}) = char(tempc);
        end
    end
end

end