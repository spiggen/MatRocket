function [rocket] = base_gravity_model(rocket)

    rocket.forces.Gravity = force_vector((rocket.attitude')*rocket.enviroment.g*rocket.mass_absolute*[0;0;-1], ...
                                         (rocket.attitude')*rocket.center_of_mass_absolute);


end