function cellarray = cellbyfields(data,fields) 

fun = @(S,varargin) cellfun(@(f)S.(f),varargin,'un',0);

cellarray = fun(data,fields{:});

end