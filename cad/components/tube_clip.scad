// Snap-fit broom-handle holder for the end of the 74 x 18 mm multiplex strip.
// Intended for PETG. The handle is pushed in from +Z.
// Open this file directly in OpenSCAD to tune it in the Customizer and render it.

$fn = 96;

/* [View] */
view = "clip"; // [clip:Clip only, clip_with_tube:Clip with broom handle]

/* [Broom handle] */
tube_diameter = 22.5;
tube_interference = 0.5; // clip bore is this much smaller than the measured handle

/* [Clip] */
clip_width = 18;
clip_wall = 4;
clip_opening = 18.5;
clip_leadin_height = 10.0; // vertical height from the narrowest opening upward to the top of the flared entry
clip_leadin_angle = 25;      // flare angle outward from vertical; larger = wider opening at the top

/* [Clip-to-base transition] */
gusset_base_from_center = 10.0; // distance from Y=0 (clip/base centre) to outer foot of each gusset
gusset_height = 8.0;          // height above the top of the base where the slope meets the clip

/* [Base] */
base_width = 18;
base_length = 50;
base_thickness = 4;

/* [Screws] */
screw_diameter = 4.25;
screw_head_diameter = 9;
screw_head_height = 3.2;
screw_spacing = 38;
screw_bottom_relief_diameter = 6.0;
screw_bottom_relief_depth = 0.2;

module tube_clip_countersunk_hole(
    h,
    shaft_d=4.25,
    head_d=9,
    head_h=3.2,
    bottom_relief_d=6.0,
    bottom_relief_h=0.4
) {
    // Through clearance hole.
    translate([0,0,-0.1])
        cylinder(h=h+0.2, d=shaft_d);

    // Countersink from the top surface.
    translate([0,0,h-head_h])
        cylinder(h=head_h+0.2, d1=shaft_d, d2=head_d);

    // Small underside print relief. This removes first-layer squish from the
    // functional Ø4.25 mm opening without making a second countersink.
    if (bottom_relief_h > 0 && bottom_relief_d > shaft_d)
        translate([0,0,-0.1])
            cylinder(
                h=bottom_relief_h+0.1,
                d=bottom_relief_d
            );
}

// 2D side profile. Coordinates are [u,v] = [-Z,Y]. After extrusion and a
// 90 degree rotation around Y this becomes the normal global [X,Y,Z] part.
module tube_clip_profile_2d(
    ri,
    ro,
    zc,
    base_length,
    base_thickness,
    opening_bottom,
    leadin_height,
    leadin_angle,
    gusset_base_from_center,
    gusset_height
) {
    // Build the lead-in as one continuous cut that always reaches beyond
    // the top of the outer clip circle. This prevents a detached "roof".
    clip_top_z = zc + ro;

    // `leadin_height` is measured downward from the physical top of the clip.
    // The start is also clamped to the point where the requested narrow
    // opening intersects the inner bore, so the slot stays connected.
    bore_join_z = zc + sqrt(max(0, ri*ri - (opening_bottom/2)*(opening_bottom/2)));
    cut_z0 = max(clip_top_z - leadin_height, bore_join_z - 0.2);

    // Extend the cut beyond the physical top of the clip.
    cut_z1 = clip_top_z + 2;
    flare_height = cut_z1 - cut_z0;
    opening_top = opening_bottom + 2 * tan(leadin_angle) * flare_height;

    // Coordinate reference for this symmetric part:
    // Y = 0 is the centre of both the base plate and the clip.
    // `gusset_base_from_center` is therefore the absolute distance from that
    // centre line to the outer foot of each diagonal gusset.
    // `gusset_height` controls where the diagonal meets the clip wall.
    attach_z = min(base_thickness + gusset_height, zc + ro - 0.5);
    dz = attach_z - zc;
    attach_y = sqrt(max(0.01, ro*ro - dz*dz));
    base_half_y = gusset_base_from_center;

    difference() {
        union() {
            // Base plate cross-section.
            polygon([
                [0,               -base_length/2],
                [-base_thickness, -base_length/2],
                [-base_thickness,  base_length/2],
                [0,                base_length/2]
            ]);

            // Outer clip body.
            translate([-zc,0]) circle(r=ro);

            // One completely solid transition web. Its outer sides form the
            // two visible slopes, but the centre remains filled so there are
            // no pockets between clip and base.
            polygon([
                [-base_thickness, -base_half_y],
                [-base_thickness,  base_half_y],
                [-attach_z,         attach_y],
                [-attach_z,        -attach_y]
            ]);
        }

        // Slight interference fit for the PETG clip.
        translate([-zc,0]) circle(r=ri);

        // Tapered snap-in opening. The cut continues beyond the outer
        // circle, so no detached cap can remain above the two clip arms.
        polygon([
            [-cut_z0,      -opening_bottom/2],
            [-cut_z1,      -opening_top/2],
            [-(cut_z1+2),  -opening_top/2],
            [-(cut_z1+2),   opening_top/2],
            [-cut_z1,       opening_top/2],
            [-cut_z0,       opening_bottom/2]
        ]);
    }
}

module tube_clip(
    tube_d=22.5,
    interference=0.5,
    clip_width=18,
    wall=4,
    opening=18.5,
    base_width=18,
    base_length=50,
    base_thickness=4,
    screw_d=4.25,
    screw_head_d=9,
    screw_head_h=3.2,
    screw_spacing=38,
    leadin_height=10,
    leadin_angle=25,
    gusset_base_from_center=10.0,
    gusset_height=8.0,
    screw_bottom_relief_d=6.0,
    screw_bottom_relief_h=0.2
) {
    inner_d = tube_d - interference;
    ri = inner_d/2;
    ro = ri + wall;

    // Deliberate overlap with the base so clip, web and base are one body.
    overlap = 1.0;
    zc = base_thickness + ro - overlap;

    opening_bottom = opening;

    difference() {
        translate([-max(base_width,clip_width)/2,0,0])
            rotate([0,90,0])
                linear_extrude(height=max(base_width,clip_width), convexity=10)
                    tube_clip_profile_2d(
                        ri=ri,
                        ro=ro,
                        zc=zc,
                        base_length=base_length,
                        base_thickness=base_thickness,
                        opening_bottom=opening_bottom,
                        leadin_height=leadin_height,
                        leadin_angle=leadin_angle,
                        gusset_base_from_center=gusset_base_from_center,
                        gusset_height=gusset_height
                    );

        for (y=[-screw_spacing/2, screw_spacing/2])
            translate([0,y,0])
                tube_clip_countersunk_hole(
                    h=base_thickness,
                    shaft_d=screw_d,
                    head_d=screw_head_d,
                    head_h=screw_head_h,
                    bottom_relief_d=screw_bottom_relief_d,
                    bottom_relief_h=screw_bottom_relief_h
                );
    }
}

// Preview helper: shows the real measured broom handle through the clip.
// The cylinder axis is along X, i.e. through the 18 mm clip width.
module tube_preview(
    tube_d=22.5,
    interference=0.5,
    wall=4,
    base_thickness=4,
    preview_length=40
) {
    inner_d = tube_d - interference;
    ro = inner_d/2 + wall;
    overlap = 1.0;
    zc = base_thickness + ro - overlap;

    color([0.72,0.58,0.36])
        translate([0,0,zc])
            rotate([0,90,0])
                cylinder(h=preview_length, d=tube_d, center=true);
}

// Standalone component preview/render. Top-level geometry is ignored when this
// file is imported with `use <...>` from an assembly.
tube_clip(
    tube_d=tube_diameter,
    interference=tube_interference,
    clip_width=clip_width,
    wall=clip_wall,
    opening=clip_opening,
    base_width=base_width,
    base_length=base_length,
    base_thickness=base_thickness,
    screw_d=screw_diameter,
    screw_head_d=screw_head_diameter,
    screw_head_h=screw_head_height,
    screw_spacing=screw_spacing,
    leadin_height=clip_leadin_height,
    leadin_angle=clip_leadin_angle,
    gusset_base_from_center=gusset_base_from_center,
    gusset_height=gusset_height,
    screw_bottom_relief_d=screw_bottom_relief_diameter,
    screw_bottom_relief_h=screw_bottom_relief_depth
);

if (view == "clip_with_tube")
    tube_preview(
        tube_d=tube_diameter,
        interference=tube_interference,
        wall=clip_wall,
        base_thickness=base_thickness,
        preview_length=max(40, clip_width + 20)
    );
