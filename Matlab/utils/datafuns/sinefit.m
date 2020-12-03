function [RMSEy,rmsey,y_] = sinefit(y)

x = (0:length(y)-1);

ymax = max(y);
ymin = min(y);
yrange = ymax - ymin;                                           % Range of y
yshifted = y - ymax + yrange/2;
idxzerocross = x(yshifted .* circshift(yshifted,[0 1]) <= 0);   % Find zero-crossings
period = 2*mean(diff(idxzerocross));                            % Estimate period
ymean = mean(y);                                                % Estimate offset
fit = @(b,x)  b(1).*(sin(2*pi*x./b(2) + 2*pi/b(3))) + b(4);     % Function to fit
fcn = @(b) sum((fit(b,x) - y).^2);                              % Least-Squares cost function
s = fminsearch(fcn, [yrange;  period;  -1;  ymean]);            % Minimise Least-Squares
y_ = fit(s,x);
figure(1)
plot(x,y,'b',x,y_,'r')
grid
[RMSEy,rmsey] = rmse(y,y_);

end