## [0.10.16] - Unreleased

### Changed
* **Now supports custom atmospheric models** `aerodynamics_model.m` now gets `pressure`, `temperature`, `density`, `wind_velocity` from `rocket.enviroment`, instead of querying them from [`atmoscoesa`](https://se.mathworks.com/help/aerotbx/ug/atmoscoesa.html) itself. If properties are not present under `rocket.enviroment`, it queries them in the old way, for backwards compatibility. This is to allow for custom atmospheric models, if one wants to use balloon data, satellite data, or change the medium all together if working with submersibles for example.


### Added
- **rocket = base_atmosphere_model(rocket)**, model. Basic atmospheric model using [`atmoscoesa`](https://se.mathworks.com/help/aerotbx/ug/atmoscoesa.html).

### Renamed

- **aerodynamics_model -> base_aerodynamics_model**, for traceability, makes it easier to see which models are included in base MatRocket and which are custom
- **equations_of_motion -> base_equations_of_motion_model** -ll-
- **gravity_model -> base_gravity_model** -ll-
- **propulsion_model -> base_propulsion_model** -ll-

**[NOTE!] THE ABOVE ARE NOT BACKWARDS COMPATIBLE! Sorry for the inconvenience. Projects using these (will be most) need to renamed, usually declared in rocket-initiation script.** Reason for renaming, as stated previously, is for future proofing and traceability.

- `rocket.enviroment.air_density` **->** `rocket.atmosphere.density`
- `rocket.enviroment.wind_velocity` **->** `rocket.atmosphere.wind_velocity`

**[NOTE!] THE ABOVE ARE NOT BACKWARDS COMPATIBLE! Sorry for the inconvenience. To fix bring code up to date, include `base_atmosphere_model` in `rocket.models`. See README -> Functionality & Documentation for suggested order of models**.


## [0.11.0] - Unreleased

### Changed
- **Made construction of state-vector inside ODE recursive [backwards-compatible]**, so that subcomponents can have their own derivative-properties. This is to support multibody physics, and to be able to take already existing models and components, and make them children of each other without having to modify them.

### Added
- **obj = child_models(obj)**, model. Recursively looks through children and applies their respective models, wrapped as a model.

- **obj = loading_bar_update(obj)**, model. Updates loading-bar, previously loading-bar was always on and couldnt be turned off.
