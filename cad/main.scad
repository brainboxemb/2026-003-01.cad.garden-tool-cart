// Geometry controls shown directly in the OpenSCAD Customizer.
// Angle convention: degrees measured from horizontal.
arm_slope_angle = 5; // [0:1:15]
brace_slope_angle = 45; // [30:1:60]

// Pass the Customizer values dynamically into files imported with `use`.
$holder_arm_angle_ui = arm_slope_angle;
$holder_brace_angle_ui = brace_slope_angle;

include <config.scad>
use <assemblies/cart_frame.scad>
use <assemblies/shovel_holder.scad>
use <components/u_profile.scad>
use <assemblies/pocket_test.scad>
use <assemblies/simple_beam_holder.scad>

// Main model selection in the OpenSCAD Customizer.
view = "all"; // [ "all", "cart", "u_profile", "shovel_holder", "holder_on_profile", "simple_beam_holder", "simple_holder_lower", "simple_holder_upper", "simple_holder_upper_3mm", "tube_clip", "pocket_90", "pocket_45", "pocket_55" ]

// Secondary view mode.
subview = "assembled"; // [ "assembled", "exploded" ]

// Show construction centre lines in the pocket-hole test views.
show_guides = true; // [true, false]

// Print the current shovel-holder cut list in the OpenSCAD console.
print_cut_list = true; // [true, false]

// Show the Ø22.5 mm broom handle passing through both simple tube clips.
show_broom_handle = false; // [true, false]

exploded = subview == "exploded";

if (print_cut_list)
    holder_cut_list();

// Place a holder on one selected U-profile of the complete cart.
module holder_on_cart(exploded = false) {
    rack_y = rack_y_pos();
    profile_z = u_profile_z(holder_cart_profile_index);

    // Upper holder slot is aligned to the selected U-profile. The lower
    // mounting bar is intentionally two u_pitch steps below, so one rail is
    // skipped between the two support points.
    z_shift = profile_z + u_height - (holder_upper_mount_z + holder_slot_depth);

    // The holder projects towards the front of the cart (-Y). Rotate 180°
    // around Z so its local +Y projection points towards -Y.
    // Its slotted rear bar then sits over the front wall of the U-profile.
    translate([holder_cart_x + holder_total_width(),
               rack_y + (upright_depth - u_width) / 2,
               z_shift])
        rotate([0, 0, 180])
            shovel_holder(true, exploded);
}

// Place the simple 74 x 18 multiplex-strip holder between two consecutive cart rails.
module simple_holder_on_cart(x_position = simple_holder_cart_x, exploded = false) {
    upper_i = simple_holder_cart_upper_profile_index;
    lower_i = upper_i + 1;
    rack_y = rack_y_pos();
    lower_profile_z = u_profile_z(lower_i);

    // Local assembly has lower rail at Z=0 and projects towards +Y.
    // Rotate it so the beam projects towards the front of the cart (-Y).
    translate([x_position,
               rack_y + (upright_depth - u_width) / 2 + u_width,
               lower_profile_z])
        rotate([0, 0, 180])
            simple_beam_holder(false, exploded);
}

// Broom handle shared by the two simple holders in the full-cart view.
// Both holders are mirrored around the cart centre. The cylinder runs along X
// and spans the full clip width at both ends, so the 22.5 mm visual handle
// deliberately intersects the 22.0 mm interference-fit clip bore slightly.
module broom_handle_between_simple_holders() {
    left_x = simple_holder_cart_x;
    right_x = base_width - simple_holder_cart_x;

    upper_i = simple_holder_cart_upper_profile_index;
    lower_i = upper_i + 1;
    lower_profile_z = u_profile_z(lower_i);
    rack_y = rack_y_pos();

    // Same local clip position as in simple_beam_holder(), transformed by
    // the 180 degree Z rotation used by simple_holder_on_cart().
    local_beam_y = -simple_holder_rear_overlap;
    local_clip_y = local_beam_y + simple_holder_beam_length
                 - tube_clip_end_margin - tube_clip_base_length/2;
    holder_origin_y = rack_y + (upright_depth - u_width) / 2 + u_width;
    clip_center_y = holder_origin_y - local_clip_y;

    inner_d = tube_clip_tube_diameter - tube_clip_interference;
    clip_outer_r = inner_d/2 + tube_clip_wall;
    clip_overlap = 1.0;
    clip_center_z = lower_profile_z + u_height + simple_holder_beam_height
                  + tube_clip_base_thickness + clip_outer_r - clip_overlap;

    handle_start_x = left_x - tube_clip_width/2;
    handle_end_x = right_x + tube_clip_width/2;
    handle_length = handle_end_x - handle_start_x;

    color(broom_handle_color)
        translate([handle_start_x, clip_center_y, clip_center_z])
            rotate([0,90,0])
                cylinder(h=handle_length, d=tube_clip_tube_diameter);
}

if (view == "all") {
    cart_frame();
    holder_on_cart(exploded);

    // Two simple multiplex-strip holders, mirrored around the cart centre.
    simple_holder_on_cart(simple_holder_cart_x, exploded);
    simple_holder_on_cart(base_width - simple_holder_cart_x, exploded);

    if (show_broom_handle)
        broom_handle_between_simple_holders();
}
else if (view == "cart") {
    cart_frame();
}
else if (view == "u_profile") {
    color(frame_color)
        u_profile(u_length, u_width, u_height, u_wall);
}
else if (view == "shovel_holder") {
    shovel_holder(true, exploded);
}
else if (view == "holder_on_profile") {
    shovel_holder_on_profile(true, exploded);
}
else if (view == "simple_beam_holder") {
    simple_beam_holder(true, exploded);
}
else if (view == "simple_holder_lower") {
    simple_beam_holder_lower_part();
}
else if (view == "simple_holder_upper") {
    simple_beam_holder_upper_part();
}
else if (view == "simple_holder_upper_3mm") {
    simple_beam_holder_upper_part_3mm();
}
else if (view == "tube_clip") {
    simple_beam_holder_tube_clip_part();
}
else if (view == "pocket_90") {
    pocket_joint_test(90, exploded, show_guides);
}
else if (view == "pocket_45") {
    pocket_joint_test(45, exploded, show_guides);
}
else if (view == "pocket_55") {
    pocket_joint_test(55, exploded, show_guides);
}
