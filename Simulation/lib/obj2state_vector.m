function state_vector = obj2state_vector(obj)



vector_index    = 1; state_vector = zeros(1, 1);

append_to_state_vector(obj);

function append_to_state_vector(obj)

if isfield(obj,"derivative")
state_variables = obj.derivative.keys;

for state_variable_index = 1:numel(obj.derivative.keys)
    state_variable                                       = state_variables{state_variable_index};
    variable_address                                     = num2cell(split(state_variable, ".")); 
    if isequal(class(variable_address{1}), "cell"); variable_address = cellfun(@(entry) entry{1}, variable_address, "UniformOutput", false); end
    variable                                             = getfield(obj, variable_address{:});
    num_el                                               = numel(variable);
    state_vector(vector_index:(vector_index+num_el-1),1) = reshape(variable, num_el,1);
    vector_index                                         = vector_index + num_el;
end
end

children = fieldnames(obj);

for child_index = 1:numel(children)
child_name = children{child_index};
if isequal(class(obj.(child_name)), "struct")
append_to_state_vector(obj.(child_name));
end
end

end
end