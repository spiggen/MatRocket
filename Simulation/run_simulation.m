function [rocket_historian,job] = run_simulation(rocket, job)
%% run_simulation(rocket, (job) )
%
% Parameter             : Class                 : Default                   :   Description             
%___________________________________________________________________________________________________________________
% job                   : struct                : N/A                       :   specify how the job should be run
% job.is_done           : boolean               : false                     :   usually false, true if job is complete. Will not run of false.
% job.ode_solver        : @ode45, @ode23t, ...  : @ode45                    :   which solver should be used for the simulation   
% job.t_max             : float                 : 80                        :   simulation end time   
%
% [NOTE!] Latest sim auto-saves to "./latest_mat". You have no choise in the matter, as it's no fun to run a 
% 10h+ sim and realize after the fact that you didn't turn saving on, loosing you all your work. The latest_sim file is over-
% written every time a simulation is run, it just allows you to save your sim post mortem.


setup;

if ~exist  ("job", "var");       job              = struct();                   end
if ~isfield (job, "t_max");      job.t_max        = 80;                         end   
if ~isfield (job, "ode_solver"); job.ode_solver   = @ode45;                     end


    

    %% Simulation:

    tic


    disp    ("Simulating...")
    
    initial_state_vector = rocket2state_vector(rocket);
    [~, initial_rocket]  = system_equations(0, initial_state_vector, rocket); % [NOTE!] Due to recursion-structure, the rocket gotten out of ODE is not meant to be fed back into the ODE.
    % Solve ODE initial value problem.
    t_range = [0, job.t_max];
    
    solution   = job.ode_solver( @(t,state_vector) system_equations(t,state_vector,rocket), t_range,  initial_state_vector);
    
    job.simulation_time = toc;
    job.simulated = true;

    disp  ("Simulating/Done.")




    %% Post-processing:
        
    disp    ("Post-processing...")


    rocket_historian = create_historian(initial_rocket,numel(solution.x));

    tic

    for index = 1:numel(solution.x)

    [~, rocket_instance] = system_equations(solution.x(:,index), solution.y(:,index), initial_rocket);
    rocket_historian = record_history(rocket_instance, rocket_historian, index);
    end

    post_processing_time = toc;
    
    disp  ("Post-processing/Done.")

    save(genpath("./latest_sim.mat"), "rocket_historian", "job");



    
job.is_done = true;
    
