function Y_ = kmdreconstruct(Phi,D,v,timesteps)

D_ = eye(size(D));
for i = 1:timesteps
    Y_(:,i) = real(Phi*D_*v);
    D_ = D_*D;
end

end