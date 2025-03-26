
if ~exist("is_setup",   "var"); is_setup   = false; end



if ~is_setup


libraries = {"CoolProp", "MatlabBlenderIO"};

for index = 1:numel(libraries)
library = libraries{index};
[failiure, library_status] = system("pip show "+library);
if failiure
system("pip install "+library);
[failiure, library_status] = system("pip show "+library);
end

library_path = strip(extractBetween(string(library_status), "Location: ", "Requires:"))+"\"+library;
addpath(genpath(library_path));
disp(library +" loaded successfully.")
end

current_path = split(mfilename("fullpath"), '\');
addpath(genpath(fullfile(current_path{1:end-2})))

end


is_setup = true;
    