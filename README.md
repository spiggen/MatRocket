# MatRocket
Author: Vilgot Lötberg, vilgotl@kth.se, 0725079097
Upon finding issues or if you have questions, please call me.

<img src="Documentation\MatRocket_logo_transparent.png" alt="isolated" width="300"/>

**NOTE!** This is the MatRocket source-code, but does not have to be downloaded for getting started with MatRocket. Proper installation of MatRocket is done via **pip**, follow the guide provided below.


## Contents:

* **MatRocket installation**
* **Project setup**
* **Functionality & documentation**

## MatRocket installation

### Manual installation
MatRocket is installed via **pip**. In powershell, cmd or similar:


```powershell
pip install MatRocket
```

For installation of pip, see https://pip.pypa.io/en/stable/installation/

**NOTE!** MATLAB does not automatically recognize libraries installed via pip, and as such, in any scripts that uses MatRocket need to add the MatRocket path.


```powershell
pip show MatRocket
```
This gives the resulting output (or similar):
```powershell
Name: MatRocket
Version: 0.10.15
Summary: MatRocket is a library for simulating rockets in MATLAB.
Home-page: https://github.com/spiggen/MatRocket
Author: Vilgot Lötberg
Author-email: vilgotl@kth.se
License:
Location: C:\Users\jonas\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.13_qbz5n2kfra8p0\LocalCache\local-packages\Python313\site-packages
Requires: MatlabBlenderIO
Required-by:
```



### Automatic path and installation

Below is provided a MATLAB-script that, if MatRocket is not installed, installs MatRocket, and adds the path:

```MATLAB
pip_libraries = {"MatRocket"};

for index = 1:numel(pip_libraries)
library = pip_libraries{index};
[failiure, library_status] = system("pip show "+library);
if failiure
system("pip install "+library);
[failiure, library_status] = system("pip show "+library);
end

library_path = strip(extractBetween(string(library_status), "Location: ", "Requires:"))+"\"+library;
addpath(genpath(library_path));
disp(library +" loaded successfully.")
end

```



## Project setup


For a template on how to set up a project, a project example is provided which can be cloned and modified:

https://github.com/spiggen/MatRocket-Single-Stage-Rocket-Example-



## Functionality & documentation


### Functions
#### Models
* ```aerodynamics_model.m```
* ```equations_of_motion.m```
* ```gravity_model.m```
* ```parachute_model.m```
* ```propulsion_model.m```
#### Utilities
* ```run_simulation.m```

### Detailed description:
#### ```aerodynamics_model.m```
Some text

#### ```equations_of_motion.m```
Some text

#### ```gravity_model.m```
Some text

#### ```parachute_model.m```
Some text

#### ```propulsion_model.m```
Some text




### General Structure
<img src="Documentation\MatRocket_simulation_structure.png" alt="isolated" width="900"/>

How MatRocket is structured.
