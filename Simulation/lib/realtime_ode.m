function [solution] = realtime_ode(dvdt, t_span, v_init, time_dialation, record_spacing)
% realtime_ode is a 2'nd order Adam-Bashforth ODE-solver with a timestep synced with reality.
if ~exist("time_dialation", "var"); time_dialation = 1;  end
if ~exist("record_spacing", "var"); record_spacing = 1;  end

dt             = 1e-3;
t_max          = t_span(2);
t              = t_span(1);
v              =  v_init;
t_list         = zeros(1        , 1000);
v_list         = zeros(height(v), 1000);
index          = 1;
record_index   = 1;
dvdt_current   = dvdt(t,v);
alpha          = [3/2, -1/2];

while t < t_max
tic
dvdt_previous = dvdt_current;
dvdt_current  = dvdt(t,v);

v      = v + (dvdt_current*alpha(1) + dvdt_previous*alpha(2))*dt;
t      = t+dt;
index  = index+1;

if rem(index, record_spacing) == 0
t_list(:,record_index) = t;
v_list(:,record_index) = v;
record_index    = record_index+1;

if record_index == width(t_list)
v_list(1, record_index+1000) = 0;
t_list(1, record_index+1000) = 0;
end

end

dt     = toc*time_dialation;



end

t_list = t_list(:,1:record_index);
v_list = v_list(:,1:record_index);

solution = struct();
solution.x = t_list;
solution.y = v_list;

end

