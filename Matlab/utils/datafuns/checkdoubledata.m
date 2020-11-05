function [exists,idx] = checkdoubledata(result,inputfieldnames,archivepath)

input = structbyfields(result,inputfieldnames);
[datafromarchive,idx] = fromarchive(input,archivepath);
exists = ~isempty(datafromarchive);

end