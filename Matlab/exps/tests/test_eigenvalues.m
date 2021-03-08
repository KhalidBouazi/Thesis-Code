syms a1 a2 a3;

A = [0 1 0;0 0 1;a1 a2 a3];
I = eye(size(A));

A_ = A - I;

det(A-I)