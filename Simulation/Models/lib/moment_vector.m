function mn = moment_vector(moment_vec, moment_position)
    if exist("moment_position", "var") == false
    moment_position = [0;0;0];
    end
    mn = struct();
    mn.vector   = moment_vec;
    mn.position = moment_position;
    
    end