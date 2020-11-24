function valid = checkinputvalidity(inputstruct)

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

%% ...


end