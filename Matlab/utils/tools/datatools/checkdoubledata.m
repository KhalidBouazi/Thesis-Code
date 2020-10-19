function exists = checkdoubledata(result,filename)

if isfile(filename)
    m = matfile(filename,'Writable',true);
    data = m.([algorithm 'data']);
    
else
    exists = false;
end