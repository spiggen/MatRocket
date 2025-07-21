function rocket = base_UI_loading_bar(rocket)

persistent init
persistent loading_bar


if isempty(init)
loading_bar = waitbar(0,"Starting Simulation...");
init = false;
end
if randi(40) == 1
waitbar(rem(rocket.t, 1)/1, loading_bar, "Simulated time: T + "+string(rocket.t) + " s");
end
end