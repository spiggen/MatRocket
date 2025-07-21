function rocket = base_atmosphere_model(rocket)
[t,c,p,rho] = atmoscoesa(rocket.position(3));

rocket.atmosphere.temperature    = t;
rocket.atmosphere.speed_of_sound = c;
rocket.atmosphere.pressure       = p;
rocket.atmosphere.density        = rho;


if ~isfield(rocket.atmosphere, "wind_velocity")
rocket.atmosphere.wind_velocity = [0;0;0];
end



end