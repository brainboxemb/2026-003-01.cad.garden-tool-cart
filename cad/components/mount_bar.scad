include <../config.scad>
use <wood_beam.scad>

// Rear wooden cross bar with a saw-cut slot for one vertical wall of the
// upward-open steel U-profile.
module mount_bar(width, depth, height, slot_width, slot_depth) {
    difference() {
        wood_beam(width, depth, height);

        translate([-1, depth - slot_width, -0.1])
            cube([width + 2, slot_width + 0.1, slot_depth + 0.2]);
    }
}
