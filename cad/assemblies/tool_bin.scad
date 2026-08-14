include <../config.scad>
use <../components/screw.scad>

// Full 18 mm plywood / underlayment tool bin.
// Construction:
// - full-size 18 mm bottom panel;
// - front and rear long panels run across the full cart width;
// - end panels fit between the long panels;
// - no internal corner battens;
// - black 4x40 mm screws are shown at the outside corners;
// - the bottom is screwed upward from underneath.
//
// When exploded=true, every panel moves away from the assembled box in the
// direction from which it is fitted. Screws move with the panel whose screw
// head they belong to. This makes the assembly sequence readable instead of
// simply spreading unrelated geometry apart.
module tool_bin(show_screws = true, exploded = false) {
    ex = exploded ? tool_bin_exploded_end : 0;
    ey = exploded ? tool_bin_exploded_long : 0;
    ez = exploded ? tool_bin_exploded_bottom : 0;

    // Bottom moves downward.
    translate([0, 0, -ez])
        tool_bin_bottom_panel();

    // Long panels move outward in Y.
    translate([0, -ey, 0])
        tool_bin_front_panel();
    translate([0, ey, 0])
        tool_bin_rear_panel();

    // End panels move outward in X.
    translate([-ex, 0, 0])
        tool_bin_left_panel();
    translate([ex, 0, 0])
        tool_bin_right_panel();

    if (show_screws) {
        // The visible screw heads belong to the long panels, so they follow
        // those panels in the exploded view.
        translate([0, -ey, 0])
            tool_bin_front_corner_screws();
        translate([0, ey, 0])
            tool_bin_rear_corner_screws();

        // Bottom screw heads are underneath the bottom panel and move down
        // together with it.
        translate([0, 0, -ez])
            tool_bin_bottom_screws();
    }
}

module tool_bin_bottom_panel() {
    color(tool_bin_bottom_color)
        cube([tool_bin_width, tool_bin_depth, tool_bin_panel_thickness]);
}

module tool_bin_front_panel() {
    t = tool_bin_panel_thickness;
    color(tool_bin_wall_color)
        translate([0, 0, t])
            cube([tool_bin_width, t, tool_bin_wall_height]);
}

module tool_bin_rear_panel() {
    t = tool_bin_panel_thickness;
    color(tool_bin_wall_color)
        translate([0, tool_bin_depth - t, t])
            cube([tool_bin_width, t, tool_bin_wall_height]);
}

module tool_bin_left_panel() {
    t = tool_bin_panel_thickness;
    color(tool_bin_wall_color)
        translate([0, t, t])
            cube([t, tool_bin_depth - 2*t, tool_bin_wall_height]);
}

module tool_bin_right_panel() {
    t = tool_bin_panel_thickness;
    color(tool_bin_wall_color)
        translate([tool_bin_width - t, t, t])
            cube([t, tool_bin_depth - 2*t, tool_bin_wall_height]);
}

// Visible black screws through the front long panel into the two end panels.
module tool_bin_front_corner_screws() {
    bw = tool_bin_width;
    bd = tool_bin_depth;
    t  = tool_bin_panel_thickness;
    z  = t + tool_bin_corner_screw_height;
    embed = tool_bin_screw_length - t;

    color(tool_bin_screw_color) {
        screw_between([t/2, -0.01, z],
                      [t/2, min(t + embed, bd/2), z],
                      tool_bin_screw_diameter,
                      tool_bin_screw_head_diameter,
                      tool_bin_screw_head_height);
        screw_between([bw - t/2, -0.01, z],
                      [bw - t/2, min(t + embed, bd/2), z],
                      tool_bin_screw_diameter,
                      tool_bin_screw_head_diameter,
                      tool_bin_screw_head_height);
    }
}

// Visible black screws through the rear long panel into the two end panels.
module tool_bin_rear_corner_screws() {
    bw = tool_bin_width;
    bd = tool_bin_depth;
    t  = tool_bin_panel_thickness;
    z  = t + tool_bin_corner_screw_height;
    embed = tool_bin_screw_length - t;

    color(tool_bin_screw_color) {
        screw_between([t/2, bd + 0.01, z],
                      [t/2, max(bd - t - embed, bd/2), z],
                      tool_bin_screw_diameter,
                      tool_bin_screw_head_diameter,
                      tool_bin_screw_head_height);
        screw_between([bw - t/2, bd + 0.01, z],
                      [bw - t/2, max(bd - t - embed, bd/2), z],
                      tool_bin_screw_diameter,
                      tool_bin_screw_head_diameter,
                      tool_bin_screw_head_height);
    }
}

// Bottom screws are driven from underneath into the four walls.
module tool_bin_bottom_screws() {
    bw = tool_bin_width;
    bd = tool_bin_depth;
    t  = tool_bin_panel_thickness;
    edge = tool_bin_bottom_screw_edge_offset;
    z0 = -0.01;
    z1 = min(tool_bin_screw_length, 2*t);

    color(tool_bin_screw_color) {
        // Along the two long panels.
        for (x = tool_bin_bottom_screw_x_positions) {
            screw_between([x, t/2, z0], [x, t/2, z1],
                          tool_bin_screw_diameter,
                          tool_bin_screw_head_diameter,
                          tool_bin_screw_head_height);
            screw_between([x, bd - t/2, z0], [x, bd - t/2, z1],
                          tool_bin_screw_diameter,
                          tool_bin_screw_head_diameter,
                          tool_bin_screw_head_height);
        }

        // Two extra underside screws into each end panel.
        for (y = [edge, bd - edge]) {
            screw_between([t/2, y, z0], [t/2, y, z1],
                          tool_bin_screw_diameter,
                          tool_bin_screw_head_diameter,
                          tool_bin_screw_head_height);
            screw_between([bw - t/2, y, z0], [bw - t/2, y, z1],
                          tool_bin_screw_diameter,
                          tool_bin_screw_head_diameter,
                          tool_bin_screw_head_height);
        }
    }
}

// Standalone assembly preview when this file is opened directly.
tool_bin(true, false);
