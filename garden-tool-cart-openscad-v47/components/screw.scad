// Simplified wood screw for visualisation.
// The screw is drawn from 'start' to 'end'. The head is placed at start.

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
                    cylinder(h = len, d = diameter);
                    translate([0, 0, -head_height])
                        cylinder(h = head_height, d1 = head_diameter, d2 = diameter);
                }
    }
}
