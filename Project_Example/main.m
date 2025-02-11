setup;

my_rocket = reference_rocket;

job = struct(); job.t_max = 30;
rocket_historian = run_simulation(my_rocket, job);


delete    (".\Rocket_source\reference_rocket\Output\flight.txt")
struct2txt(".\Rocket_source\reference_rocket\Output\flight.txt", rocket_historian, 0:1/30:job.t_max);