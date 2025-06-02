function rocket = base_propulsion_model(rocket)


if rocket.t < rocket.engine.burn_time; rocket.engine.forces.Thrust = force_vector([0;0;1]*rocket.engine.thrust_force, [0;0;0]); rocket.engine.active_burn = true;
else;                                  rocket.engine.forces.Thrust = force_vector([0;0;0],                            [0;0;0]); rocket.engine.active_burn = false;
end

