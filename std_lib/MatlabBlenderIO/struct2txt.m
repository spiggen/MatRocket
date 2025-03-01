function struct2txt(filename, historian, times)

if exist("times", "var"); historian = query_historian(historian, historian, times); end

File = fopen(filename, 'w');
fclose(File);
path_elements = split(filename, ["/", "//", "\", "\\"]);
path = replace(filename, path_elements(end),"");

write_branches("rocket", historian);


    function write_branches(trace, branches)
        branch_names = fieldnames(branches);
        for branch_index = 1:numel(branch_names)
            branch_name = branch_names{branch_index};

            if isequal(branch_name, "mesh"); copyfile(branches.(branch_name), path); end

            writematrix(trace+"."+branch_name, filename, "delimiter", ",", 'WriteMode','append');

            if     isequal(class(branches.(branch_name)), "struct"); write_branches(trace+"."+branch_name, branches.(branch_name));
            elseif isequal(class(branches.(branch_name)), "double"); writematrix(       branches.(branch_name) , filename, "delimiter", ",", 'WriteMode','append');
            else; try                                                writematrix(string(branches.(branch_name)), filename, "Delimiter", ",", 'WriteMode','append');
                  catch;                                             writematrix("MISSING",                      filename, "Delimiter", ",", 'Writemode','append');
                  end
            end
        end


    end

end