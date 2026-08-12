// Base plate component.
// Open this file directly in OpenSCAD to tune and render the part.

/* [Dimensions] */
plate_width = 620;
plate_depth = 880;
plate_thickness = 18;

module base_plate(width, depth, thickness) {
    cube([width, depth, thickness]);
}

// Standalone component preview/render.
base_plate(plate_width, plate_depth, plate_thickness);
