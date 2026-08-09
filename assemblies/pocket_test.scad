include <../config.scad>
use <../components/pocket_hole.scad>
use <../components/screw.scad>

// Pocket-hole joint geometry tests.
//
// Coordinate system used in these views:
//   X = along the receiving timber
//   Y = across the joint; receiver is Y >= 0
//   Z = timber thickness
//
// The angled member centreline meets the receiving timber exactly at [0,0].
// Its end is clipped at Y=0, so the two pieces meet on one clean joint plane.
// Pocket-hole positions are defined in the LOCAL coordinate system of the
// angled member. This is important: at 45/55 degrees the two Kreg holes rotate
// with the timber instead of staying aligned to global X/Y.

function _pt_add(a,b) = [a[0]+b[0], a[1]+b[1], a[2]+b[2]];
function _pt_mul(v,s) = [v[0]*s, v[1]*s, v[2]*s];

// Direction from the joint into the free end of the mating member.
function _mate_d(angle) = [-cos(angle), -sin(angle), 0];
// Local transverse direction across the 44 mm broad face.
function _mate_n(angle) = [ sin(angle), -cos(angle), 0];

module _line3(p1, p2, d=0.8, c="Red") {
    color(c) pocket_cylinder_between(p1, p2, d, 0);
}

module _cross_marker(p, size=5, d=0.8, c="Red") {
    _line3([p[0]-size,p[1],p[2]], [p[0]+size,p[1],p[2]], d, c);
    _line3([p[0],p[1]-size,p[2]], [p[0],p[1]+size,p[2]], d, c);
}

// Angled member. A long rectangle is created around its centreline and then
// clipped to Y<=0. The clipping plane is the actual joint face.
module _angled_member(angle=45, length=180, width=44, thickness=27, shift=[0,0,0]) {
    d = _mate_d(angle);
    n = _mate_n(angle);
    overrun = 100;

    far_c  = _pt_mul(d, length);
    near_c = _pt_mul(d, -overrun);

    p0 = [far_c[0] - n[0]*width/2, far_c[1] - n[1]*width/2];
    p1 = [far_c[0] + n[0]*width/2, far_c[1] + n[1]*width/2];
    p2 = [near_c[0]+ n[0]*width/2, near_c[1]+ n[1]*width/2];
    p3 = [near_c[0]- n[0]*width/2, near_c[1]- n[1]*width/2];

    translate(shift)
        intersection() {
            linear_extrude(height=thickness)
                polygon([p0,p1,p2,p3]);
            // Tiny tolerance keeps the visual joint clean without overlap.
            translate([-500,-500,-0.01]) cube([1000,500,thickness+0.02]);
        }
}

module _receiver(length=240, width=44, thickness=27, shift=[0,0,0]) {
    translate([-length/2 + shift[0], 0 + shift[1], shift[2]])
        cube([length,width,thickness]);
}

// Pocket positions are referenced from the ACTUAL JOINT FACE (Y=0), not
// from the centreline of the angled timber.  This is the important construction
// rule for the mitred tests: start at the centre of the sloping/cut end, step
// back into the mating timber, draw a line PARALLEL to that joint face, and put
// the two Kreg R3 guide centres next to each other on that line.
//
// In this test geometry the joint face is Y=0, so:
//   joint centre       = [0, 0]
//   jig reference line = Y = -pocket_test_entry_back
//   guide centres      = X = +/- kreg_r3_hole_spacing/2
// This deliberately does NOT use the angled-member centreline for hole spacing.
function _entry_point(angle, side, shift=[0,0,0]) =
    [side * kreg_r3_hole_spacing/2 + shift[0],
     -pocket_test_entry_back + shift[1],
     pocket_test_timber_thickness + 0.20 + shift[2]];

// Pocket screw direction: from the pocket towards/through the joint face and
// into the receiving timber.  In plan this is perpendicular to the joint face.
function _target_from_entry(entry, receiver_shift=[0,0,0]) =
    let(
        run = 70,
        drop = run * tan(pocket_test_drill_angle)
    )
    [entry[0],
     entry[1] + run,
     entry[2] - drop];

module _guides(angle, mate_shift=[0,0,0]) {
    z = pocket_test_timber_thickness + 0.7 + mate_shift[2];

    // Primary reference: centre of the actual mitred joint face.
    _cross_marker([mate_shift[0],mate_shift[1],z], 6, 0.85, "Crimson");

    // Short normal from the joint centre back into the mating timber.
    _line3([mate_shift[0], mate_shift[1], z],
           [mate_shift[0], mate_shift[1]-pocket_test_entry_back, z],
           0.75, "Crimson");

    // Jig line: PARALLEL to the joint face, not through the middle of the timber.
    // This is the line on which the two R3 drill guides sit next to each other.
    jig_y = mate_shift[1] - pocket_test_entry_back;
    _line3([mate_shift[0]-28, jig_y, z],
           [mate_shift[0]+28, jig_y, z],
           0.75, "DodgerBlue");

    // Exact R3 guide centres: 22.225 mm centre-to-centre, symmetric around
    // the normal through the red joint-centre cross.
    for (side=[-1,1]) {
        e = _entry_point(angle, side, mate_shift);
        _cross_marker([e[0],e[1],z], 2.6, 0.65, "DodgerBlue");
    }
}

module pocket_joint_test(joint_angle=90, exploded=false, show_guides=true) {
    timber_w = pocket_test_timber_width;
    timber_t = pocket_test_timber_thickness;

    d = _mate_d(joint_angle);

    // In exploded mode every feature belonging to the mating member receives
    // exactly the same shift: timber, subtractive pockets, screws and guides.
    mate_shift = exploded ? _pt_mul(d, 38) : [0,0,0];
    receiver_shift = exploded ? [0,28,0] : [0,0,0];

    // Receiving and mating timber are deliberately different browns.
    color("BurlyWood") _receiver(240,timber_w,timber_t,receiver_shift);

    color("Peru")
        difference() {
            _angled_member(joint_angle,185,timber_w,timber_t,mate_shift);

            for (side=[-1,1]) {
                entry = _entry_point(joint_angle, side, mate_shift);
                target = _target_from_entry(entry, receiver_shift);

                pocket_hole_bore(entry,target,
                                 pocket_d=9.5,
                                 pilot_d=4.2,
                                 pocket_length=29,
                                 pilot_length=90);
            }
        }

    // 32 mm screws. The head is seated near the bottom of the large pocket;
    // the complete screw then runs exactly pocket_screw_length along the bore axis.
    for (side=[-1,1]) {
        entry = _entry_point(joint_angle, side, mate_shift);
        target = _target_from_entry(entry, receiver_shift);
        u = _ph_unit(_ph_vsub(target,entry));

        screw_head_depth = 20;
        screw_start = [entry[0]+u[0]*screw_head_depth,
                       entry[1]+u[1]*screw_head_depth,
                       entry[2]+u[2]*screw_head_depth];
        screw_end   = [screw_start[0]+u[0]*pocket_screw_length,
                       screw_start[1]+u[1]*pocket_screw_length,
                       screw_start[2]+u[2]*pocket_screw_length];

        color(screw_color)
            screw_between(screw_start,screw_end,
                          screw_diameter,screw_head_diameter,screw_head_height);
    }

    if (show_guides)
        _guides(joint_angle,mate_shift);
}

module pocket_test(exploded=false) {
    pocket_joint_test(90,exploded,true);
}
