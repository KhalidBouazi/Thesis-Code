function s = structelements2char(s)

f = fieldnames(s);

for i = 1:length(s)
    for j = 1:length(f)
        tempc = s(i).(f{j});        
        if isa(tempc,'double')
            [value,expcnt] = comma2exp(tempc);
            s(i).(f{j}) = expdoublearray2char(value,expcnt);
        elseif isa(tempc,'cell') && ~isa(tempc{1},'struct')
            cellaschar = cellelements2char(tempc);
            s(i).(f{j}) = [sprintf('%s,',cellaschar{1:end-1}),cellaschar{end}];
        elseif isa(tempc,'cell') && isa(tempc{1},'struct') % TODO
            result = {};
            for k = 1:length(tempc)
                tempf = fieldnames(tempc{k});
                result = [result, tempc{k}.(tempf{1})]; % Just first field of struct
            end
            cellaschar = cellelements2char(result);
            s(i).(f{j}) = [sprintf('%s,',cellaschar{1:end-1}),cellaschar{end}];
        else
            s(i).(f{j}) = char(tempc);
        end
    end
end

end