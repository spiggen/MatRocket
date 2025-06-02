function historian = create_historian(instance,history_length)


property_names = fieldnames(instance);
historian      = struct();

for property_index = 1:numel(property_names)
property_name = property_names{property_index};
if     isequal(class(instance.(property_name)), "struct"  ); historian.(property_name) = create_historian(      instance.(property_name)  , history_length );
elseif isequal(class(instance.(property_name)), "double") || ...
       isequal(class(instance.(property_name)), "logical" ); historian.(property_name) = NaN           ([size(instance.(property_name)) , history_length]);
elseif isequal(class(instance.(property_name)), "string"  ); historian.(property_name) = instance.(property_name);
end



end



