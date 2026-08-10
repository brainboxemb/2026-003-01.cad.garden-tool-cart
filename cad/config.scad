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
$fn = 48;

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
