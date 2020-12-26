function combs = expcomb(n,p)

combs = zeros(1,n);
combs(end) = p(1);

while combs(end,1) ~= p(2)
    combs(end+1,:) = mono_between_next_grevlex(n,p(1),p(2),combs(end,:));
end

combs = fliplr(combs);

end