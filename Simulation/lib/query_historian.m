function instance = query_historian(historian, t, t_range)
if ~exist("t_range", "var"); t_range = historian.t; end % All internal calls/recursions include t_range, way to bypass all substructs having their own t-instance.



property_names = fieldnames(historian);
instance       = struct();

for property_index = 1:numel(property_names)
property_name = property_names{property_index};

if     isequal(class(historian.(property_name)), "struct")
      
      instance.(property_name) = query_historian(historian.(property_name), t, t_range);

elseif isequal(class(historian.(property_name)), "double") || isequal(class(historian.(property_name)), "logical")
try
      instance.(property_name) = makima( ...
                                        reshape(t_range, numel(t_range), 1), ...
                                        historian.(property_name), ...
                                        t ...
                                       );
      
catch
end
elseif isequal(class(historian.(property_name)), "string")
      instance.(property_name) = historian.(property_name);

end



                                                                                          

%      catch
%      end
end







end


%{
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
%}