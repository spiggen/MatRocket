function [historian, jobtime] = solution2historian(initial_conditions, solution)
      

historian = create_historian(initial_conditions,numel(solution.x));

tic

for index = 1:numel(solution.x)

[~, rocket_instance] = system_equations(solution.x(:,index), solution.y(:,index), initial_conditions);
historian = record_history(rocket_instance, historian, index);
end

jobtime = toc;



end