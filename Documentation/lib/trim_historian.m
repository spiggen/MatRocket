function instance = trim_historian(historian, range)


property_names = fieldnames(historian);
instance       = struct();

for property_index = 1:numel(property_names)
property_name = property_names{property_index};

if     isequal(class(historian.(property_name)), "struct")
      
      instance.(property_name) = trim_historian(historian.(property_name), range);

elseif isequal(class(historian.(property_name)), "double") || isequal(class(historian.(property_name)), "logical")
try
      
      subs = repmat({':'}, 1, ndims(historian.(property_name))); 
      subs{end} = range;
      instance.(property_name) = historian.(property_name)(subs{:});
      
catch ME
    warning("skipped "+property_name+" when trimming historian.")
    disp(ME.message)
end
elseif isequal(class(historian.(property_name)), "string")
      instance.(property_name) = historian.(property_name);

end

end