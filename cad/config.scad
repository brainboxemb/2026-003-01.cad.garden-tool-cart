// Garden Tool Cart - configuration
// Units: mm

// Base plate
base_width     = 880;
base_depth     = 620;
base_thickness = 18;

// Uprights
upright_width  = 20;   // X dimension
upright_depth  = 40;   // Y dimension
upright_height = 1400;

// Horizontal U profiles
u_width   = 30;        // Y dimension / profile depth
u_height  = 30;        // Z dimension
u_wall    = 2;
u_length  = 840;       // X direction, exactly between uprights

// Rack layout
u_count      = 12;
u_gap        = 78;     // free space between regular profiles
u_pitch      = u_height + u_gap;  // 108 mm
u_top_offset = 0;      // top of upper U-profile flush with top of uprights

// Shovel holder - wooden prototype
holder_stock_width  = 27;   // width of each side frame in X
holder_stock_depth  = 44;   // timber thickness in the side view
holder_arm_length   = 320;  // measured along the arm
// The two design angles can be overridden from main.scad via OpenSCAD's
// dynamically-scoped special variables. Defaults keep the files usable on
// their own as well.
holder_arm_angle    = is_undef($holder_arm_angle_ui) ? 5 : $holder_arm_angle_ui;
holder_side_gap     = 45;   // clear gap between both arms
holder_back_height  = 235;  // lower vertical member stops at underside of upper arm

// Rear mounting geometry.
// The LOWER connection remains a full-width 50 mm rear bar.
// The UPPER connection is now an open H-shaped frame so the centre between
// the shovel arms stays free and no 40-44 mm of useful depth is lost.
holder_mount_depth  = 27;   // lower rear bar depth behind the side frames
holder_mount_height = 50;   // lower rear bar height
holder_slot_width   = 2.3;  // clearance for 2 mm steel wall
holder_slot_depth   = 18;   // vertical depth of saw cut

// Upper mounting frame: two vertical members, same 27 x 44 orientation as
// the side frames/arms, with two small bridge blocks between them above the
// working height of the shovel.  Each vertical member catches the upper rail.
holder_upper_mount_z       = 205;  // bottom of slot in the new upper cross mounting bar
holder_upper_clearance       = 100;  // arm starts 100 mm above the top of the upper U-profile
holder_upper_upright_z       = holder_upper_mount_z + holder_mount_height;
holder_upper_upright_height  = 180;
holder_upper_upright_depth  = holder_stock_depth; // 44 mm, same orientation
// The two cross pieces are cut from the same 27 x 44 stock, but rotated:
// 27 mm in Y (depth) and 44 mm in Z (height). This leaves the front part
// of the 44 mm deep uprights clear and makes the two bridges read as
// separate wooden members.
holder_upper_bridge_depth   = holder_stock_width; // 27 mm
holder_upper_bridge_height  = holder_stock_depth; // 44 mm

// Position of upper arm. The arm now continues rearward to Y=0,
// over the top of the shortened lower vertical member.
holder_arm_z = holder_upper_mount_z + holder_slot_depth + holder_upper_clearance;
holder_arm_rear_y = 0;

// Spread the bridges over the upper frame instead of bunching them at the top.
holder_upper_bridge_z1      = holder_arm_z + 20;
holder_upper_bridge_z2      = holder_upper_upright_z + holder_upper_upright_height - holder_upper_bridge_height - 12;

// Lower connection is moved one additional U-profile lower.
// This means the holder is supported on the top rail and the rail two pitches below it.
holder_lower_mount_z = holder_upper_mount_z - 2 * u_pitch; // -11 mm

// Let the two lower vertical side members continue below the lower rear bar.
// This makes the lower bar sit fully between/behind the uprights instead of
// visibly hanging underneath them.
holder_lower_upright_extra = 20;

// One lower rear-bar screw per side, deliberately above the 18 mm saw-cut
// that receives the U-profile wall.
holder_lower_screw_above_slot = 12;
holder_lower_screw_embed = 14;
holder_upper_screw_above_slot = 12;
holder_upper_screw_embed = 14;

// Small wooden retaining block at the front of each arm.
holder_stop_depth  = 22;    // length along Y
holder_stop_height = 24;    // vertical height above the arm
holder_stop_back   = 8;     // distance from front end of arm
holder_stop_screw_length = 32;

// Diagonal brace. Its lower edge starts at the rear face under 45 degrees.
holder_brace_vertical_drop = 200;
// Keep the brace geometry tied to the raised arm. In v31 the arm moved up
// but the brace start was still left at the old absolute Z position.
holder_brace_start_z = holder_arm_z - holder_brace_vertical_drop;
holder_brace_angle   = is_undef($holder_brace_angle_ui) ? 45 : $holder_brace_angle_ui;

// Holder placement on the full cart
holder_cart_profile_index = 0;     // mount on the highest U-profile     // counted from top: 0,1,2,...
holder_cart_x = 385;               // X position on the selected U-profile

// Exploded view spacing
exploded_side_x   = 55;
exploded_arm_y    = 45;
exploded_brace_y  = 85;
exploded_mount_y  = 70;
exploded_lower_mount_y = 95;
exploded_stop_z = 35;
exploded_screw_x  = 28;

// Screw representation
screw_diameter      = 4;
screw_head_diameter = 8;
screw_head_height   = 3;

// Small visual edge rounding for wooden parts.
wood_edge_radius = 0.9;

// Tiny assembly overlap used only to prevent rounded wooden parts from
// showing artificial preview gaps where they are meant to touch.
holder_joint_overlap = 0.8;

// Display colours
frame_color  = "LightGray";
base_color   = "BurlyWood";
holder_color = "Peru";
screw_color  = "DimGray";

// Display
$fn = 96;

// Pocket-hole test / Kreg R3 reference geometry
// Kreg R3 guide centres: 7/8 inch = 22.225 mm.
pocket_test_timber_width     = 44;
pocket_test_timber_thickness = 27;
kreg_r3_hole_spacing         = 22.225;
pocket_test_entry_back       = 22;    // red cross / centre of 2-hole pattern, measured back from joint
pocket_test_drill_angle      = 15;    // approximate pocket-hole drilling angle
pocket_test_show_guides      = true;

// Pocket screw length chosen for this prototype
pocket_screw_length          = 32;

// Arm-to-vertical pocket pair.  Measured from the rear end of the arm into
// the overlap above the lower vertical member.  The screw axis points down
// through the arm into that member rather than backwards out of the joint.
holder_arm_joint_pocket_back = 18;

// Simple 74 x 18 multiplex-strip holder between two consecutive U-profiles
// The 74 mm strip height plus the 4 mm printed top spacer equals the
// regular 78 mm free gap between profiles.
simple_holder_beam_width   = 18;   // X, multiplex thickness / across the rack
simple_holder_beam_height  = 74;   // Z, multiplex strip height between rails
simple_holder_beam_length  = 300;  // Y, projection from rack; easy to tune
simple_holder_rear_overlap = 20;   // timber continues a little behind rail centreline
simple_holder_top_gap      = u_gap - simple_holder_beam_height; // 4 mm with current rack

// Lower printed insert. The actual measured inside width of the steel U-profile
// is 25.0 mm. Keep 0.2 mm total print clearance, so the insert is 24.8 mm.
simple_holder_mount_width = 18;   // printed parts match the 18 mm multiplex thickness
simple_holder_u_inner_width = 25;
simple_holder_insert_clearance = 0.2; // total clearance, not per side
simple_holder_lower_insert_x = simple_holder_mount_width;
simple_holder_lower_insert_y = simple_holder_u_inner_width - simple_holder_insert_clearance; // 24.8
simple_holder_lower_insert_z = 10;
simple_holder_lower_screw_spacing = 12; // along Y; suits the narrow 18 mm part

// Upper printed saddle: U-shaped part OUTSIDE the full upper rail.
simple_holder_saddle_clearance = 0.1; // 0.1 mm per side; 1.0 mm less total play than the previous 0.6 mm/side
simple_holder_saddle_wall      = 5;
simple_holder_saddle_wrap_height = 20; // printed side arms extend 20 mm up along the steel U-rail
simple_holder_lip_depth        = 16;
simple_holder_lip_thickness    = 4; // mounting base/lips remain 4 mm thick
simple_holder_saddle_bottom_alt  = 3; // alternative rail seat: 3 mm only directly under the steel U-profile
// Saddle fillets: subtle inside the U; larger at the U-leg -> side-lip transition.
simple_holder_saddle_inner_fillet = 1.2;
simple_holder_saddle_outer_fillet = 3;
simple_holder_saddle_bottom_relief_diameter = 6.0;
simple_holder_saddle_bottom_relief_depth    = 0.2; // non-countersunk face

// Printed-part screw holes
simple_holder_screw_diameter      = 4.25; // clearance for 4 mm countersunk wood screw
simple_holder_screw_head_diameter = 9;
simple_holder_screw_head_height   = 3.2;

// Full-cart placement. Uses two consecutive profiles.
simple_holder_cart_upper_profile_index = 2;
simple_holder_cart_x = 275; // left holder centre; second holder is mirrored around cart centre

// Standalone preview
simple_holder_profile_preview_length = 180;
simple_holder_print_color = "Orange";

// Snap-fit tube holder on the front end of the 74 x 18 multiplex strip.
// Intended for PETG and a nominal 23.5 mm broom handle pushed in from above.
tube_clip_tube_diameter       = 22.5;
tube_clip_interference        = 0.5;   // clip bore = 22.0 mm for positive PETG grip
tube_clip_width               = simple_holder_mount_width; // 18 mm, same as multiplex thickness
tube_clip_wall                = 4;
tube_clip_opening             = 18.5;
tube_clip_base_width          = simple_holder_mount_width;
tube_clip_base_length         = 50;
tube_clip_base_thickness      = 4;
tube_clip_screw_diameter      = 4.25;  // for 4 mm countersunk wood screws
tube_clip_screw_head_diameter = 9;
tube_clip_screw_head_height   = 3.2;
tube_clip_screw_spacing       = 38;
tube_clip_screw_bottom_relief_diameter = 6.0;
tube_clip_screw_bottom_relief_depth    = 0.2; // shallow first-layer relief on underside
tube_clip_leadin_height       = 10.0;  // vertical height from narrowest opening upward to top of flared entry
tube_clip_leadin_angle        = 25;    // flare angle outward from vertical; larger = wider top opening
// Symmetry reference: centre of clip == centre of base plate == 0.
tube_clip_gusset_base_from_center = 10.0; // distance from centre to outer foot of each gusset
tube_clip_gusset_height       = 8.0;   // height above base top where diagonal meets clip
tube_clip_end_margin          = 5;
broom_handle_color            = "Sienna";

// Tool bin - full-width 18 mm underlayment / multiplex construction.
// The rear edge is derived from the front face of the U-profile rack,
// leaving a configurable clearance so the bin cannot intersect the rail.
tool_bin_width             = base_width; // X, full outside width of cart
tool_bin_rail_clearance    = 10;         // Y clearance in front of first U-profile
tool_bin_cart_front_margin = 25;         // Y margin from front edge of base
tool_bin_u_profile_front_y = (base_depth - upright_depth) / 2
                           + (upright_depth - u_width) / 2;
tool_bin_depth             = tool_bin_u_profile_front_y
                           - tool_bin_cart_front_margin
                           - tool_bin_rail_clearance; // 260 mm with current cart dimensions

// All box panels are now the same 18 mm sheet material.
tool_bin_panel_thickness  = 18;
tool_bin_bottom_thickness = tool_bin_panel_thickness; // compatibility / documentation alias
tool_bin_wall_thickness   = tool_bin_panel_thickness; // compatibility / documentation alias
tool_bin_wall_height      = 220;

// Black conventional countersunk wood screws.
tool_bin_screw_diameter      = 4;
tool_bin_screw_length        = 40;
tool_bin_screw_head_diameter = 8;
tool_bin_screw_head_height   = 3;
tool_bin_corner_screw_height = 110; // one visible screw per outside corner

// Bottom screws are driven upward from the underside.
tool_bin_bottom_screw_edge_offset = 45;
tool_bin_bottom_screw_x_positions = [100, tool_bin_width/2, tool_bin_width - 100];

// Placement on the cart base. The bin spans the full cart width.
tool_bin_cart_x = 0;
tool_bin_cart_y = tool_bin_cart_front_margin;

tool_bin_bottom_color = "BurlyWood";
tool_bin_wall_color   = "Wheat";
tool_bin_screw_color  = "Black";
tool_bin_batten_color = "Peru";

// Tool-bin exploded-view offsets. Panels move away from the assembled box in
// their actual assembly directions; screw heads follow their parent panels.
tool_bin_exploded_end    = 70; // left/right end panels, X direction
tool_bin_exploded_long   = 70; // front/rear long panels, Y direction
tool_bin_exploded_bottom = 55; // bottom panel, downward Z direction
