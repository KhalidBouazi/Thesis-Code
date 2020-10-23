function [value,expcnt] = comma2exp(value)

m = length(value);
expcnt = zeros(m,1);

%% For arrays more than 2 decimal places error raises
% if m > 1
%     value = round(value*100)/100; % Take first 2 decimal places
% end

%% Create exponential representation of value
for i = 1:m
    % If value has decimal values
    isnotexp = (value(i) - floor(value(i))) > 0;
    
    % If value is integer and has zeros at the end
    hasdec = (value(i)/10 - floor(value(i)/10)) == 0;
    
    % If value hasdec, but has less than 3 digits 
    if length(num2str(value(i))) < 3
        hasdec = false;
    end
    
    % Remove decimal values and replace with e^n
    while isnotexp
        value(i) = 10*value(i);
        expcnt(i) = expcnt(i) - 1;
        isnotexp = (value(i) - floor(value(i))) > 0 && length(num2str(round(value(i)))) < 3;
    end
    value(i) = round(value(i));
    
    % Remove zeros and replace with e^n
    while hasdec
        value(i) = value(i)/10;
        expcnt(i) = expcnt(i) + 1;
        hasdec = (value(i)/10 - floor(value(i)/10)) == 0;
    end
end

end