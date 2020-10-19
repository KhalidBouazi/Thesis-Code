function E =  rmse(X,X_)

E = sqrt(mean((X - X_).^2,2));

end