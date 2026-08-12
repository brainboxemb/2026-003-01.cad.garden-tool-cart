// Simplified wood screw for visualisation.
// Open this file directly in OpenSCAD to tune and render the screw.

/* [Dimensions] */
screw_length = 40;
screw_diameter = 4;
screw_head_diameter = 9;
screw_head_height = 3.2;

module screw_between(start, end, diameter, head_diameter, head_height) {
    v = end - start;
    len = norm(v);

    if (len > 0) {
        dir = v / len;
        axis = cross([0, 0, 1], dir);
        angle = acos(dir[2]);

        translate(start)
            rotate(a = angle, v = norm(axis) < 0.0001 ? [1, 0, 0] : axis)
                union() {
                    cylinder(h = len, d = diameter, $fn = 48);
                    translate([0, 0, -head_height])
                        cylinder(h = head_height, d1 = head_diameter, d2 = diameter, $fn = 48);
                }
    }
}

// Standalone component preview/render.
screw_between(
    [0, 0, 0],
    [0, 0, screw_length],
    screw_diameter,
    screw_head_diameter,
    screw_head_height
);
