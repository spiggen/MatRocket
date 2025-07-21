function [state_vector_derivative, rocket] = system_equations(t, state_vector, rocket)


rocket.t = t;
rocket   = state_vector2rocket (state_vector, rocket); % Unpacking the state-vector


%% Applying the rockets own models
for i = 1:numel(rocket.models)    
apply_model = rocket.models{i};
rocket      = apply_model(rocket);
end

state_vector_derivative = derivative2vector(rocket.derivative);

end