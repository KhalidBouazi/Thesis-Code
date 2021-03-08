function [A_,B_] = oneinputsys(A,B,Nu,d)

if cols(B) > 1
%     O_ = zeros(cols(B)-2*Nu,Nu);
%     I1_ = fliplr(blkdiag(fliplr(eye(cols(B)-2*Nu)),zeros(Nu)));
%     I2_ = [O_; eye(Nu)];
%     B1_ = B(:,1:end-Nu);
%     B2_ = B(:,end-Nu+1:end);
%     O_ = zeros(rows(I1_),cols(A));
    I1_ = fliplr(blkdiag(fliplr(eye(Nu*(d-2))),zeros(Nu*(d>1))));
    I2_ = [zeros(Nu*(d-2),Nu); eye(Nu*(d>1))];
    if d > 1
        B1_ = B(:,1:end-Nu*(d>1));
        B2_ = B(:,end-Nu+1:end);
    else
        B1_ = [];
        B2_ = B; 
    end
    O_ = zeros(rows(I1_),cols(A));
else
    I1_ = [];
    I2_ = [];
    B1_ = [];
    B2_ = B;
    O_ = [];
end

A_ = [A, B1_;
      O_, I1_];
B_ = [B2_; I2_];

end