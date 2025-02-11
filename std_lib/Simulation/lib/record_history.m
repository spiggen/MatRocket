function historian = record_history(instance, historian, history_index)




parameter_names = fieldnames(historian);

for parameter_index = 1:numel(parameter_names)
parameter = parameter_names{parameter_index};

if isfield(instance, 'dont_record'); dont_record = sum(matches(instance.dont_record, parameter));
else;                                dont_record = false;
end


if ~ dont_record
if     isequal(class(instance.(parameter)), 'double') || ...
       isequal(class(instance.(parameter)), 'logical'); historian.(parameter)(:,history_index) = reshape(instance.(parameter), ...
                                                                                                 numel  (instance.(parameter)), ...
                                                                                                 1);
elseif isequal(class(instance.(parameter)), 'struct');  historian.(parameter) = record_history(instance.(parameter), historian.(parameter), history_index);
end
end

end



   










