use <wood_beam.scad>

// Rear wooden cross bar with a saw-cut slot for one vertical wall of the
// upward-open steel U-profile.
// Open this file directly in OpenSCAD to tune and render the part.

/* [Dimensions] */
bar_width = 44;
bar_depth = 27;
bar_height = 600;
slot_width = 2.2;
slot_depth = 15;

module mount_bar(width, depth, height, slot_width, slot_depth) {
    difference() {
        wood_beam(width, depth, height);

        translate([-1, depth - slot_width, -0.1])
            cube([width + 2, slot_width + 0.1, slot_depth + 0.2]);
    }
}

// Standalone component preview/render.
mount_bar(bar_width, bar_depth, bar_height, slot_width, slot_depth);
