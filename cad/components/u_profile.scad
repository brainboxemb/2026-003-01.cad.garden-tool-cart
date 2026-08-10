// U-profile, open side facing upward.
// length = X, depth = Y, height = Z.
module u_profile(length, depth, height, wall) {
    union() {
        // Bottom web
        cube([length, depth, wall]);

        // Front and rear walls
        cube([length, wall, height]);
        translate([0, depth - wall, 0])
            cube([length, wall, height]);
    }
}
