

if ~exist("root_depth", "var"); root_depth = 3;     end
if ~exist("is_setup",   "var"); is_setup   = false; end
    
if ~is_setup
    %% Adding paths to sub-folders and main library:
    fullpath = erase(which(mfilename('fullpath')), 'Project_Example\setup.m');
    fullpath_parts    = split(fullpath, '\');
    
    tree_root         = fullfile(fullpath_parts{1:(numel(fullpath_parts)-root_depth)});
    root_library_list = dir(fullfile(tree_root,'**','\MatRocket'));
   
root_library_paths = {""};
numpaths = 0;
for index = 1:numel(root_library_list)
if ~any(strcmp(root_library_paths, root_library_list(index).folder))
    numpaths = numpaths+1; root_library_paths{numpaths} = root_library_list(index).folder; % Suppress warning -u_-u
end
end

if isequal(numel(root_library_paths), 1)
    root_library_path_number = 1;   
else
    is_valid = false;
    while ~is_valid
    try
    disp("You have multiple instances of MatRocket on your computer. Which instance do you want to use?")
    for i = 1:numel(root_library_paths); disp(string(i)+") "+root_library_paths{i}); end
    user_query = input("Enter: ");
    root_library_path_number = round(double(user_query));
    is_valid = 0 < root_library_path_number && root_library_path_number <= numel(root_library_paths);
    catch
    disp("Choose a valid option.")
    end
    end
end

addpath(genpath(fullpath));
addpath(genpath(root_library_paths{root_library_path_number}));

    
    %% Python-setup:
    
    pypath = pwd();
    pypath = split(pypath, "\"); 
    pypath = pypath{1}+"\"+pypath{2}+"\"+pypath{3}; % Oooga booga
    
    
    
    disp("Loading CoolProp into MATLAB:")
    
    try
    
    pyenv('Version', pypath+'\miniconda3\envs\matlab_python_enviroment\python.exe');
    py.importlib.import_module("CoolProp");
    test = py.CoolProp.CoolProp.PropsSI('D', 'T', 200, 'Q', 0, 'NitrousOxide');
    disp("test:"+string(test));
    disp("Package loaded correctly.")
    
    catch
    
    disp( "Coolprop not installed. Installer can be found at the top of the repo.")
    error("Coolprop not installed. Installer can be found at the top of the repo.")
    
    end
    
    is_setup = true;
end
