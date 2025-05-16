function state_vector_derivative = obj2state_vector_derivative(obj)

state_vector_derivative = zeros(1,1);
vector_index = 1;

append_to_state_vector(obj);

function append_to_state_vector(obj)

if isfield(obj,"derivative")
    state_variables = obj.derivative.keys;
    
    for state_variable_index = 1:numel(obj.derivative.keys)
        state_variable                                     = state_variables{state_variable_index};
        variable                                           = obj.derivative(state_variable);
        num_el                                             = numel(variable);
        state_vector_derivative(vector_index:(vector_index+num_el-1),1) = reshape(variable, num_el,1);
        vector_index                                       = vector_index + num_el;
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