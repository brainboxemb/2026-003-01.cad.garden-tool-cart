include <../config.scad>
use <../components/base_plate.scad>
use <../components/upright.scad>
use <../components/u_profile.scad>

function rack_y_pos() = (base_depth - upright_depth) / 2;
function u_profile_z(i) = base_thickness
    + upright_height
    - u_top_offset
    - u_height
    - i * u_pitch;

module cart_frame() {
    color(base_color)
        base_plate(base_width, base_depth, base_thickness);

    rack_y = rack_y_pos();

    color(frame_color) {
        translate([0, rack_y, base_thickness])
            upright(upright_width, upright_depth, upright_height);

        translate([base_width - upright_width, rack_y, base_thickness])
            upright(upright_width, upright_depth, upright_height);

        for (i = [0 : u_count - 1])
            translate([upright_width,
                       rack_y + (upright_depth - u_width) / 2,
                       u_profile_z(i)])
                u_profile(u_length, u_width, u_height, u_wall);
    }
}
