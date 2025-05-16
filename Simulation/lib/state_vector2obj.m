function obj       = state_vector2obj(state_vector, obj)



vector_index    = 1;

obj = read_from_state_vector(obj);

function obj = read_from_state_vector(obj)

if isfield(obj,"derivative")
state_variables = obj.derivative.keys;

for state_variable_index = 1:numel(obj.derivative.keys)
    state_variable                                     = state_variables{state_variable_index};
    variable_address                                   = num2cell(split(state_variable, "."));
    if isequal(class(variable_address{1}), "cell"); variable_address = cellfun(@(entry) entry{1}, variable_address, "UniformOutput", false); end
    variable                                           = getfield(obj, variable_address{:});
    num_el                                             = numel(variable);
    obj                                                = setfield(obj, variable_address{:}, reshape(state_vector(vector_index:vector_index+num_el-1), size(variable) ) );
    vector_index                                       = vector_index + num_el;
end
end

children = fieldnames(obj);

for child_index = 1:numel(children)
child_name = children{child_index};
if isequal(class(obj.(child_name)), "struct")
obj.(child_name) = read_from_state_vector(obj.(child_name));
end
end

end
end



%{
vector_index    = 1;
state_variables = obj.derivative.keys;
for state_variable_index = 1:numel(obj.derivative.keys)
state_variable                                     = state_variables{state_variable_index};
variable_address                                   = num2cell(split(state_variable, "."));
if isequal(class(variable_address{1}), "cell"); variable_address = cellfun(@(entry) entry{1}, variable_address, "UniformOutput", false); end
variable                                           = getfield(obj, variable_address{:});
num_el                                             = numel(variable);
obj                                             = setfield(obj, variable_address{:}, reshape(state_vector(vector_index:vector_index+num_el-1), size(variable) ) );
vector_index                                       = vector_index + num_el;
end

end
%}