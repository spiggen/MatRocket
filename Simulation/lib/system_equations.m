function [state_vector_derivative, rocket] = system_equations(t, state_vector, rocket)
% Ordinary differential equation governing the thrust, propulsion,
% tank-parameters and equations of motion of the rocket.




% Setup
rocket.t              = t;
rocket                = state_vector2obj (state_vector, rocket); % Unpacking the state-vector


%% Applying the rockets own models
for i = 1:numel(rocket.models)
apply_model = rocket.models{i};
rocket      = apply_model(rocket);
end

 state_vector_derivative = obj2state_vector_derivative(rocket);

end