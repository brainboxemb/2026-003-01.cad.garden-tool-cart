include <../config.scad>
use <../components/wood_beam.scad>
use <../components/u_profile.scad>
use <../components/rail_beam_mount.scad>
use <../components/tube_clip.scad>

// Generic 33 x 69 beam projecting forward from the rack and locked between
// two consecutive U-profiles by two printed parts.
module simple_beam_holder(show_profiles = true, exploded = false) {
    lower_z = 0;
    lower_top_z = u_height;
    wood_z = lower_top_z;
    upper_z = lower_top_z + simple_holder_beam_height + simple_holder_top_gap;

    // Centre the 33 mm wide beam and printed parts around X = 0.
    beam_x = -simple_holder_beam_width / 2;

    // The beam projects forward in local +Y. Its rear part sits below the rails.
    beam_y = -simple_holder_rear_overlap;

    // Lower insert sits inside the lower steel U-profile, immediately below wood.
    insert_x = -simple_holder_lower_insert_x / 2;
    insert_y = (u_width - simple_holder_lower_insert_y) / 2;
    insert_z = u_wall;

    // Upper saddle surrounds the whole upper rail. Its 9 mm bottom fills the
    // remaining gap between the 69 mm wood and the next rail.
    saddle_outer_y = u_width + 2 * simple_holder_saddle_clearance
                   + 2 * simple_holder_saddle_wall;
    saddle_x = -simple_holder_mount_width / 2;
    saddle_y = (u_width - saddle_outer_y) / 2;
    saddle_z = wood_z + simple_holder_beam_height;

    explode_low = exploded ? -35 : 0;
    explode_top = exploded ? 45 : 0;
    explode_beam = exploded ? 25 : 0;

    if (show_profiles) {
        color(frame_color) {
            translate([-simple_holder_profile_preview_length / 2, 0, lower_z])
                u_profile(simple_holder_profile_preview_length, u_width, u_height, u_wall);
            translate([-simple_holder_profile_preview_length / 2, 0, upper_z])
                u_profile(simple_holder_profile_preview_length, u_width, u_height, u_wall);
        }
    }

    color(holder_color)
        translate([beam_x, beam_y + explode_beam, wood_z])
            cube([simple_holder_beam_width,
                  simple_holder_beam_length,
                  simple_holder_beam_height]);

    color(simple_holder_print_color)
        translate([insert_x, insert_y, insert_z + explode_low])
            lower_rail_insert(
                simple_holder_lower_insert_x,
                simple_holder_lower_insert_y,
                simple_holder_lower_insert_z,
                simple_holder_screw_diameter,
                simple_holder_screw_head_diameter,
                simple_holder_screw_head_height,
                simple_holder_lower_screw_spacing
            );

    color(simple_holder_print_color)
        translate([saddle_x, saddle_y, saddle_z + explode_top])
            upper_rail_saddle(
                simple_holder_mount_width,
                u_width,
                u_height,
                simple_holder_saddle_clearance,
                simple_holder_saddle_wall,
                simple_holder_top_gap,
                simple_holder_lip_depth,
                simple_holder_lip_thickness,
                simple_holder_screw_diameter,
                simple_holder_screw_head_diameter,
                simple_holder_screw_head_height,
                simple_holder_saddle_inner_fillet,
                simple_holder_saddle_outer_fillet
            );

    // Snap-fit Ø18 mm tube holder on top of the front end of the timber beam.
    // Its clip axis runs across X; the round handle is pushed down from +Z.
    clip_y = beam_y + simple_holder_beam_length
           - tube_clip_end_margin - tube_clip_base_length/2;
    clip_z = wood_z + simple_holder_beam_height;
    color(simple_holder_print_color)
        translate([0, clip_y + explode_beam, clip_z])
            tube_clip(
                tube_clip_tube_diameter,
                tube_clip_clearance,
                tube_clip_width,
                tube_clip_wall,
                tube_clip_opening,
                tube_clip_base_width,
                tube_clip_base_length,
                tube_clip_base_thickness,
                tube_clip_screw_diameter,
                tube_clip_screw_head_diameter,
                tube_clip_screw_head_height,
                tube_clip_screw_spacing,
                tube_clip_leadin,
                tube_clip_root_fillet
            );
}

module simple_beam_holder_tube_clip_part() {
    color(simple_holder_print_color)
        tube_clip(
            tube_clip_tube_diameter,
            tube_clip_clearance,
            tube_clip_width,
            tube_clip_wall,
            tube_clip_opening,
            tube_clip_base_width,
            tube_clip_base_length,
            tube_clip_base_thickness,
            tube_clip_screw_diameter,
            tube_clip_screw_head_diameter,
            tube_clip_screw_head_height,
            tube_clip_screw_spacing,
            tube_clip_leadin,
            tube_clip_root_fillet
        );
}

module simple_beam_holder_lower_part() {
    color(simple_holder_print_color)
        lower_rail_insert(
            simple_holder_lower_insert_x,
            simple_holder_lower_insert_y,
            simple_holder_lower_insert_z,
            simple_holder_screw_diameter,
            simple_holder_screw_head_diameter,
            simple_holder_screw_head_height,
            simple_holder_lower_screw_spacing
        );
}

module simple_beam_holder_upper_part() {
    color(simple_holder_print_color)
        upper_rail_saddle(
            simple_holder_mount_width,
            u_width,
            u_height,
            simple_holder_saddle_clearance,
            simple_holder_saddle_wall,
            simple_holder_top_gap,
            simple_holder_lip_depth,
            simple_holder_lip_thickness,
            simple_holder_screw_diameter,
            simple_holder_screw_head_diameter,
            simple_holder_screw_head_height,
            simple_holder_saddle_inner_fillet,
            simple_holder_saddle_outer_fillet
        );
}
