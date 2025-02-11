addpath("..\animation_toolbox\")

starship = txt2struct("C:\Users\jonas\OneDrive - KTH\Matlab-drive\Blender div\starship\starship.txt");
starship.position = [0;200;900];




ax = axes();
%draw_rocket_recursive(ax, starship)
dark_mode2();
an1 = animation(@(c) a1(ax, starship, sin(c{1})*45) , {0},{6*pi} );

animate({an1}, 0:5:100)


function a1(ax, starship, fin_angle)
    starship.fin_fwd_RH.fin_fwd_RH_relative.attitude = rotz(fin_angle);
    starship.attitude = rotx(0.1*fin_angle);
    draw_rocket_recursive(ax, starship);
    xlim(starship.position(1) + [-150 150])
    ylim(starship.position(2) + [-150 150])
    zlim(starship.position(3) + [-150 150])

end