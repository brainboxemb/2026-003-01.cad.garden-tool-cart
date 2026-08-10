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
view = "all"; // [ "all", "cart", "u_profile", "shovel_holder", "holder_on_profile", "simple_beam_holder", "simple_holder_lower", "simple_holder_upper", "tube_clip", "pocket_90", "pocket_45", "pocket_55" ]

// Secondary view mode.
subview = "assembled"; // [ "assembled", "exploded" ]

// Show construction centre lines in the pocket-hole test views.
show_guides = true; // [true, false]

// Print the current shovel-holder cut list in the OpenSCAD console.
print_cut_list = true; // [true, false]

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

// Place the simple 33 x 69 beam holder between two consecutive cart rails.
module simple_holder_on_cart(exploded = false) {
    upper_i = simple_holder_cart_upper_profile_index;
    lower_i = upper_i + 1;
    rack_y = rack_y_pos();
    lower_profile_z = u_profile_z(lower_i);

    // Local assembly has lower rail at Z=0 and projects towards +Y.
    // Rotate it so the beam projects towards the front of the cart (-Y).
    translate([simple_holder_cart_x,
               rack_y + (upright_depth - u_width) / 2 + u_width,
               lower_profile_z])
        rotate([0, 0, 180])
            simple_beam_holder(false, exploded);
}

if (view == "all") {
    cart_frame();
    holder_on_cart(exploded);
    simple_holder_on_cart(exploded);
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
