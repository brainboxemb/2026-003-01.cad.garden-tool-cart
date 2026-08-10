include <../config.scad>
use <../components/wood_beam.scad>
use <../components/mount_bar.scad>
use <../components/screw.scad>
use <../components/pocket_hole.scad>
use <../components/u_profile.scad>

function holder_total_width() = 2 * holder_stock_width + holder_side_gap;
function holder_rear_face_y() = holder_stock_depth;


// ---------------------------------------------------------------------------
// Cut-list / dimension reporting
// ---------------------------------------------------------------------------
function _h_brace_cut_length() =
    let(
        brace_dz = holder_stock_depth / cos(holder_brace_angle),
        ta = tan(holder_arm_angle),
        tb = tan(holder_brace_angle),
        rear_y = holder_rear_face_y(),
        y_low = (holder_arm_z - ta * holder_arm_rear_y
            - holder_brace_start_z + tb * rear_y) / (tb - ta),
        y_high = (holder_arm_z - ta * holder_arm_rear_y
            - holder_brace_start_z - brace_dz
            + tb * rear_y) / (tb - ta),
        y_mid = (y_low + y_high) / 2
    )
    (y_mid - rear_y) / cos(holder_brace_angle);

function _h_lower_upright_rear_length() =
    (holder_arm_z + holder_joint_overlap)
    - (holder_lower_mount_z - holder_lower_upright_extra);

function _h_lower_upright_front_length() =
    (holder_arm_z + tan(holder_arm_angle) * holder_stock_depth + holder_joint_overlap)
    - (holder_lower_mount_z - holder_lower_upright_extra);

module holder_cut_list() {
    echo("============================================================");
    echo("SHOVEL HOLDER - CUT LIST / NOMINAL DIMENSIONS (mm)");
    echo("============================================================");
    echo(str("Main timber stock: ", holder_stock_width, " x ", holder_stock_depth, " mm"));
    echo("--- MEMBER ORIENTATIONS (degrees from horizontal) ---");
    echo(str("Upper arms: ", round(holder_arm_angle), " deg"));
    echo(str("Diagonal braces: ", round(holder_brace_angle), " deg"));
    echo("Lower uprights: 90 deg");
    echo("Upper mounting uprights: 90 deg");
    echo("Upper bridge pieces: 0 deg");
    echo("Rear mounting bars: 0 deg");
    echo("Front stop blocks: 90 deg");
    echo("--- CUT LENGTHS ---");
    echo(str("2 x upper arms: ", round(holder_arm_length), " mm @ ", round(holder_arm_angle), " deg"));
    echo(str("2 x diagonal braces: approx. ", round(_h_brace_cut_length()), " mm @ ", round(holder_brace_angle), " deg"));
    echo(str("2 x lower uprights: rear edge ", round(_h_lower_upright_rear_length()),
             " mm / front edge ", round(_h_lower_upright_front_length()), " mm"));
    echo(str("2 x upper mounting uprights: ", holder_upper_upright_height, " mm"));
    echo(str("2 x upper bridge pieces: ", holder_side_gap, " mm long, section ",
             holder_upper_bridge_depth, " x ", holder_upper_bridge_height, " mm"));
    echo(str("2 x rear mounting bars: ", holder_total_width(), " x ", holder_mount_depth,
             " x ", holder_mount_height, " mm"));
    echo(str("2 x front stop blocks: ", holder_stock_width, " x ", holder_stop_depth,
             " x ", holder_stop_height, " mm"));
    echo(str("Clear gap between arms: ", holder_side_gap, " mm"));
    echo(str("Upper arm height above upper rail top: ", holder_upper_clearance, " mm"));
    echo(str("U-profile support spacing: ", 2*u_pitch, " mm (one rail skipped)"));
    echo(str("Kreg R3 hole spacing: ", kreg_r3_hole_spacing, " mm; pocket screw: ", pocket_screw_length, " mm"));
    echo("============================================================");
}

// ---------------------------------------------------------------------------
// Pocket-hole helpers
// ---------------------------------------------------------------------------
function _h_v2_add(a,b) = [a[0]+b[0], a[1]+b[1]];
function _h_v2_mul(v,s) = [v[0]*s, v[1]*s];

function _h_xbase(side, exploded=false) =
    side * (holder_stock_width + holder_side_gap)
    + (exploded ? (side == 0 ? -exploded_side_x : exploded_side_x) : 0);

function _h_inner_x(side, exploded=false) =
    side == 0 ? _h_xbase(side, exploded) + holder_stock_width + 0.20
              : _h_xbase(side, exploded) - 0.20;

function _h_pocket_axis(side, yz_toward_joint) =
    let(
        xin = side == 0 ? -1 : 1,
        a = pocket_test_drill_angle
    )
    [xin * sin(a),
     yz_toward_joint[0] * cos(a),
     yz_toward_joint[1] * cos(a)];

function _h_p(entry, axis, dist) =
    [entry[0]+axis[0]*dist,
     entry[1]+axis[1]*dist,
     entry[2]+axis[2]*dist];

module _h_pocket_bore(entry, axis) {
    pocket_hole_bore(entry, _h_p(entry, axis, 100),
                     pocket_d=9.5,
                     pilot_d=4.2,
                     pocket_length=29,
                     pilot_length=90);
}

module _h_pocket_screw(entry, axis) {
    seat = 20;
    p1 = _h_p(entry, axis, seat);
    p2 = _h_p(p1, axis, pocket_screw_length);
    screw_between(p1, p2,
                  screw_diameter,
                  screw_head_diameter,
                  screw_head_height);
}

// Lower vertical member -> arm pocket pair.
//
// This is the correct Kreg-style orientation for this joint: the pockets are
// drilled in the broad INSIDE face of the lower vertical member, immediately
// below the arm.  The drill/screw axis runs mostly UP the vertical member and
// only slightly across its 27 mm thickness, so the screw crosses the sloping
// top joint and continues into the arm above.
//
// The two R3 holes are spaced across the 44 mm depth of the timber.
function _h_arm_rear_entries(side, exploded=false) =
    let(
        x = _h_inner_x(side, exploded),
        hs = kreg_r3_hole_spacing/2,
        yc = holder_stock_depth/2,
        y1 = yc - hs,
        y2 = yc + hs,
        // Keep the pocket mouths a little below the actual sloping joint.
        // The top of the vertical member follows the arm underside.
        drop = 22,
        z1 = holder_arm_z + tan(holder_arm_angle) * (y1-holder_arm_rear_y) - drop,
        z2 = holder_arm_z + tan(holder_arm_angle) * (y2-holder_arm_rear_y) - drop
    )
    [[x,y1,z1], [x,y2,z2]];

// Standard pocket-hole direction: about 15 degrees into the 27 mm thickness,
// but primarily UP toward the arm.  This is what makes the screw cross the
// wood-to-wood joint instead of pointing into free space.
function _h_arm_rear_axis(side) = _h_pocket_axis(side, [0, 1]);

function _h_brace_rear_entries(side, exploded=false) =
    let(
        x = _h_inner_x(side, exploded),
        yoff = exploded ? exploded_brace_y : 0,
        y = holder_rear_face_y() + pocket_test_entry_back + yoff,
        dz = holder_stock_depth / cos(holder_brace_angle),
        zc = holder_brace_start_z
             + tan(holder_brace_angle) * pocket_test_entry_back
             + dz/2,
        hs = kreg_r3_hole_spacing/2
    )
    [[x,y,zc-hs], [x,y,zc+hs]];

function _h_brace_rear_axis(side) = _h_pocket_axis(side, [ -1, 0 ]);

function _h_brace_joint_points() =
    let(
        brace_dz = holder_stock_depth / cos(holder_brace_angle),
        ta = tan(holder_arm_angle),
        tb = tan(holder_brace_angle),
        y_low = (holder_arm_z - ta * holder_arm_rear_y
            - holder_brace_start_z + tb * holder_rear_face_y()) / (tb - ta),
        y_high = (holder_arm_z - ta * holder_arm_rear_y
            - holder_brace_start_z - brace_dz
            + tb * holder_rear_face_y()) / (tb - ta),
        z_low = holder_arm_z + ta * (y_low - holder_arm_rear_y),
        z_high = holder_arm_z + ta * (y_high - holder_arm_rear_y)
    )
    [[y_low,z_low],[y_high,z_high]];

function _h_brace_upper_entries(side, exploded=false) =
    let(
        jp = _h_brace_joint_points(),
        mid = [(jp[0][0]+jp[1][0])/2, (jp[0][1]+jp[1][1])/2],
        t = [cos(holder_arm_angle), sin(holder_arm_angle)],
        n_in = [sin(holder_arm_angle), -cos(holder_arm_angle)],
        c = _h_v2_add(mid, _h_v2_mul(n_in, pocket_test_entry_back)),
        hs = kreg_r3_hole_spacing/2,
        p1 = _h_v2_add(c, _h_v2_mul(t,-hs)),
        p2 = _h_v2_add(c, _h_v2_mul(t, hs)),
        x = _h_inner_x(side, exploded),
        yoff = exploded ? exploded_brace_y : 0
    )
    [[x,p1[0]+yoff,p1[1]], [x,p2[0]+yoff,p2[1]]];

function _h_brace_upper_axis(side) =
    let(n_to_arm=[-sin(holder_arm_angle), cos(holder_arm_angle)])
    _h_pocket_axis(side, n_to_arm);

module _h_arm_pockets(side=0, exploded=false) {
    entries = _h_arm_rear_entries(side, exploded);
    axis = _h_arm_rear_axis(side);
    for (e=entries) _h_pocket_bore(e, axis);
}

module _h_brace_pockets(side=0, exploded=false) {
    entries1 = _h_brace_rear_entries(side, exploded);
    axis1 = _h_brace_rear_axis(side);
    for (e=entries1) _h_pocket_bore(e, axis1);

    entries2 = _h_brace_upper_entries(side, exploded);
    axis2 = _h_brace_upper_axis(side);
    for (e=entries2) _h_pocket_bore(e, axis2);
}

// Lower vertical side member.  Its top follows the underside of the slightly
// rising arm, so the two wooden parts meet over the full 44 mm depth instead
// of only touching at the rear edge.  A sub-millimetre overlap compensates
// for the visual edge rounding used on the separate wooden solids.
module holder_back_member(side = 0, exploded = false) {
    x0 = _h_xbase(side, exploded);
    yoff = 0;

    top_rear = holder_arm_z + holder_joint_overlap;
    top_front = holder_arm_z
        + tan(holder_arm_angle) * holder_stock_depth
        + holder_joint_overlap;

    // Extend the lower vertical member below the lower mounting bar.
    // The U-profile itself sits behind the vertical timber, so this extra
    // length does not pass through the steel.  It simply gives the lower
    // cross bar a proper wooden side member to screw into and prevents the
    // cross bar from hanging below the uprights.
    bottom_z = holder_lower_mount_z - holder_lower_upright_extra;

    difference() {
        translate([x0, yoff, 0])
            wood_prism_yz(holder_stock_width, [
                [0, bottom_z],
                [holder_stock_depth, bottom_z],
                [holder_stock_depth, top_front],
                [0, top_rear]
            ]);
        _h_arm_pockets(side, exploded);
    }
}

module holder_arm(side = 0, exploded = false) {
    x0 = _h_xbase(side, exploded);
    yoff = exploded ? exploded_arm_y : 0;

    translate([x0, yoff, 0])
        wood_arm_yz(
            holder_stock_width,
            holder_arm_rear_y,
            holder_arm_z,
            holder_arm_length,
            holder_stock_depth,
            holder_arm_angle
        );
}

module holder_brace(side = 0, exploded = false) {
    x0 = _h_xbase(side, exploded);
    yoff = exploded ? exploded_brace_y : 0;

    difference() {
        translate([x0, yoff, 0])
            wood_brace_to_arm_yz(
                holder_stock_width,
                holder_rear_face_y(),
                holder_brace_start_z,
                holder_stock_depth,
                holder_brace_angle,
                holder_arm_z,
                holder_arm_angle,
                holder_arm_rear_y
            );
        _h_brace_pockets(side, exploded);
    }
}

// Lower rear bar: still full-width and catches the lower U-profile.
module holder_lower_mount_bar(exploded = false) {
    yoff = exploded ? exploded_lower_mount_y : 0;
    y0 = -holder_mount_depth - yoff;
    translate([0, y0, holder_lower_mount_z])
        mount_bar(
            holder_total_width(),
            holder_mount_depth,
            holder_mount_height,
            holder_slot_width,
            holder_slot_depth
        );
}

// Upper rear connection.
// Like the lower connection, the U-profile is now caught by a dedicated
// full-width cross mounting bar.  No vertical timber passes through the
// steel rail.  The rest of the holder starts above this bar; the arm is
// deliberately 100 mm above the top of the selected U-profile.
module holder_upper_mount_bar(exploded = false) {
    yoff = exploded ? exploded_mount_y : 0;
    y0 = -holder_mount_depth - yoff;
    translate([0, y0, holder_upper_mount_z])
        mount_bar(
            holder_total_width(),
            holder_mount_depth,
            holder_mount_height,
            holder_slot_width,
            holder_slot_depth
        );
}

// Upper vertical members start on top of the upper mounting bar.  They have
// the same 27 x 44 orientation as the arm/side members and contain no slot.
module holder_upper_mount_upright(side = 0, exploded = false) {
    x0 = _h_xbase(side, exploded);
    yoff = exploded ? exploded_mount_y : 0;
    y0 = -holder_upper_upright_depth - yoff;

    translate([x0, y0, holder_upper_upright_z])
        wood_beam(
            holder_stock_width,
            holder_upper_upright_depth + holder_joint_overlap,
            holder_upper_upright_height
        );
}

// Two small blocks connect the upper uprights.  They sit ABOVE the shovel
// working zone, so the central gap remains clear at arm height.
module holder_upper_bridge(zpos, exploded = false) {
    yoff = exploded ? exploded_mount_y : 0;

    // Same 27 x 44 stock as the rest of the holder, rotated for the bridge:
    // 27 mm deep (Y) and 44 mm high (Z).  It sits against the REAR face of
    // the 44 mm deep uprights, leaving 17 mm clear at their front side.
    // That makes the transitions easier to read and keeps the arm-side area open.
    x_bridge = holder_stock_width;
    bridge_y = -holder_upper_upright_depth - yoff;

    translate([x_bridge, bridge_y, zpos])
        wood_beam(
            holder_side_gap,
            holder_upper_bridge_depth,
            holder_upper_bridge_height
        );
}

module holder_mount_structure(exploded = false) {
    holder_lower_mount_bar(exploded);
    holder_upper_mount_bar(exploded);

    for (side=[0:1])
        holder_upper_mount_upright(side, exploded);

    holder_upper_bridge(holder_upper_bridge_z1, exploded);
    holder_upper_bridge(holder_upper_bridge_z2, exploded);
}

// Small wooden block on top of the front of each arm. It is intentionally
// simple at this stage: a replaceable screwed-on stop rather than steel angle.
module holder_front_stop(side = 0, exploded = false) {
    x0 = _h_xbase(side, exploded);
    yoff = exploded ? exploded_arm_y : 0;
    zoff = exploded ? exploded_stop_z : 0;

    front_y = holder_arm_rear_y + holder_arm_length * cos(holder_arm_angle);
    y0 = front_y - holder_stop_back - holder_stop_depth;
    arm_top_z_at_y = holder_arm_z
        + tan(holder_arm_angle) * (y0 - holder_arm_rear_y)
        + holder_stock_depth / cos(holder_arm_angle);

    translate([x0, y0 + yoff, arm_top_z_at_y + zoff])
        wood_beam(holder_stock_width, holder_stop_depth, holder_stop_height);
}

module _lower_mount_bar_screws(exploded=false) {
    yoff = exploded ? exploded_lower_mount_y : 0;

    // One conventional screw per side.  Place it in the solid wood ABOVE
    // the saw-cut / U-profile engagement zone, so the screw can never
    // collide with the steel rail.  It runs from the rear face of the
    // cross bar into the corresponding vertical side member.
    screw_z = holder_lower_mount_z + holder_slot_depth + holder_lower_screw_above_slot;

    for (side=[0:1]) {
        xbase = _h_xbase(side, false);
        screw_between(
            [xbase + holder_stock_width / 2,
             -holder_mount_depth - yoff - 0.6,
             screw_z],
            [xbase + holder_stock_width / 2,
             holder_lower_screw_embed,
             screw_z],
            screw_diameter,
            screw_head_diameter,
            screw_head_height
        );
    }
}

// One conventional screw per side in the upper mounting bar, mirroring the
// lower mounting bar.  The screws sit above the slot so they cannot collide
// with the steel U-profile.
module _upper_mount_bar_screws(exploded=false) {
    yoff = exploded ? exploded_mount_y : 0;
    screw_z = holder_upper_mount_z + holder_slot_depth + holder_upper_screw_above_slot;

    for (side=[0:1]) {
        xbase = _h_xbase(side, false);
        screw_between(
            [xbase + holder_stock_width / 2,
             -holder_mount_depth - yoff - 0.6,
             screw_z],
            [xbase + holder_stock_width / 2,
             holder_upper_screw_embed,
             screw_z],
            screw_diameter,
            screw_head_diameter,
            screw_head_height
        );
    }
}

// Simple cross-screws from each outer upright into each bridge block.
// These are deliberately conventional screws; pocket geometry can be refined
// later if needed once the overall upper-frame proportions are approved.
module _upper_bridge_screws(exploded=false) {
    yoff = exploded ? exploded_mount_y : 0;
    for (zpos=[holder_upper_bridge_z1, holder_upper_bridge_z2]) {
        zc = zpos + holder_upper_bridge_height/2;
        yc = -holder_upper_upright_depth + holder_upper_bridge_depth/2 - yoff;

        // left side -> bridge
        screw_between(
            [-0.5 + (exploded ? -exploded_side_x : 0), yc, zc],
            [holder_stock_width + 16, yc, zc],
            screw_diameter, screw_head_diameter, screw_head_height
        );

        // right side -> bridge
        screw_between(
            [holder_total_width() + 0.5 + (exploded ? exploded_side_x : 0), yc, zc],
            [holder_stock_width + holder_side_gap - 16, yc, zc],
            screw_diameter, screw_head_diameter, screw_head_height
        );
    }
}

module _front_stop_screws(side=0, exploded=false) {
    x0 = _h_xbase(side, exploded);
    yoff = exploded ? exploded_arm_y : 0;
    zoff = exploded ? exploded_stop_z : 0;

    front_y = holder_arm_rear_y + holder_arm_length * cos(holder_arm_angle);
    y0 = front_y - holder_stop_back - holder_stop_depth;
    arm_top_z_at_y = holder_arm_z
        + tan(holder_arm_angle) * (y0 - holder_arm_rear_y)
        + holder_stock_depth / cos(holder_arm_angle);

    for (yy=[holder_stop_depth*0.30, holder_stop_depth*0.70]) {
        screw_between(
            [x0 + holder_stock_width/2,
             y0 + yy + yoff,
             arm_top_z_at_y + holder_stop_height + zoff + 0.5],
            [x0 + holder_stock_width/2,
             y0 + yy + yoff,
             arm_top_z_at_y - holder_stop_screw_length + zoff],
            screw_diameter,
            screw_head_diameter,
            screw_head_height
        );
    }
}

module holder_screws(exploded = false) {
    for (side=[0:1]) {
        ea = _h_arm_rear_entries(side, exploded);
        aa = _h_arm_rear_axis(side);
        for (e=ea) _h_pocket_screw(e, aa);

        eb = _h_brace_rear_entries(side, exploded);
        ab = _h_brace_rear_axis(side);
        for (e=eb) _h_pocket_screw(e, ab);

        eu = _h_brace_upper_entries(side, exploded);
        au = _h_brace_upper_axis(side);
        for (e=eu) _h_pocket_screw(e, au);

        _front_stop_screws(side, exploded);
    }

    _lower_mount_bar_screws(exploded);
    _upper_mount_bar_screws(exploded);
    _upper_bridge_screws(exploded);
}

module shovel_holder(show_screws = true, exploded = false) {
    color(holder_color) {
        for (side = [0 : 1]) {
            holder_back_member(side, exploded);
            holder_arm(side, exploded);
            holder_brace(side, exploded);
            holder_front_stop(side, exploded);
        }
        holder_mount_structure(exploded);
    }

    if (show_screws)
        color(screw_color)
            holder_screws(exploded);
}

module shovel_holder_on_profile(show_screws = true, exploded = false) {
    test_profile_length = holder_total_width() + 120;
    // The holder catches the OUTER wall of the upward-open U-profile.
    // The rest of the U therefore extends behind the holder (negative Y),
    // instead of passing through the wooden side frame.
    profile_y = -u_width;

    // Upper rail: align its top with the top of the upper saw cut.
    upper_profile_z = holder_upper_mount_z - u_height + holder_slot_depth;
    lower_profile_z = upper_profile_z - 2 * u_pitch;

    color(frame_color) {
        translate([-60, profile_y, upper_profile_z])
            u_profile(test_profile_length, u_width, u_height, u_wall);
        translate([-60, profile_y, lower_profile_z])
            u_profile(test_profile_length, u_width, u_height, u_wall);
    }

    shovel_holder(show_screws, exploded);
}
