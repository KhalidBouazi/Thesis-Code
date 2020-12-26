function [valid,inputstruct] = checkinputvalidity(inputstruct,config)

valid = true;

%% Check if delay dimension was chosen appropriately
spacingx = inputstruct.spacing(1);
spacingy = inputstruct.spacing(2);
timesteps = inputstruct.timesteps;
delays_ = 1 + spacingy*inputstruct.delays;
Hwidth = ceil((timesteps-delays_+1)/spacingx);

if Hwidth < 1
    valid = false;
    return;
end

%% Delete unnecessary struct fields
algorithm = inputstruct.algorithm;
inputfields = config.(lower(algorithm)).fieldnames.input;
f = fieldnames(inputstruct);

for i = 1:length(f)
    if ~any(strcmp(inputfields,f{i}))
        inputstruct = rmfield(inputstruct,f{i});
    end
end

end