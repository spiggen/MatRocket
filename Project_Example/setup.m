

%% Adding paths to sub-folders:
fullpath = erase(which(mfilename('fullpath')), 'Project_Example\setup.m');

addpath(genpath(fullpath));

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