function Y_ = dmdcreconstruct(A,B,U,Y0)

%% ...
Y_(:,1) = Y0;

%% Reconstruct dynamics
timesteps = cols(U);
for i = 2:timesteps
    Y_(:,i) = A*Y_(:,i-1) + B*U(:,i-1);
end

% rowsUinY = rowsHu - rows(U);
% delays = rowsUinY/rows(U);
% U0 = reshape(U(:,1:delays),rowsUinY,1);
% Y_(:,1) = [Y0; U0];
% for i = 2:timesteps-delays
%     Y_(:,i) = A*Y_(:,i-1) + B*U(:,i-1+delays);
% end

Y_ = real(Y_);
% Y_ = Y_(1:cols(Y0),:);

end