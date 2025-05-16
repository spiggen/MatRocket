function [rocket_historian,job] = run_simulation(rocket, job)
%% run_simulation(rocket, (job) )
%
% Parameter             : Class                 : Default                   :   Description             
%___________________________________________________________________________________________________________________
% job                   : struct                : N/A                       :   specify how the job should be run
% job.is_done           : boolean               : false                     :   usually false, true if job is complete. Will not run of false.
% job.ode_solver        : @ode45, @ode23t, ...  : @ode45                    :   which solver should be used for the simulation   
% job.t_max             : float                 : 80                        :   simulation end time   


setup;

if ~exist  ("job", "var");       job              = struct();                   end
if ~isfield (job, "t_max");      job.t_max        = 80;                         end   
if ~isfield (job, "ode_solver"); job.ode_solver   = @ode45;                     end

assignin("base", "current_job", job);

    %% Simulation:

    tic

    
    disp("Simulating...")
    
    initial_state_vector = obj2state_vector(rocket);
    [~, initial_rocket]  = system_equations(0, initial_state_vector, rocket); % [NOTE!] Due to recursion-structure, the rocket gotten out of ODE is not meant to be fed back into the ODE.
    
    if isfield(rocket, "events"); options = odeset("Events", rocket.events); 
    else                          options = odeset();
    end
    
    % Solve ODE initial value problem.
    t_range = [0, job.t_max];
    
    solution   = job.ode_solver( @(t,state_vector) system_equations(t,state_vector,rocket), t_range,  initial_state_vector);
    
    job.simulation_time = toc;
    job.simulated = true;

    disp("Simulating/Done.")




    %% Post-processing:
        

    disp("Post-processing...")

    [rocket_historian, job.post_processing_time] = solution2historian(initial_rocket, solution);

    disp("Post-processing/Done.")



    
job.is_done = true;
    
