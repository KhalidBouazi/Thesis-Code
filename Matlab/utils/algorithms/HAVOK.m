function algstruct = HAVOK(algstruct)

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

    [U,S,V] = truncsvd(H,algstruct(i).rank);

    % [V,dV] = cendiff4(V,algstruct(i).dt);
    % X = V\dV;
    % A = X(1:end-1,1:end-1)';
    % B = X(end,1:end-1)';

    % Save in algstruct(i)
    algstruct(i).algorithm = "HAVOK";
    algstruct(i).H = H;
    algstruct(i).U = U;
    algstruct(i).s = diag(S);
    algstruct(i).V = V;
    % algstruct(i).dV = dV;
    % algstruct(i).A = A;
    % algstruct(i).B = B;
    
end

end