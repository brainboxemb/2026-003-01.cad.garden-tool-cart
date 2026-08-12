// Upright component.
// Open this file directly in OpenSCAD to tune and render the part.

/* [Dimensions] */
upright_width = 20;
upright_depth = 40;
upright_height = 1400;

module upright(width, depth, height) {
    cube([width, depth, height]);
}

// Standalone component preview/render.
upright(upright_width, upright_depth, upright_height);
