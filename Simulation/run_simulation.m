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
    
    clear simulation_logger

    tic


    disp    ("Simulating...")
    
    initial_state_vector = rocket2state_vector(rocket);
    t_range = [0, job.t_max];
    
    job.ode_solver( @(t,state_vector) system_equations(t,state_vector,rocket), t_range,  initial_state_vector);
    
    job.simulation_time = toc;
    job.simulated = true;

    disp  ("Simulating/Done.")

    rocket_historian = simulation_logger();

    
job.is_done = true;
    
