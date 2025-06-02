function rocket = base_atmosphere_model(rocket)

[rocket.atmosphere.temperature,rocket.atmosphere.speed_of_sound,rocket.atmosphere.pressure,rocket.atmosphere.density] = atmoscoesa(rocket.position(3));

if ~isfield(rocket.atmosphere, "wind_velocity")
rocket.atmosphere.wind_velocity = [0;0;0];
end



end