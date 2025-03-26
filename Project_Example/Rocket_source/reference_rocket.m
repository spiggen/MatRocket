function rocket = reference_rocket()

    rocket                  = csv2obj('.\Rocket_source\reference_rocket.csv');
    rocket.name             = "reference_rocket";
    rocket.models           = {@equations_of_motion, ...
                               @propulsion_model,    ...
                               @aerodynamics_model,  ...
                               @gravity_model,       ...
                               @equations_of_motion    };


    rocket.derivative = containers.Map();
    
    rocket.is_body                      = true;
    
    %% Enviroment & physical constants
    
    rocket.enviroment                   = struct();
    rocket.enviroment.position          = [0;0;1];
    rocket.enviroment.g                 = 9.81;
    rocket.enviroment.temperature       = 282;
    rocket.enviroment.wind_velocity     = [0;0;0];
    
    
    [rocket.enviroment.temperature_COESA, ~, rocket.enviroment.pressure, ~] = atmoscoesa(0);
    
    
    %% Rigid-body model
    rocket.rigid_body                    = struct();
    rocket.rigid_body.is_body            = true;
    rocket.rigid_body.center_of_mass     = [-1.165;0.439;1412.385]*1e-3 + [0;0;2];
    rocket.rigid_body.mass               = 80;
    rocket.rigid_body.moment_of_inertia  = [ 6.166e10, -3.076e5,  -2.659e6;
                                            -3.076e5,   6.166e10, -2.382e6;
                                            -2.659e6,  -2.382e6,   2.067e8]*1e-9;
    

    rocket.attitude                      = eye(3);           rocket.derivative("attitude")         = zeros(3);
    rocket.angular_momentum              = zeros(3,1);       rocket.derivative("angular_momentum") = zeros(3,1);
    rocket.rotation_rate                 = zeros(3,1);      
    rocket.position                      = [0;0;0];          rocket.derivative("position")         = zeros(3,1);
    rocket.velocity                      = zeros(3,1);       rocket.derivative("velocity")         = zeros(3,1);
    
    % Creates the rocket.arodynamics-struct
    rocket                               = mesh2aerodynamics(rocket);

    rocket.engine.is_body                = true;
    rocket.engine.burn_time              = 15;
    rocket.engine.thrust_force           = 4e3;

    