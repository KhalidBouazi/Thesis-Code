function exists = checkdoubledata(result,inputfieldnames,archivepath)

exists = false;

input = datastructbyfields(result,inputfieldnames);
datafromarchive = fromarchive(input,archivepath);
if ~isempty(datafromarchive)
    exists = true;
    disp('Double data: data already exists with this input. Data has not been added to archive.');
end