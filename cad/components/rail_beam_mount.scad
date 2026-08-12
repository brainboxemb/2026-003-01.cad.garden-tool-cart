// 3D printed mounting parts for a 74 x 18 mm multiplex strip between two U-rails.
// Axes follow the cart convention: X across the rack, Y front/back, Z vertical.
// Open this file directly in OpenSCAD and choose the part in the Customizer.

/* [Standalone preview] */
part = "lower"; // [lower:Lower insert, upper_4mm:Upper saddle 4 mm, upper_3mm:Upper saddle 3 mm under rail, both:Lower + upper 4 mm]

/* [Common] */
mount_width = 18;
screw_diameter = 4.25;
screw_head_diameter = 9;
screw_head_height = 3.2;

/* [Lower insert] */
lower_insert_depth = 24.8;
lower_insert_height = 10;
lower_screw_spacing = 12;

/* [Upper saddle] */
rail_depth = 30;
rail_height = 30;
saddle_clearance = 0.6;
saddle_wall = 5;
saddle_bottom = 4;
saddle_bottom_alt = 3; // alternative: only the area directly under the steel U-rail is 3 mm
saddle_wrap_height = 10;
saddle_lip_depth = 16;
saddle_lip_thickness = 4;
saddle_inner_fillet = 1.2;
saddle_outer_fillet = 3;
saddle_bottom_relief_diameter = 6.0;
saddle_bottom_relief_depth = 0.2; // shallow print relief on the NON-countersunk face

// Rounded rectangular prism with its long axis in X.
// Used for the saddle so the Y/Z cross-section can have printable fillets.
module rounded_prism_x(size_x, size_y, size_z, radius) {
    r = min(radius, min(size_y, size_z) / 2);

    if (r <= 0) {
        cube([size_x, size_y, size_z]);
    } else {
        hull() {
            for (y = [r, size_y - r])
                for (z = [r, size_z - r])
                    translate([0, y, z])
                        rotate([0, 90, 0])
                            cylinder(h = size_x, r = r);
        }
    }
}

// Countersunk through-hole along Z, with the countersink on the TOP face.
module countersunk_z_hole(h, shaft_d = 4.25, head_d = 9, head_h = 3.2) {
    translate([0, 0, -0.1])
        cylinder(h = h + 0.2, d = shaft_d);

    translate([0, 0, h - head_h])
        cylinder(h = head_h + 0.2, d1 = shaft_d, d2 = head_d);
}

// Countersunk through-hole along Z, with the countersink on the BOTTOM face.
// Kept separate from countersunk_z_hole() so the through bore cannot be lost
// by rotating a subtraction volume around the wrong reference plane.
module countersunk_z_hole_from_bottom(h, shaft_d = 4.25, head_d = 9, head_h = 3.2) {
    translate([0, 0, -0.1])
        cylinder(h = h + 0.2, d = shaft_d);

    translate([0, 0, -0.1])
        cylinder(h = head_h + 0.2, d1 = head_d, d2 = shaft_d);
}

// Lower insert: sits inside the open channel of the lower steel U-profile.
// Two countersunk screws run upward through the insert into the underside of the multiplex strip.
module lower_rail_insert(
    size_x = 30,
    size_y = 26,
    size_z = 26,
    screw_d = 4.25,
    head_d = 9,
    head_h = 3.2,
    screw_spacing = 14
) {
    difference() {
        cube([size_x, size_y, size_z]);

        // With an 18 mm wide multiplex strip there is not enough X width
        // for two Ø9 mm countersinks side-by-side. Put the two screws along
        // the 24.8 mm rail-channel direction instead.
        for (y = [size_y/2 - screw_spacing/2,
                  size_y/2 + screw_spacing/2])
            translate([size_x/2, y, 0])
                // Countersink is on the bottom face. The shaft runs through
                // the complete 10 mm insert into the underside of the strip.
                countersunk_z_hole_from_bottom(
                    size_z,
                    screw_d,
                    head_d,
                    head_h
                );
    }
}

// Upper saddle: a larger U that fits OUTSIDE the complete upper steel U-profile.
// The mounting lips/base remain 4 mm thick. `bottom` controls only the local
// thickness directly underneath the steel U-rail. This allows a 4 mm standard
// version and a 3 mm rail-seat version to compensate for variation between
// the cart arms, while the underside against the wood stays on the same plane.
module upper_rail_saddle(
    body_x = 33,
    rail_depth = 30,
    rail_height = 30,
    clearance = 0.6,
    wall = 5,
    bottom = 4,
    wrap_height = 10,
    lip_depth = 16,
    lip_thickness = 4,
    screw_d = 4.25,
    head_d = 9,
    head_h = 3.2,
    inner_fillet = 1.2,
    outer_fillet = 3,
    bottom_relief_d = 6.0,
    bottom_relief_h = 0.2
) {
    inside_y = rail_depth + 2 * clearance;
    // The saddle only needs short locating arms along the lower part of the
    // steel U-profile. It does not need to cover the full 30 mm rail height.
    inside_z = wrap_height + clearance;
    outer_y = inside_y + 2 * wall;
    outer_z = bottom + wrap_height;

    difference() {
        union() {
            // Main U body. Keep the OUTER lower corners square: the larger
            // fillet belongs at the transition from each U leg into its
            // mounting lip, not underneath the U leg.
            // The rounded cavity retains the small inside fillet requested
            // where the upper rail approaches the thick printed bottom.
            difference() {
                cube([body_x, outer_y, outer_z]);

                translate([-0.1, wall, bottom])
                    rounded_prism_x(
                        body_x + 0.2,
                        inside_y,
                        inside_z + inner_fillet + 1,
                        inner_fillet
                    );
            }

            // Two mounting lips on the outside of the U bottom.
            translate([0, -lip_depth, 0])
                cube([body_x, lip_depth, lip_thickness]);
            translate([0, outer_y, 0])
                cube([body_x, lip_depth, lip_thickness]);

            // Larger concave fillets at the U-leg -> side-lip transitions.
            // These add material above each lip and are tangent to both the
            // vertical U wall and the horizontal top of the lip.
            if (outer_fillet > 0) {
                r = min(outer_fillet, lip_depth);

                // Front/negative-Y lip.
                difference() {
                    translate([0, -r, lip_thickness])
                        cube([body_x, r, r]);
                    translate([-0.1, -r, lip_thickness + r])
                        rotate([0, 90, 0])
                            cylinder(h = body_x + 0.2, r = r);
                }

                // Rear/positive-Y lip.
                difference() {
                    translate([0, outer_y, lip_thickness])
                        cube([body_x, r, r]);
                    translate([-0.1, outer_y + r, lip_thickness + r])
                        rotate([0, 90, 0])
                            cylinder(h = body_x + 0.2, r = r);
                }
            }
        }

        // One countersunk screw in each lip, driven down into the top of the timber.
        // The countersink is on the TOP face. A shallow cylindrical relief is
        // added on the opposite (BOTTOM / non-countersunk) face for printing.
        for (y = [-lip_depth/2, outer_y + lip_depth/2]) {
            translate([body_x/2, y, 0])
                countersunk_z_hole(lip_thickness, screw_d, head_d, head_h);

            if (bottom_relief_h > 0 && bottom_relief_d > screw_d)
                translate([body_x/2, y, -0.1])
                    cylinder(h = bottom_relief_h + 0.1, d = bottom_relief_d);
        }
    }
}


module _rail_beam_mount_standalone() {
    if (part == "lower" || part == "both")
        lower_rail_insert(
            size_x=mount_width,
            size_y=lower_insert_depth,
            size_z=lower_insert_height,
            screw_d=screw_diameter,
            head_d=screw_head_diameter,
            head_h=screw_head_height,
            screw_spacing=lower_screw_spacing
        );

    if (part == "upper_4mm" || part == "upper_3mm" || part == "both")
        translate([part == "both" ? mount_width + 15 : 0, 0, 0])
            upper_rail_saddle(
                body_x=mount_width,
                rail_depth=rail_depth,
                rail_height=rail_height,
                clearance=saddle_clearance,
                wall=saddle_wall,
                bottom=(part == "upper_3mm" ? saddle_bottom_alt : saddle_bottom),
                wrap_height=saddle_wrap_height,
                lip_depth=saddle_lip_depth,
                lip_thickness=saddle_lip_thickness,
                screw_d=screw_diameter,
                head_d=screw_head_diameter,
                head_h=screw_head_height,
                inner_fillet=saddle_inner_fillet,
                outer_fillet=saddle_outer_fillet,
                bottom_relief_d=saddle_bottom_relief_diameter,
                bottom_relief_h=saddle_bottom_relief_depth
            );
}

// Standalone component preview/render.
_rail_beam_mount_standalone();
