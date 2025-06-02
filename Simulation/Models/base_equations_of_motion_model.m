function rocket = base_equations_of_motion_model(rocket)
    % computing the motion of the rocket.
    
    if rocket.position(3) < 0; rocket.position(3) = 0; end % fix atmocoesa warning

    % Pre-recursion:
    rocket.attitude = orthonormalize(rocket.attitude);

    rocket.wind_velocity_absolute = rocket.atmosphere.wind_velocity - rocket.velocity;
    
    rocket.rotation_rate = (rocket.attitude*rocket.rigid_body.moment_of_inertia*(rocket.attitude'))\rocket.angular_momentum; 
    
    rotation_rate_tensor = [  0                       -rocket.rotation_rate(3)        rocket.rotation_rate(2);
                              rocket.rotation_rate(3)  0                             -rocket.rotation_rate(1);
                             -rocket.rotation_rate(2)  rocket.rotation_rate(1)        0                      ];
    
    
    
    % Recursion:
    rocket = equations_of_motion_recursor(rocket);
    rocket.center_of_mass_absolute = rocket.center_of_mass_absolute - rocket.position;


    
    % Post-recursion:
    force_sum  = rocket.attitude* rocket.force_absolute.vector;
    moment_sum = rocket.attitude*(rocket.moment_absolute.vector) + cross(rocket.attitude*rocket.force_absolute.position - rocket.center_of_mass_absolute, rocket.attitude*rocket.force_absolute.vector);
   
    rocket.acceleration = force_sum/rocket.mass_absolute;

    rocket.derivative("position") = rocket.velocity;
    rocket.derivative("velocity") = rocket.acceleration;
    
    attitude_derivative = rotation_rate_tensor*rocket.attitude;
    
    
    rocket.derivative("angular_momentum")   = moment_sum;
    rocket.derivative("attitude")           = attitude_derivative;
    
    










    function [component] = equations_of_motion_recursor(component)
        % Pre-recursion:

    if isfield(component, 'is_body')
    if component.is_body

        component = assign_body_parameters_if_unassigned(component);



        % recursion:

        children = fieldnames(component);

        for child_index = 1:numel(children)
        
        child = children{child_index};
        if isequal(class(component.(child)), 'struct')
        if isfield(component.(child), 'is_body')
        if component.(child).is_body

        component.(child) = assign_body_parameters_if_unassigned(component.(child));

        %% Parent to child communication:
        % Going from parent to child, since the parent properties are in the grandparents basis,
        % and the properties under child are in the parents basis, it means that the base change needs to be from grandparent to parent,
        % i.e multiplication with the parents attitude-matrix inverse, ie component.attitude'
        
        component.(child).rotation_rate_absolute    = (component.attitude')*component.rotation_rate_absolute + component.(child).rotation_rate;
        component.(child).wind_velocity_absolute    = (component.attitude')*component.wind_velocity_absolute + cross((component.attitude')*component.rotation_rate_absolute, component.(child).position);




        component.(child) = equations_of_motion_recursor(component.(child));



        %% Child to parent communication:
        % Going from child to parent, since all the childs properties are in the parents basis, and need to be in grandparents basis,
        % the base change becomes the parents attitude-matrix, ie component.attitude
        
        % Bringing the center of mass into parents basis
        component.center_of_mass_absolute = (component.center_of_mass_absolute*component.mass_absolute + (component.position + component.attitude*component.(child).center_of_mass_absolute)*component.(child).mass_absolute)/ ...
                                                                             ((component.mass_absolute +                                                                                     component.(child).mass_absolute) + ...
                                                                             ((component.mass_absolute +                                                                                     component.(child).mass_absolute) == 0)*10);

        component.mass_absolute           =                                    component.mass_absolute +                                                                                     component.(child).mass_absolute;

        component.force_absolute          = force_vector( component.force_absolute .vector + component.(child).attitude*component.(child).force_absolute .vector, ...
                                                          [0;0;0]);
        component.moment_absolute         = moment_vector(component.moment_absolute.vector + component.(child).attitude*component.(child).moment_absolute.vector + cross(component.(child).position, component.(child).attitude*component.(child).force_absolute.vector), ...
                                                          [0;0;0]);

        end
        end
        end
        end

    end
    end
    
    end

    function body = assign_body_parameters_if_unassigned(body)

        if ~isfield(body, "assigned_body_parameters")
        % Checking if certain paramters exist, if not it assigns them
        if ~isfield(body, 'position'                  ); body.position                    = zeros(3,1)                                   ; end
        if ~isfield(body, 'mass'                      ); body.mass                        = 0                                            ; end
        if ~isfield(body, 'wind_velocity_absolute'    ); body.wind_velocity_absolute      = zeros(3,1)                                   ; end
        if ~isfield(body, 'rotation_rate'             ); body.rotation_rate               = zeros(3,1)                                   ; end       
        if ~isfield(body, 'rotation_rate_absolute'    ); body.rotation_rate_absolute      = body.rotation_rate                           ; end        
        if ~isfield(body, 'forces'                    ); body.forces                      = struct("Null",force_vector( [0;0;0],[0;0;0])); end
        if ~isfield(body, 'moments'                   ); body.moments                     = struct("Null",moment_vector([0;0;0],[0;0;0])); end
        if ~isfield(body, 'attitude'                  ); body.attitude                    = eye(3);                                        end
        
        body.assigned_body_parameters = true;
        end
        
        % Mandatory parameter-reassignment and overwriting of old parameters
        if isfield(body, "center_of_mass"); body.center_of_mass_absolute = body.center_of_mass;
        else;                               body.center_of_mass_absolute = body.position;
        end
        body.mass_absolute           = body.mass;

        
        body.force_absolute          = force_vector (cellsum(cellfun( @(force)       body.forces .(force ).vector                                 ,   fieldnames(body.forces ), 'UniformOutput', false)), [0;0;0]);
        body.moment_absolute         = moment_vector(cellsum(cellfun( @(moment)      body.moments.(moment).vector                                 ,   fieldnames(body.moments), 'UniformOutput', false)) + ...
                                                     cellsum(cellfun( @(force) cross(body.forces .(force ).position, body.forces.(force ).vector) ,   fieldnames(body.forces ), 'UniformOutput', false)), [0;0;0]);


    end

end

