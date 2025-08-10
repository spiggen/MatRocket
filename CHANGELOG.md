## [0.10.16]

### Changed
* **Now supports custom atmospheric models** `aerodynamics_model.m` now gets `pressure`, `temperature`, `density`, `wind_velocity` from `rocket.enviroment`, instead of querying them from [`atmoscoesa`](https://se.mathworks.com/help/aerotbx/ug/atmoscoesa.html) itself. If properties are not present under `rocket.enviroment`, it queries them in the old way, for backwards compatibility. This is to allow for custom atmospheric models, if one wants to use balloon data, satellite data, or change the medium all together if working with submersibles for example.


### Added
- **base_atmosphere_model.m**, model. Basic atmospheric model using [`atmoscoesa`](https://se.mathworks.com/help/aerotbx/ug/atmoscoesa.html).

### Renamed

- **aerodynamics_model -> base_aerodynamics_model**, for traceability, makes it easier to see which models are included in base MatRocket and which are custom
- **equations_of_motion -> base_equations_of_motion_model** -ll-
- **gravity_model -> base_gravity_model** -ll-
- **propulsion_model -> base_propulsion_model** -ll-

**[NOTE!] THE ABOVE ARE NOT BACKWARDS COMPATIBLE! Sorry for the inconvenience. Projects using these (will be most) need to renamed, usually declared in rocket-initiation script.** Reason for renaming, as stated previously, is for future proofing and traceability.

- `rocket.enviroment.air_density` **->** `rocket.atmosphere.density`
- `rocket.enviroment.wind_velocity` **->** `rocket.atmosphere.wind_velocity`

**[NOTE!] THE ABOVE ARE NOT BACKWARDS COMPATIBLE! Sorry for the inconvenience. To fix bring code up to date, include `base_atmosphere_model` in `rocket.models`. See README -> Functionality & Documentation for suggested order of models**.


## [0.10.17]

### Added
- **base_UI_loading_bar.m**, UI model. Previously the loading-bar interfered with multithreading. Now, loading-bar is available as a model, allowing users to choose whether they want it or not.

### Changed
- **base_atmosphere_model.m**, fixed bug. Should now be working properly.


## [0.10.18]

### Added
- **base_atmosphere_from_dataset_model.m**, allows for reading atmoshperic data from weather-balloons via the web or a csv-file. See README
- **random_wind_dataset.m**, checks the web and selects a random dataset. See README
- **simulation_logger.m**, logs the simulation during the simulation loop, removing the need for post-processing, making hardware-in-the-loop a lot more practical
- **realtime_ode.m**, a realtime ode-solver based on the Adam-Bashworth method, to solve ode-equations in real time. Primarily useful for hardware-in-the-loop simulation


### Changed
- **mesh2aerodynamics.m**, fixed bug that made it only work on some computers, pertaining to how MATLAB's getframe works. Should now be more stable
- **base_equations_of_motion_model.m**, fixed bug, rotation_rate_absolute was set to zero, which propagated down to downstream rotating components as well

### Removed
- **create_historian.m**, This is now handled by the simulation_logger
- **record_history.m**, This is now handled by the simulation_logger





## [0.11.0] - Unreleased

### Changed
- **Made construction of state-vector inside ODE recursive [backwards-compatible]**, so that subcomponents can have their own derivative-properties. This is to support multibody physics, and to be able to take already existing models and components, and make them children of each other without having to modify them.

### Added
- **obj = child_models(obj)**, model. Recursively looks through children and applies their respective models, wrapped as a model.

- **obj = loading_bar_update(obj)**, model. Updates loading-bar, previously loading-bar was always on and couldnt be turned off.
