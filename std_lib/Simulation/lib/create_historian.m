function [historian, instance] = create_historian(instance,history_length)


% Run single timestep to let system equations assign all the dependant
% parameters we want to extract later.
test_state = rocket2state_vector(instance);
[~,instance] = system_equations(0, test_state, instance);

[historian, instance] = create_historian_internal(instance, history_length);


    function [historian, instance] = create_historian_internal(instance, history_length)
    
    historian = struct();
    parameter_names = fieldnames(instance);
    
        for index = 1:numel(parameter_names)
            parameter = parameter_names{index};

            if isfield(instance, 'dont_record'); dont_record = ~(sum(matches(instance.dont_record, parameter)) == 0);
            else;                                dont_record = false; 
            end 

            if dont_record
                try
                    historian.(parameter) = instance.(parameter);
                catch
                end

            elseif (isequal(class(instance.(parameter)), 'double' ) || ...
                    isequal(class(instance.(parameter)), 'logical') ) && isequal(parameter, "null") == false 
                historian.(parameter) = zeros(numel(instance.(parameter)), history_length);
            elseif isequal(class(instance.(parameter)), 'struct')
                historian.(parameter) = create_historian_internal(instance.(parameter), history_length);
            else
            try
                historian.(parameter) = instance.(parameter);
            catch
            end
            end


        end
    end
end
