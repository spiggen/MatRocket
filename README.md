# MatRocket
Author: Vilgot Lötberg, vilgotl@kth.se, 0725079097
Upon finding issues or if you have questions, please call me.

![](https://github.com/spiggen/MatRocket/blob/master/Documentation/MatRocket_logo_transparent.png)

**NOTE!** This is the MatRocket source-code, but does not have to be downloaded for getting started with MatRocket. Proper installation of MatRocket is done via **pip**, follow the guide provided below.

For feedback, updates and possibility to chat with others using MatRocket, feel free to join the Discord: https://discord.gg/6xzcjur4fX


## Contents:

* **MatRocket installation**
* **Project setup**
* **Functionality & documentation**
* **Changelog**

## MatRocket installation

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
A suggested use case would be to put this in a startup-script in MATLAB.

<hr/>

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

This path can then be added in MATLAB using addpath:

```MATLAB
addpath(genpath("C:\Users\jonas\AppData\Local\Packages\PythonSoftwareFoundation.Python.3.13_qbz5n2kfra8p0\LocalCache\local-packages\Python313\site-packages"))
```





## Project setup


For a template on how to set up a project, a project example is provided which can be cloned and modified:

https://github.com/spiggen/MatRocket-Single-Stage-Rocket-Example-



## Functionality & Documentation


### Functions
#### Models
* `base_atmosphere_model.m`
* `base_aerodynamics_model.m`
* `base_equations_of_motion_model.m`
* `base_gravity_model.m`
* `base_propulsion_model.m`
#### Utilities
* `run_simulation.m`
* `rocket2state_vector.m`
* `state_vector2rocket.m`
* `derivative2rocket.m`
* `create_historian.m`
* `record_history.m`
* `flatten.m`
* `system_equations.m`
* `mesh2aerodynamics.m`
* `moment_vector.m`
* `force_vector.m`
* `body.m`
* `cellsum.m`
* `limit.m`
* `normalize.m`
* `orthonormalize.m`
* `vector2orthonormal_basis.m`


## Models

All models work around the concept of a state-update. It takes in the rocket, and updates it in some way. 
It then feeds that same rocket as output, but with an updated state.

### Suggested order
Due to the fact that the models feed into each other and are dependent on parameters set by each other, their order is important.

See input & output parameters below for more information on which parameters are required by which model. 

**[NOTE!] If the parameter is not updated by a previous model, the parameter used will be the one set in the initiation script.**

Suggested order:

```MATLAB
    rocket.models = {@base_atmosphere_model,           ...
                     @base_equations_of_motion_model,  ...
                     @base_propulsion_model,           ...
                     @base_aerodynamics_model,         ... 
                     @base_gravity_model,              ...
                     @base_equations_of_motion_model    };
```

---




### `base_atmosphere_model.m`
```matlab
rocket = base_atmosphere_model(rocket)
```
**Recursive:** No  
**File:** `Simulations/Models/base_atmosphere_model.m`

#### Inputs (all in parent’s basis):
* `rocket.position` | 3x1 Double

#### Major outputs:
* `rocket.atmosphere.pressure` | Double | Atmospheric pressure
* `rocket.atmosphere.temperature` | Double | Atmospheric temperature
* `rocket.atmosphere.density` | Double | Atmospheric density
* `rocket.atmosphere.speed_of_sound` | Double | Atmospheric speed of sound
* `rocket.atmosphere.wind_velocity` | 3x1 Double | Atmospheric wind velocity

This model queries MATLAB's [atmoscoesa](https://se.mathworks.com/help/aerotbx/ug/atmoscoesa.html) model, included in the [MATLAB aerospace toolbox](https://se.mathworks.com/products/aerospace-toolbox.html) based on the rockets altitude, and thus determines the above properties.

---






### `base_aerodynamics_model.m`
```matlab
rocket = base_aerodynamics_model(rocket)
```
**Recursive:** Yes  
**File:** `Simulations/Models/base_aerodynamics_model.m`

#### Executes on component if:
* `component` has `aerodynamics` property
* `component` has `is_body` property
* `component.is_body` is set to `true`

#### Inputs (all in parent’s basis):
* `rocket.atmosphere.density` | 3x1 Double (top level only)
* `.component.attitude` | 3x3 Double | Rotation matrix from component to parent
* `.component.wind_velocity_absolute` | 3x1 Double | Relative wind in parent basis
* `.component.rotation_rate_absolute` | 3x1 Double | Absolute rotation rate in parent basis
* `.component.aerodynamics.pressure_coefficient` | 3x1 Double | Coefficient of drag for each surface
* `.component.aerodynamics.moment_of_area` | 3x3x5 Double | Area-moment tensor
* `.component.aerodynamics.length_scale` | Double | Characteristic length used in tensor formulation

#### Major outputs:
* `.component.moments.LiftMoment` | struct | Moment induced by lift/drag in parent basis
* `.component.forces.LiftForce` | struct | Lift/drag force in parent basis

#### Additional outputs:
* `.component.aerodynamics.wind_velocity_absolute` | 3x1 Double | Wind vector rotated into component’s own frame
* `.component.lift_force_tensor` | 3x3 Double | Component-wise lift tensor, for diagnostics/plotting

This model does **not** use center-of-pressure. It instead computes aerodynamic moments using a series expansion of area-moment tensors, relative wind, and angular velocity — all in the parent frame. The tensor approach blends higher-order spatial information to resolve lift-induced moments.

See:  
[Detailed technical explanation](https://github.com/spiggen/MatRocket/blob/master/Documentation/aerodynamics_model.md)

The inputs for the aerodynamics-model can be set manually, but recommendation is to let `mesh2aerodynamics.m` do it for you. See documentation for `mesh2aerodynamics.m`.


---

### `base_equations_of_motion_model.m`
```matlab
rocket = equations_of_motion(rocket)
```
**Recursive:** Yes  
**File:** `Simulations/Models/base_equations_of_motion_model.m`

#### Executes on component if:
* `component` has `is_body` property set to `true`

#### Inputs (in parent’s basis unless noted):
* `rocket.rigid_body.moment_of_inertia` | 3x3 Double (top level only)
* `rocket.atmosphere.wind_velocity` | 3x1 Double (top level only)
* `rocket.velocity` | 3x1 Double | Velocity of rocket (top level only)
* `rocket.angular_momentum` | 3x1 Double | Angular momentum of rocket (top level only)
* `.component.mass` | Double | Mass of component
* `.component.attitude` | 3x3 Double | Rotation matrix from component to parent 
* `.component.position` | 3x1 Double | Position of component
* `.component.forces` | struct | Forces acting on the component
* `.component.moments` | struct | Force-moments acting on the component


#### Major outputs:
* `.component.rotation_rate` | 3x1 Double | Angular velocity in parent basis
* `.component.rotation_rate_absolute` | 3x1 Double | Accumulated from parent + local
* `.component.wind_velocity_absolute` | 3x1 Double | Relative wind in parent basis
* `.component.acceleration` | 3x1 Double | Linear acceleration
* `.component.derivative("position")`, `.derivative("velocity")`, `.derivative("attitude")`, `.derivative("angular_momentum")` for integration of ODE by ODE-solver

#### Additional outputs:
* `.component.center_of_mass_absolute` | 3x1 Double | Recursive center of mass
* `.component.force_absolute`, `.moment_absolute` | struct | Aggregated forces and moments in hierarchy
* `.component.mass_absolute` | Double | Total mass of the rocket

This model walks the rocket hierarchy, computing each body’s motion using Newton-Euler equations. Communication is two-way:
- Parent to child: passes down `rotation_rate_absolute` and `wind_velocity_absolute`
- Child to parent: aggregates `mass`, `force`, `moment`, and `center_of_mass`

Basis handling is explicit — all component-frame vectors are transformed via `.attitude` or its transpose.

---

### `base_gravity_model.m`
```matlab
rocket = base_gravity_model(rocket)
```
**Recursive:** No  
**File:** `Simulations/Models/base_gravity_model.m`

#### Inputs:
* `rocket.attitude` | 3x3 Double | Rotation matrix from component to parent
* `rocket.enviroment.g` | Double | gravitational constant
* `rocket.mass_absolute` | Double | Total mass of the rocket
* `rocket.center_of_mass_absolute` | 3x1 Double | Total center of mass of rocket


#### Major outputs:
* `rocket.forces.Gravity` | struct | Gravitational force vector
<hr/>

### ```base_propulsion_model.m```
```matlab
rocket = base_propulsion_model(rocket)
```
**Recursive:** No  
**File:** `Simulations/Models/base_propulsion_model.m`

#### Inputs:
* `rocket.t` | Double | Simulation-time
* `rocket.engine.burn_time` | Double | Length of engine-burn
* `rocket.engine.thrust_force` | Double | Magnitude of thrust-force

#### Outputs:
* `rocket.engine.forces.thrust_force` | struct | Thrust-force
* `rocket.engine.active_burn` | Boolean | Whether or not the burn is ongoing or not
<hr/>


## Utilities


### `mesh2aerodynamics.m`

```matlab
component = propulsion_model(component)
```
**Recursive:** Yes
**File:** `Simulations/Models/lib/mesh2aerodynamics.m`

#### Executes on component if:
* `component` has `mesh` property

#### Inputs:
* `.component.mesh` | struct | Filepath to the stl-file describing the body's geometry

#### Outputs:
* `.component.aerodynamics` | struct | property containing all aerodynamics information
* `.component.aerodynamics.moment_of_area` | 3x3x5 Double | Area-moment tensor 
* `.component.aerodynamics.surface_area` | 3x1 Double | Surface-area of each face
* `.component.aerodynamics.length_scale` | 3x1 Double | Characteristic length of each axis of the component
* `.component.aerodynamics.pressure_coefficient` | 3x1 Double | Coefficient of drag for each surface (pressure)
* `.component.aerodynamics.friction_coefficient` | 3x1 Double | Coefficient of drag for each surface (skin-friction)
* `.component.aerodynamics.is_body` | Boolean, true | Tells equations of motion to include forces and moments specified under aerodynamics

See:  
[Detailed technical explanation](https://github.com/spiggen/MatRocket/blob/master/Documentation/aerodynamics_model.md)


## General Structure
![](https://github.com/spiggen/MatRocket/blob/master/Documentation/matrocket_simulation_structure.png)

How MatRocket is structured.

## Changelog
See https://github.com/spiggen/MatRocket/blob/master/CHANGELOG.md