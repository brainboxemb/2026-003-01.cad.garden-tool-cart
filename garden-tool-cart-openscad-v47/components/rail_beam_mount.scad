// 3D printed mounting parts for a 33 x 69 mm wooden beam between two U-rails.
// Axes follow the cart convention: X across the rack, Y front/back, Z vertical.

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
// Two countersunk screws run upward through the insert into the underside of wood.
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

        for (x = [size_x/2 - screw_spacing/2,
                  size_x/2 + screw_spacing/2])
            translate([x, size_y/2, 0])
                // Countersink is on the bottom face so the screw heads stay
                // clear of the steel web. The shaft now always runs through
                // the complete insert and is also visible in the loose view.
                countersunk_z_hole_from_bottom(
                    size_z,
                    screw_d,
                    head_d,
                    head_h
                );
    }
}

// Upper saddle: a larger U that fits OUTSIDE the complete upper steel U-profile.
// Its thick bottom fills the vertical gap between the 69 mm timber and the rail.
// Two outside lips rest on the timber and are screwed down after the timber is placed.
module upper_rail_saddle(
    body_x = 33,
    rail_depth = 30,
    rail_height = 30,
    clearance = 0.6,
    wall = 5,
    bottom = 9,
    lip_depth = 16,
    lip_thickness = 5,
    screw_d = 4.25,
    head_d = 9,
    head_h = 3.2,
    inner_fillet = 1.2,
    outer_fillet = 3
) {
    inside_y = rail_depth + 2 * clearance;
    inside_z = rail_height + clearance;
    outer_y = inside_y + 2 * wall;
    outer_z = bottom + inside_z;

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
        for (y = [-lip_depth/2, outer_y + lip_depth/2])
            translate([body_x/2, y, 0])
                countersunk_z_hole(lip_thickness, screw_d, head_d, head_h);
    }
}
