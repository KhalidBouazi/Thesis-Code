function algstruct = DMD(algstruct)

%% Check obligatory and optional function arguments
oblgfunargs = {'Y','dt'};
optfunargs = {'rank','delays','spacing'};
optargvals = {[],1,1};
algstruct = checkandfillfunargs(algstruct,oblgfunargs,optfunargs,optargvals);

%% Run for every algorithm combination
for i = 1:length(algstruct)
    
    dispalgnr(i);

    % Start algorithm
    H = hankmat(algstruct(i).Y,algstruct(i).delays,algstruct(i).spacing);
    X = H(:,1:end-1);
    Xp = H(:,2:end);

    [U,S,V] = truncsvd(X,algstruct(i).rank);

    Atilde = S\U'*Xp*V;
    [W,D] = eigdec(Atilde);
    Phi = Xp*V/S*W/D;
    Phi = Phi(1:size(algstruct(i).Y,1),:);
    omega = log(diag(D))/algstruct(i).dt;
    b = (W*D)\(S*V(1,:)');

    % Save in algstruct(i)
    algstruct(i).algorithm = "DMD";
    algstruct(i).H = H;
    algstruct(i).U = U;
    algstruct(i).s = diag(S);
    algstruct(i).V = V;
    algstruct(i).Atilde = Atilde;
    algstruct(i).W = W;
    algstruct(i).d = diag(D);
    algstruct(i).Phi = Phi;
    algstruct(i).omega = omega;
    algstruct(i).b = b;
    
end

end