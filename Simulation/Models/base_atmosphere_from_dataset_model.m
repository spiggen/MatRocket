function rocket = base_atmosphere_from_dataset_model(rocket)

persistent init
persistent pressure
persistent temperature
persistent density
persistent speed_of_sound
persistent wind_velocity

% On startup
if isempty(init)


[~, is_url] = urlread(rocket.atmosphere.dataset);
if is_url
data_read = false;
while ~data_read
try
rawdata = webread(rocket.atmosphere.dataset);
data_read = true;
catch
warning("Timeout occurred while retrieving weather data... Trying again...")
end
end

else
rawdata = readtable(rocket.atmosphere.dataset);
end


raw_pressure       = rawdata.pressure_hPa         (1:end);
raw_altitude       = rawdata.geopotentialHeight_m (1:end);
raw_temperature    = rawdata.temperature_C        (1:end);
raw_wind_direction = rawdata.windDirection_degree (1:end);
raw_wind_magnitude = rawdata.windSpeed_m_s        (1:end);

nan_elements = isnan(raw_pressure) | isnan(raw_altitude) | isnan(raw_temperature) | isnan(raw_wind_direction) | isnan(raw_wind_magnitude);

raw_pressure       = raw_pressure      (~nan_elements);
raw_altitude       = raw_altitude      (~nan_elements);
raw_temperature    = raw_temperature   (~nan_elements);
raw_wind_direction = raw_wind_direction(~nan_elements);
raw_wind_magnitude = raw_wind_magnitude(~nan_elements);


raw_pressure       = [raw_pressure(1)       ; raw_pressure(:)      ];
raw_altitude       = [-1                    ; raw_altitude(:)      ];
raw_temperature    = [raw_temperature(1)    ; raw_temperature(:)   ];
raw_wind_direction = [raw_wind_direction(1) ; raw_wind_direction(:)];
raw_wind_magnitude = [raw_wind_magnitude(1) ; raw_wind_magnitude(:)];

air_molar_mass          = 28.97*1e-3;
R                       = 8.31446261815324;
celsius2kelvin          = 273.15;
air_specific_heat_ratio = 1.4;



pressure       = @(h) makima(raw_altitude, raw_pressure,    h)*1e2;
temperature    = @(h) makima(raw_altitude, raw_temperature, h)  + celsius2kelvin;
density        = @(h) pressure(h) * air_molar_mass/(R * (temperature(h)));
speed_of_sound = @(h) sqrt(air_specific_heat_ratio *pressure(h) / density(h) );
wind_velocity  = @(h) makima(raw_altitude, raw_wind_magnitude, h).*[sind(makima(raw_altitude, raw_wind_direction, h));
                                                                    cosd(makima(raw_altitude, raw_wind_direction, h));
                                                                    0];


init = false;
end


rocket.atmosphere.pressure       = pressure       (rocket.position(3));
rocket.atmosphere.temperature    = temperature    (rocket.position(3));
rocket.atmosphere.density        = density        (rocket.position(3));
rocket.atmosphere.speed_of_sound = speed_of_sound (rocket.position(3));
rocket.atmosphere.wind_velocity  = wind_velocity  (rocket.position(3));


end