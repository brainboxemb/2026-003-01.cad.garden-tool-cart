// Pocket-hole geometry helpers.
//
// A pocket hole is represented as a REAL angled bore. The large stepped
// drill section enters through the broad face of the first timber member;
// a smaller pilot bore continues along the same axis towards the joint.

// Unit vector from p1 to p2.
function _ph_vsub(a, b) = [a[0]-b[0], a[1]-b[1], a[2]-b[2]];
function _ph_vlen(v) = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
function _ph_unit(v) = let(l = _ph_vlen(v)) [v[0]/l, v[1]/l, v[2]/l];

// Cylinder whose axis runs from p1 to p2.
module pocket_cylinder_between(p1, p2, d, extra = 0) {
    v = _ph_vsub(p2, p1);
    l = _ph_vlen(v);
    u = _ph_unit(v);
    p = [p1[0] - u[0]*extra/2,
         p1[1] - u[1]*extra/2,
         p1[2] - u[2]*extra/2];

    translate(p)
        rotate(a = acos(u[2]), v = [-u[1], u[0], 0])
            cylinder(h = l + extra, d = d, $fn = 48);
}

// Subtractive pocket-hole bore.
// entry: point on the broad face of the first member.
// direction_target: point defining the drilling direction.
// pocket_length: length of the larger counterbore from the entry point.
// pilot_length: total pilot-bore length from the entry point.
module pocket_hole_bore(entry,
                        direction_target,
                        pocket_d = 9.5,
                        pilot_d = 4.2,
                        pocket_length = 34,
                        pilot_length = 90) {
    u = _ph_unit(_ph_vsub(direction_target, entry));
    pocket_end = [entry[0] + u[0]*pocket_length,
                  entry[1] + u[1]*pocket_length,
                  entry[2] + u[2]*pocket_length];
    pilot_end = [entry[0] + u[0]*pilot_length,
                 entry[1] + u[1]*pilot_length,
                 entry[2] + u[2]*pilot_length];

    // The larger bore creates the characteristic elongated opening because
    // it intersects the broad timber face at a shallow angle.
    pocket_cylinder_between(entry, pocket_end, pocket_d, 1.0);
    pocket_cylinder_between(entry, pilot_end, pilot_d, 1.0);
}
