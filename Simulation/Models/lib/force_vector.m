function fc = force_vector(force_vec, force_position)
if exist("force_position", "var") == false
force_position = [0;0;0];
end
fc = struct();
fc.vector   = force_vec;
fc.position = force_position;

end