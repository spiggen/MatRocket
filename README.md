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
* `base_atmosphere_from_dataset_model.m`
* `base_aerodynamics_model.m`
* `base_equations_of_motion_model.m`
* `base_gravity_model.m`
* `base_propulsion_model.m`
* `base_UI_loading_bar.m`
#### Utilities
* `run_simulation.m`
* `simulation_logger.m`
* `query_historian.m`
* `realtime_ode.m`
* `rocket2state_vector.m`
* `state_vector2rocket.m`
* `derivative2rocket.m`
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
* `random_wind_dataset.m`


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



### `base_atmosphere_from_dataset_model.m`
```matlab
rocket = base_atmosphere_from_dataset_model(rocket)
```
Introduced in MatRocket 0.10.18

**Recursive:** No  
**File:** `Simulations/Models/base_atmosphere_from_dataset_model.m`

#### Inputs (all in parent’s basis):
* `rocket.position` | 3x1 Double
* `rocket.atmosphere.dataset` | string | Either the url to a valid dataset-csv file download page, or the filepath to a dataset-csv file.

#### Major outputs:
* `rocket.atmosphere.pressure` | Double | Atmospheric pressure
* `rocket.atmosphere.temperature` | Double | Atmospheric temperature
* `rocket.atmosphere.density` | Double | Atmospheric density
* `rocket.atmosphere.speed_of_sound` | Double | Atmospheric speed of sound
* `rocket.atmosphere.wind_velocity` | 3x1 Double | Atmospheric wind velocity

This model uses a dataset from a weather balloon or similar to calculate the atmospheric conditions. For an example of where to get data, see: https://weather.uwyo.edu/upperair/sounding.shtml

For formatting of the data pointed to by the url/csv the `rocket.atmosphere.dataset`, see: https://weather.uwyo.edu/wsgi/sounding?datetime=2018-12-20%2009:00:00&id=02185&src=UNKNOWN&type=TEXT:CSV 

To get random data (for example, for monte-carlo style simulations), see the helper-function `random_wind_dataset`.


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


### `run_simulation.m`

```matlab
[historian, job] = run_simulation(rocket, job)
```
**File:** `Simulations/run_simulation.m`

#### Inputs:
* `rocket` | struct 
* `job` | struct | contains fields with options for how the simulation is to be run, for example the simulation time, ode-solver, etc.

#### Outputs:
* `historian` | struct | a carbon copy of the rocket, but with an extra dimension for each parameter pertaining to the time-steps taken during simulation. See `simulation_logger.m`
* `job` | struct | same as input, but with additional fields pertaining to how the simulation was executed, for example elapsed simulaiton time



A shorthand/wrapper for the MATLAB ODE-solvers. By default, `run_simulation` uses MATLAB's [`ode_45`](https://se.mathworks.com/help/matlab/ref/ode45.html). For realtime ode-solving, see MatRocket's `realtime_ode.m`. 

To change out the ode-solver, assign `job.ode_solver` with the function handle to the ode-solver of your choise:

```matlab
job.ode_solver = @ode23t;
```

[See MATLAB's ode-solvers](https://se.mathworks.com/help/matlab/math/choose-an-ode-solver.html).


To change the simulation-time, assign `job.t_max`:

```matlab
job.t_max = 300 %[s];
```

---

### `simulation_logger.m`

```matlab
% Simulation-logging-mode:
simulation_logger(rocket);

% Query/extraction-mode:
historian = simulation_logger();

```
**File:** `Simulations/lib/simulation_logger.m`

#### Inputs:
* `rocket` | struct 

#### Outputs:
* `historian` | struct | a carbon copy of the rocket, but with an extra dimension for each parameter pertaining to the time-steps taken during simulation


`simulation_logger` is meant to run in two different modes depending on if it's in the simulation loop or not. It is the main simulation logger, and keeps track of the simulation state by using persistent variables. That way, when the ode-solver is done and the simulation scope is cleaned up by MATLAB, the simulation_logger scope is still untouched, allowing us to extract the simulation data. It is primarily used by `run_simulation.m`.

The `historian`-struct is a copy of the `rocket`-struct, but with one extra dimension for each double/logical type property. This extra dimension contains said property over every single timestep, and is a log of how it changes over the course of the simulation. For example:

```matlab
>> rocket

rocket = 

  struct with fields:

             is_body: 1
            position: [3×1 double]
            attitude: [3×3 double]
                mesh: ".\Rocket_source\rocket.stl"
              engine: [1×1 struct]
              models: {1×10 cell}
          derivative: [4×1 containers.Map]
          enviroment: [1×1 struct]
          atmosphere: [1×1 struct]
          rigid_body: [1×1 struct]
    angular_momentum: [3×1 double]
       rotation_rate: [3×1 double]
            velocity: [3×1 double]
        aerodynamics: [1×1 struct]
               chute: [1×1 struct]
                tank: [1×1 struct]

```

```matlab

>> historian

historian = 

  struct with fields:

                          is_body: [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 … ] (1×6001 double)
                         position: [3×1×6001 double]
                         attitude: [3×3×6001 double]
                             mesh: ".\Rocket_source\rocket.stl"
                           engine: [1×1 struct]
                       enviroment: [1×1 struct]
                       atmosphere: [1×1 struct]
                       rigid_body: [1×1 struct]
                 angular_momentum: [3×1×6001 double]
                    rotation_rate: [3×1×6001 double]
                         velocity: [3×1×6001 double]
                     aerodynamics: [1×1 struct]
                            chute: [1×1 struct]
                             tank: [1×1 struct]
                                t: [0 0.0167 0.0333 0.0500 0.0667 0.0833 0.1000 0.1167 0.1333 0.1500 0.1667 0.1833 0.2000 0.2167 … ] (1×6001 double)
           wind_velocity_absolute: [3×1×6001 double]
                             mass: [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 … ] (1×6001 double)
           rotation_rate_absolute: [3×1×6001 double]
                           forces: [1×1 struct]
                          moments: [1×1 struct]
         assigned_body_parameters: [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 … ] (1×6001 double)
          center_of_mass_absolute: [3×1×6001 double]
                    mass_absolute: [68 67.9700 67.9400 67.9100 67.8800 67.8500 67.8200 67.7900 67.7600 67.7300 67.7000 67.6700 … ] (1×6001 double)
                   force_absolute: [1×1 struct]
                  moment_absolute: [1×1 struct]
                     acceleration: [3×1×6001 double]
    rotation_rate_component_basis: [3×1×6001 double]
                lift_force_tensor: [3×3×6001 double]

```

(In the above case the historian contains extra parameters, since it also contains parameters assigned during the simulation, whereas the `rocket` only contains the initial conditions).

**[NOTE!]** If querying `simulation_logger` directly, remember to clear `simulation_logger` before starting a new simulation, otherwise it will still contain the old simulation data and try to append the new simulation data to the old. To do this, run:

```matlab
clear simulation_logger
```

---

### `query_historian.m`

```matlab
% Query at single timestep
rocket = query_historian(historian, t)
% Query at multiple timesteps
historian = query_historian(historian, t)
```

**File:** `Simulations/lib/query_historian.m`


#### Inputs:
* `historian` | struct | see `simulation_logger.m`
* `t` | 1x1 double OR 1xN double | time at which historian is to be queried

#### Outputs:
* `rocket` | struct | if `t` is a 1x1 double
* `historian` | struct | if `t` is a 1xN double, see `simulation_logger.m`


`query_historian` is a helper function that, given a time or a range of times `t`, interpolates `historian` and returns a  `rocket`/`historian` at that given time or range of times. This is especially useful for animation, as MATLAB's ode-solvers don't take a constant timestep, but instead vary the timestep. By using `query_historian`, we can interpolate it at a range of times that is linearly spaced to get a fixed framerate. 


---

### `realtime_ode.m`

```matlab
solution = realtime_ode(dvdt, t_span, v_init)
```

**File:** `Simulations/lib/realtime_ode.m`

#### Inputs:
* `dvdt` | function_handle | ordinary differential equation to be solved on the form: `dvdt = @(t,v) ...`
* `t_span` | 1x2 double | simulation time-span
* `t_v_init` | Nx1 double | initial value of state vector, where N is the number of elements in the state vector

#### Outputs:
* `solution` | struct | struct with two fields: 
    * `solution.x` | 1xM | timesteps taken during simulation, where M is the number of timesteps
    * `solution.y` | NxM | state-vector values during simulation, where M is the number of timesteps, and N is the number of elements in the state vector


`realtime_ode` is written on the same form as the standard MATLAB ode-solvers, see [MATLAB's documentation](https://se.mathworks.com/help/matlab/math/choose-an-ode-solver.html). `realtime_ode` is a second-order Adam-Bashworth ODE-solver, that clocks the time it takes to run the simulation computations, and uses that as it's actual timstep stepsize. This way, simulation time is kept in sync with realtime. This is especially important for hardware-in-the-loop simulations, as realtime systems can only run in real time, and thus the simulation has to keep in sync with the hardware.


---

### `random_wind_dataset.m`

```matlab
url = random_wind_dataset(station_number, start_date, end_date)
```
**File:** `Simulations/lib/random_wind_dataset.m`


### Inputs:
* `station_number` | string | station number of the station you want to query wind data from
* `start_date` | datetime | start-date on the interval you want to find wind-data
* `end_date` | datetime | end-date on the interval you want to find wind-data
 

### Outputs:
* `url` | string | url to a valid wind-dataset


`random_wind_dataset` looks for a random wind dataset on the web in between the start date and end date provided, and, once it finds one that is valid, returns the download-url as a string. The data is provided by the university of wyoming: https://weather.uwyo.edu/upperair/sounding.shtml

For formatting of the data pointed to by the url, see: https://weather.uwyo.edu/wsgi/sounding?datetime=2018-12-20%2009:00:00&id=02185&src=UNKNOWN&type=TEXT:CSV 


---


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