// Snap-fit tube holder for a nominal 18 mm round handle/pipe.
// The clip is printed in PETG and mounted on top of the 33 x 69 timber beam.
// Axes: X = tube axis / clip width, Y = along the beam, Z = up.
// The snap opening faces +Z so the handle is pushed in from above.

module tube_clip_countersunk_hole(h, shaft_d=4.25, head_d=9, head_h=3.2) {
    translate([0,0,-0.1])
        cylinder(h=h+0.2, d=shaft_d);
    translate([0,0,h-head_h])
        cylinder(h=head_h+0.2, d1=shaft_d, d2=head_d);
}

// Cylinder with its axis along X.
module cyl_x(h, d) {
    rotate([0,90,0])
        cylinder(h=h, d=d, center=true);
}

module tube_clip(
    tube_d=18,
    clearance=0.5,
    clip_width=20,
    wall=2.5,
    opening=14.5,
    base_width=30,
    base_length=58,
    base_thickness=5,
    screw_d=4.25,
    screw_head_d=9,
    screw_head_h=3.2,
    screw_spacing=40,
    leadin=5,
    root_fillet=2.5
) {
    inner_d = tube_d + clearance;
    ri = inner_d/2;
    ro = ri + wall;
    overlap = 0.8;
    zc = base_thickness + ro - overlap;

    // The opening itself is tapered. This creates integral lead-in faces at
    // the C-arm tips instead of attaching separate guide lips.
    opening_bottom = opening;
    opening_top = opening + 2*leadin;
    cut_z0 = zc;
    cut_z1 = zc + ro + leadin + 4;

    difference() {
        union() {
            translate([-base_width/2, -base_length/2, 0])
                cube([base_width, base_length, base_thickness]);

            // Main C ring with tapered upward opening.
            difference() {
                translate([0,0,zc])
                    difference() {
                        cyl_x(clip_width, 2*ro);
                        cyl_x(clip_width+1, 2*ri);
                    }

                // Hull between a narrow lower slot and a wider upper slot
                // gives the opening straight, sloping lead-in faces.
                hull() {
                    translate([0, 0, cut_z0])
                        cube([clip_width+2, opening_bottom, 0.4], center=true);
                    translate([0, 0, cut_z1])
                        cube([clip_width+2, opening_top, 0.4], center=true);
                }
            }

            // Compact, fully closed root gussets between the C and the base.
            // Each gusset uses a broad foot pad that starts underneath the C
            // wall and extends outward. This guarantees a continuous solid
            // connection to the base instead of leaving a triangular slit.
            if (root_fillet > 0) {
                root_y = ro * 0.78;
                root_z = base_thickness + max(3.2, root_fillet*1.55);

                root_pad_y = max(1.6, root_fillet*0.75);
                root_pad_z = max(1.8, root_fillet*0.75);

                // Broad foot: overlap both the base and the area directly
                // underneath the lower outer quadrant of the C.
                foot_inner_y = ri * 0.58;
                foot_outer_y = ro + max(3.0, root_fillet*1.4);
                foot_pad_y = foot_outer_y - foot_inner_y;
                foot_center_y = (foot_outer_y + foot_inner_y) / 2;
                foot_pad_z = 2.2;

                for (side=[-1,1]) {
                    hull() {
                        // Root pad embedded in the outside wall of the C.
                        translate([0, side*root_y, root_z])
                            cube([clip_width, root_pad_y, root_pad_z], center=true);

                        // Wide foot pad overlaps the top of the base from
                        // underneath the C wall all the way to the outside.
                        translate([0, side*foot_center_y, base_thickness-0.25])
                            cube([clip_width, foot_pad_y, foot_pad_z], center=true);
                    }
                }
            }
        }

        // Deliberately do NOT re-cut the circular bore after the root gussets.
        // The C-ring bore is already cut before the gussets are added. Keeping
        // the gussets outside that subtraction makes the C-to-base transition
        // fully solid and avoids the triangular opening seen in v45.

        for (y=[-screw_spacing/2, screw_spacing/2])
            translate([0,y,0])
                tube_clip_countersunk_hole(
                    base_thickness,
                    screw_d,
                    screw_head_d,
                    screw_head_h
                );
    }
}
