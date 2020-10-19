function result = resultstruct(algorithm, structarray)

%% Cell arrays for specific fieldname order
inputfieldnames = {'algorithm','date','time','system','dt','timesteps','rank','delays','spacing'};
datafieldnames = {'t','measured','X','Y'};
svdfieldnames = {'H','U','s','V'};
reconstructionfieldnames = {'Y_','rmseY_'};
modecompfieldnames = {'Atilde','W','d','Phi','omega','b'};

dmdfieldnames = [inputfieldnames,datafieldnames,svdfieldnames,modecompfieldnames,reconstructionfieldnames];
havokfieldnames = [inputfieldnames,datafieldnames,svdfieldnames];
                 
%% Define fieldname order
if strcmp(algorithm,'DMD')
    fieldnameorder = dmdfieldnames;
elseif strcmp(algorithm,'HAVOK')
    fieldnameorder = havokfieldnames;
end            
         
%% Commbine structs from structarray to result struct
for i = 1:length(structarray)
    f = fieldnames(structarray{i});
    for j = 1:length(f)
        result.(f{j}) = structarray{i}.(f{j});
    end
end

%% Order entries according to filename order
result = orderfields(result,fieldnameorder);

end