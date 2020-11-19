function algdata = measure(algdata)
    
%% Fill field measured with default if empty
if isfield(algdata,'measured')
    if isempty(algdata.measured)
        algdata.measured = (1:size(algdata.X,1))';
    elseif size(algdata.measured,1) == 1
        algdata.measured = algdata.measured';
    end
else
    algdata.measured = (1:size(algdata.X,1))';
end

%% Extract state measurement
algdata.Y = algdata.X(algdata.measured,:);

end