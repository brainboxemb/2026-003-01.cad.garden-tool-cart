include <../config.scad>

// Wooden members get a very small visual corner radius.  The radius is
// deliberately subtle: it helps separate adjoining parts in preview without
// materially changing the nominal dimensions used for the design.
module wood_beam(width, depth, height, radius = wood_edge_radius) {
    r = min(radius, min(width, depth) / 4);
    if (r <= 0)
        cube([width, depth, height]);
    else
        linear_extrude(height = height)
            offset(r = r)
                offset(delta = -r)
                    square([width, depth]);
}

// Extrude a 2D polygon drawn in the Y/Z plane through X. A small rounding is
// applied to corners in the visible Y/Z outline so joints remain easier to
// read in the OpenSCAD preview.
module wood_prism_yz(width, points, radius = wood_edge_radius) {
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

// Arm with vertical end cuts.
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

// Diagonal brace with a vertical rear cut and an angled front cut that
// follows the underside of the arm. arm_rear_y may differ from brace rear_y;
// this is used by the shovel holder where the upper arm now continues farther
// back than the lower vertical/brace joint.
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

    // arm:        z = arm_bottom_z + ta * (y - ary)
    // brace low:  z = lower_z      + tb * (y - rear_y)
    // brace high: z = lower_z + brace_dz + tb * (y - rear_y)
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
