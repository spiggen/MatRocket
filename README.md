# Creating and modelling rockets
Author: Vilgot Lötberg, vilgotl@kth.se, 0725079097
Upon finding issues or if you have questions, please call or email me.


The below is documentation for the code found at: https://github.com/spiggen/MatRocket/tree/master


<h2>Contents:</h2>

- Setup & installation
- Project examples
- Funtions
- Models
- Basis & Structure




# Setup & installation

An installation-script can be found in this repo's top level, ```installer.bat```. By downloading this and running it, the package should install automatically.

The source-code can be found either by typing:
```powershell
pip show MatRocket
```
Or by downloading the package from Github.

**NOTE!** The package includes a set of **project examples** detailing how a simulation project can be organized/set up. If the package is installed via pip, it does not contain the simulation result files (.csv), the initiating .csv files, or the blender files. This is to make the package lighter weight, as the project-example is primarily intended to be cloned from **GitHub**.


## Manual installation

Additionally, or of this doesn't work, installation can be done through pip in powershell or cmd:

```powershell
pip install MatRocket
```
This puts MatRocket on a path that should be reachable.



### Access from MATLAB
The library will not automatically end up on the MATLAB-path, but has to be added manually. To do this, add this to the start of your MATLAB script:

```MATLAB
%% Add MatlabBlenderIO to path:
[library_failiure, library_status] = system("pip show MatRocket");

if library_failiure ;disp(library_status);error("Package not found."); end

addpath(genpath(strip(extractBetween(string(library_status), "Location: ", "Requires:"))+"\MatRocket"));

```

Until MATLAB adds a way to add the path to pip-packages via a single command, this is the way we'll have to do it.


# Project examples

Project examples can be found under:
``` \Project_Examples\ ```

The following example-projects are provided:

- ``` \Project_Examples\Singlestage_Rocket  ```
- ``` \Project_Examples\Multistage_Rocket  ```

A project is usually organized as follows (though can of course be organized differently based on needs):

- ```\Project_Examples\...\setup.m``` defines the enviroment that the script is run in, what folders the code has access to, and which functions can be used, etc.

- ``` \Project_Examples\...\Rocket_Source\``` Initial conditions, simulation parameters and how the rocket is defined here.


- ```\Project_Examples\...\Output\``` The results are saved here.

- ```\Project_Examples\...\main.m``` The simulation profile, ODE-solver etc are defined here.

# Functions

The following functions/utilities are provided in MatRocket:

- **run_simulation** (rocket, job)
- **system_equations** (t, state_vector, rocket)
- **obj2state_vector** (obj)
- **obj2state_vector_derivative** (obj)
- **state_vector2obj** (state_vector, obj)
- **solution2historian** (initial_conditions, solution)
- **create_historian** (instance,history_length)
- **record_history** (instance, historian, history_index)
- **query_historian** (historian, t)

**struct = csv2obj(filepath)** | *Where **filepath** is the path to the .csv file.*



# Models
## What is a model?

Models in MatRocket are centered around the concept of a state-update. All models are simply Matlab functions that take the rocket* as input, and output that same rocket* with some updated state.

*or some subcomponent of the rocket as of MatRocket 0.10.16

All the models of a rocket are stored in a list of the model handles, as a property of the rocket itself:
```MATLAB
>> rocket.models
```

```MATLAB
ans =

  1x7 cell array

  Columns 1 through 7

    {@loading_bar_update}    {@equations_of_motion}    {@propulsion_model}    {@aerodynamics_model}    {@gravity_model}    {@check_yo_staging}    {@equations_of_motion}

```

The MatRocket ```system_equations``` function takes the models listed under the rocket simulated and applies them to the rocket in chronological order:

![](Documentation\matrocket_simulation_structure.png)

A simple example might be the ``` propulsion_model```.




## Standard models
The following models are provided in MatRocket:

- **aerodynamics_model** (rocket)
- **equations_of_motion** (rocket)
- **gravity_model** (rocket)
- **propulsion_model** (rocket)
- **loading_bar_update** (rocket)
