// Steel U-profile, open side facing upward.
// Axes: length = X, depth = Y, height = Z.
// Open this file directly in OpenSCAD to tune and render the part.

/* [Dimensions] */
profile_length = 840;
profile_depth = 30;
profile_height = 30;
profile_wall = 2;

module u_profile(length, depth, height, wall) {
    union() {
        cube([length, depth, wall]);
        cube([length, wall, height]);
        translate([0, depth - wall, 0])
            cube([length, wall, height]);
    }
}

// Standalone component preview/render.
u_profile(profile_length, profile_depth, profile_height, profile_wall);
