// Generic wooden member helpers.
// Open this file directly in OpenSCAD to tune and render a simple beam.

/* [Standalone preview] */
beam_width = 18;
beam_depth = 75;
beam_height = 300;
beam_edge_radius = 0.9;

// Wooden members get a very small visual corner radius. The radius is
// deliberately subtle: it helps separate adjoining parts in preview without
// materially changing the nominal dimensions used for the design.
module wood_beam(width, depth, height, radius = 0.9) {
    r = min(radius, min(width, depth) / 4);
    if (r <= 0)
        cube([width, depth, height]);
    else
        linear_extrude(height = height)
            offset(r = r)
                offset(delta = -r)
                    square([width, depth]);
}

// Extrude a 2D polygon drawn in the Y/Z plane through X.
module wood_prism_yz(width, points, radius = 0.9) {
    multmatrix([
        [0, 0, 1, 0],
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = width)
            if (radius > 0)
                offset(r = radius)
                    offset(delta = -radius)
                        polygon(points = points);
            else
                polygon(points = points);
}

module wood_arm_yz(width, rear_y, bottom_z, length, thickness, angle) {
    front_y = rear_y + length * cos(angle);
    rise    = (front_y - rear_y) * tan(angle);
    dz      = thickness / cos(angle);

    wood_prism_yz(width, [
        [rear_y,  bottom_z],
        [front_y, bottom_z + rise],
        [front_y, bottom_z + rise + dz],
        [rear_y,  bottom_z + dz]
    ]);
}

module wood_brace_to_arm_yz(
    width,
    rear_y,
    lower_z,
    thickness,
    brace_angle,
    arm_bottom_z,
    arm_angle,
    arm_rear_y = undef
) {
    ary = is_undef(arm_rear_y) ? rear_y : arm_rear_y;
    brace_dz = thickness / cos(brace_angle);
    ta = tan(arm_angle);
    tb = tan(brace_angle);

    y_low = (arm_bottom_z - ta * ary - lower_z + tb * rear_y) / (tb - ta);
    y_high = (arm_bottom_z - ta * ary - lower_z - brace_dz + tb * rear_y) / (tb - ta);

    z_low  = lower_z + tb * (y_low - rear_y);
    z_high = lower_z + brace_dz + tb * (y_high - rear_y);

    wood_prism_yz(width, [
        [rear_y, lower_z],
        [y_low,  z_low],
        [y_high, z_high],
        [rear_y, lower_z + brace_dz]
    ]);
}

// Standalone component preview/render.
wood_beam(beam_width, beam_depth, beam_height, beam_edge_radius);
