function tf = check_event(name)

try    event_triggered = evalin("base", name+".triggered;");
catch; event_triggered = false;
end

try    event_executed = evalin("base", name+".executed;");
catch; event_executed = false;
end


if event_triggered && ~ event_executed; evalin("base", name+".executed = true;"); tf = true; 
else;                                                                             tf = false;
end

end