function historian = record_history(instance, historian, history_index)

property_names = fieldnames(historian);

for property_index = 1:numel(property_names)
property_name = property_names{property_index};

if     isequal(class(instance.(property_name )), "struct"  )

       historian.(property_name)               = record_history(instance.(property_name), historian.(property_name), history_index);

elseif isequal(class(instance .(property_name)), "double"  )  || ...
       isequal(class(instance .(property_name)), "logical" )

       indexCell                               = repmat({':'}, 1, ndims(historian.(property_name)));
       indexCell{end}                          = history_index;
       historian.(property_name)(indexCell{:}) = instance.(property_name);

end



end
end





   










