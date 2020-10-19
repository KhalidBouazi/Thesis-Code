function datacellarray = databyfields(data,fields) 

fun = @(S,varargin) cellfun(@(f)S.(f),varargin,'un',0);

datacellarray = fun(data,fields{:});

end