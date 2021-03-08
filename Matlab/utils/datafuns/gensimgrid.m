function c = gensimgrid(x,y,steps)

xmin = x(1);
xmax = x(2);
ymin = y(1);
ymax = y(2);
dx = (xmax - xmin)/(steps - 1);
dy = (ymax - ymin)/(steps - 1);

a = xmin:dx:xmax;
b = ymin:dy:ymax;

[A, B]=ndgrid(a,b);
d = [A(:),B(:)];

c = {};
for i = 1:rows(d)
    if d(i,1) == xmax || d(i,1) == xmin || d(i,2) == ymax || d(i,2) == ymin
        c{end+1} = d(i,:);
    end
end

end