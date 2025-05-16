function rocket = loading_bar_update(rocket)


%% Updating loading-bar:
if randi(40) == 1 && rocket.t < evalin("base", "current_job.t_max;") - 0.1
    try
    loading_bar = evalin("base", "loading_bar;");
    waitbar(rocket.t/evalin("base", "current_job.t_max;"),loading_bar, "Simulating: "+string(rocket.t)+"s / "+string(evalin("base", "current_job.t_max;")) +"s");
    catch
    evalin  ("base", "loading_bar = waitbar(0, 'Simulating:');");
    loading_bar = evalin("base", "loading_bar;");
    waitbar(rocket.t/evalin("base", "current_job.t_max;"),loading_bar, "Simulating: "+string(rocket.t)+"s / "+string(evalin("base", "current_job.t_max;")) +"s");
    end
    
end

if rocket.t > evalin("base", "current_job.t_max;") - 0.1
    try
        loading_bar = evalin("base", "loading_bar;");
        close(loading_bar)
    catch
    end 
end