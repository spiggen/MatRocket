function rocket = propulsion_model(rocket)


if rocket.t < rocket.engine.burn_time; rocket.engine.nozzle.forces.Thrust = force([0;0;1]*rocket.engine.thrust_force, [0;0;0]); rocket.engine.active_burn = true;
else;                                  rocket.engine.nozzle.forces.Thrust = force([0;0;0],                            [0;0;0]); rocket.engine.active_burn = false;
end