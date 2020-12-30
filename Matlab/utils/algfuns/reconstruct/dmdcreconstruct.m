function Y_ = dmdcreconstruct(A,B,U,Y0)

%% ...
Y_(:,1) = Y0;

%% Reconstruct dynamics
timesteps = cols(U);
for i = 2:timesteps
    Y_(:,i) = A*Y_(:,i-1) + B*U(:,i-1);
end

% for i = 2:timesteps-rows(Y0)-1
%     Y_(:,i) = A*Y_(:,i-1) + B*U(:,i+rows(Y0)-1);
% end

Y_ = real(Y_);

end