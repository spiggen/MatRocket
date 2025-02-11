function instance = query_historian(instance, historian, t, t_range)
if ~exist("t_range", "var"); t_range = historian.t; end % All internal calls/recursions include t_range, way to bypass all substructs having their own t-instance.

parameter_names = fieldnames(historian);
    
        for index = 1:numel(parameter_names)
        parameter = parameter_names{index};
        
        if isfield(instance, 'dont_record'); dont_record = sum(matches(instance.dont_record, parameter));
        else;                                dont_record = false;
        end

        if ~ dont_record
              if isequal(class(instance.(parameter)), 'double')
              
              instance.(parameter) = reshape(...
                                          makima(...
                                                 t_range, ...        
                                                 historian.(parameter), ...
                                                 t ...
                                                 ), ...
                                          height(instance.(parameter)),...
                                          []);
              
              elseif isequal(class(instance.(parameter)), 'struct')
              instance.(parameter) = query_historian(instance.(parameter), historian.(parameter), t, t_range);
              end

        else
              try
              instance.(parameter) = historian.(parameter);
              catch
              end
        end

    
        end
    
    end
    