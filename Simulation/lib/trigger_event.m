function trigger_event(name)
evalin("base", name+" = struct();");
evalin("base", name+".triggered = true;");
evalin("base", name+".executed  = false;");
end