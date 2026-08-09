# Garden tool cart - OpenSCAD concept

Abstract model of the existing garden-tool cart and a first wooden shovel-holder concept.

## Current model

- base plate: 880 × 620 × 18 mm
- uprights: 20 × 40 mm, 1400 mm high
- U-profiles: 30 × 30 × 2 mm, 840 mm long, open upward
- regular U-profile pitch: 108 mm, laid out from the top downward
- shovel holder made from two wooden side frames using 27 × 44 mm stock
- slightly rising upper arms
- 45° diagonal braces
- rear mounting cross bar with a saw cut for the 2 mm U-profile wall
- simplified screw positions

The rear mounting bar is directly flush with the rear faces of the wooden vertical members. The slot is directly against that face as well, instead of floating behind the holder.

## Customizer

`view`:

- `all` - complete cart with shovel holder installed
- `cart` - bare cart only
- `u_profile` - one U-profile
- `shovel_holder` - holder only
- `holder_on_profile` - holder on a short U-profile test piece

`subview`:

- `assembled`
- `exploded`

The exploded subview separates the wooden holder parts and screws to make the joints easier to inspect.

This is still a design model. Screw positions are illustrative and are not yet a final pocket-hole drilling plan.

## v6 screw layout
The side-frame screws are represented as pocket-style screws entering from the inner faces of the wooden members. Their axes remain inside the wood and cross the actual butt joints; they no longer bridge the open triangular space.

## Pocket-hole test view

Version 8 adds `view = "pocket_test"`. This deliberately isolates one 27 x 44 mm timber joint. The pocket is a real shallow angled stepped bore subtracted from the first board, and the screw follows the same axis through the joint into the mating board. The shovel-holder pocket geometry has not yet been replaced; this test is intended to validate the joint first.

## v9
Removed obsolete `pocket_mark_x()` references from the shovel-holder assembly. The real pocket-hole geometry remains isolated in the `pocket_test` view until that joint is approved.

## Pocket-hole test views (v10)

The Customizer now has three separate joint tests:

- `pocket_90` — 90 degree joint
- `pocket_45` — 45 degree brace joint
- `pocket_55` — 55 degree brace joint

Each test uses two pocket holes across the 44 mm face, with 18 mm centre spacing,
and shows the screws inside the bores. The pocket entry is 40 mm from the joint.


### Pocket-hole test geometry

The `pocket_90`, `pocket_45` and `pocket_55` views place the joint halfway along the receiving timber. For the angled tests the brace end is mitred against the receiver and both pocket holes rotate with the brace. Their screw axes are normal to the receiving timber in plan view.

## v14 pocket-hole test update

The 45/55 degree test geometry now uses a true local centreline for the angled
27 x 44 mm timber. Two hole centres are placed symmetrically around that line
using the Kreg Jig R3 guide-centre spacing of 22.225 mm (7/8 inch). Construction
guides can be toggled in the Customizer with `show_guides`.


## v15 pocket-test correction

In the pocket-test views the red cross now marks the centre of the two-hole pattern.
The two Kreg R3 hole centres are placed symmetrically at ±11.1125 mm around that cross
(22.225 mm centre-to-centre). A smaller grey cross marks the physical joint centre.


## v16 guide convention

In pocket test views the **red cross marks the geometric centre of the joint**. The blue transverse line marks the Kreg R3 drilling station; its two hole centres use the 22.225 mm guide spacing and are symmetric about the timber centreline.

## v19
The validated pocket-hole construction rule from the 45-degree test is now used in the shovel holder. Pocket pairs use the Kreg R3 22.225 mm guide spacing and 32 mm screws. The upper arm has a pair at the rear joint; the diagonal brace has a pair at the rear joint and a pair at its upper joint. Pocket bores are actual subtractive geometry and move with their timber member in exploded view.

## v20 shovel-holder changes

- rear mounting bar height changed to 50 mm;
- two slotted rear mounting bars, spaced exactly one U-profile pitch (108 mm);
- upper rear bar projects above the vertical side members;
- small screwed-on wooden stop block added at the front of each arm;
- holder-on-profile test view now shows two adjacent U-profiles.

## v23 changes
- Full-cart `all` view mounts the holder on the highest U-profile.
- Lower vertical side members stop at the underside of the slightly rising arm.
- The upper arm continues rearward to the mounting plane (Y=0), recovering the previously lost ~44 mm of useful depth.
- Upper mounting uprights begin at arm height and continue upward.
- Wooden parts have a subtle visual corner radius to make transitions between parts easier to read.


## v23 joint cleanup

The lower vertical side members now have a sloped top matching the underside of the 6-degree arm. A tiny 0.8 mm assembly overlap is used at intended butt joints so the 0.9 mm visual edge rounding does not create false gaps in OpenSCAD preview.


## v24 changes
- Holder body raised relative to the upper U-profile.
- Lower rear support moved one additional U-profile lower (two pitches below the upper support).
- U-profile orientation in the holder test corrected so the channel extends behind the holder instead of through the wooden frame.


## v25
Upper cross pieces are rotated to use 27 mm depth x 44 mm height and are spread over the upper mounting frame.


## v27
- Corrected the pocket-hole connection between each slightly rising upper arm and its lower vertical member.
- The arm is supported on top of that vertical member, so these screws now run downward through the arm into the vertical timber instead of backwards out of the rear of the joint.
- Two pockets remain on the Kreg R3 22.225 mm guide spacing and use the 32 mm screw model.
- Pocket bores and screws stay attached to the arm in exploded view.


## v27
- Arm-to-vertical pocket holes moved to the underside of the slightly rising arms.
- Lower vertical side members now stop flush at the top of the lower U-profile instead of protruding through/below it.


## v28
Arm-to-lower-vertical pocket screws now start in front of the vertical member and travel back/down across the joint into the vertical timber.

## v30
Arm-to-lower-upright pocket holes corrected: pockets are now in the inside face
of the lower vertical member, just below the arm, and point upward through the
actual joint into the arm.


## v30
- Lower vertical side members extend 20 mm below the lower rear mounting bar.
- Lower rear bar uses one conventional screw per side.
- Those screws are positioned above the U-profile saw-cut/steel zone.


## v31 upper mounting change

The upper U-profile is now engaged by a separate full-width slotted cross block, just like the lower mounting point. The wooden holder structure starts above that block and the rear of the upper arm is positioned 100 mm above the top of the upper U-profile. This prevents any vertical timber from passing through the steel U-profile.


## v33 changes

- Raised the diagonal brace together with the raised upper arm. The brace start is now derived from the arm height instead of using the old absolute Z position.
- Added `print_cut_list` to the Customizer. When enabled, OpenSCAD prints the current nominal timber lengths and key holder dimensions to the console.


## v33 – angle parameters and cleaner cut-list output

The two main holder angles are explicit configuration parameters:

```scad
holder_arm_angle   = 6;  // [0:1:15]
holder_brace_angle = 45; // [30:1:60]
```

They are intended to be visible in the OpenSCAD Customizer. The cut-list ECHO output now rounds practical timber lengths to whole millimetres and prints both angles explicitly.


## Customizer geometry controls

`main.scad` exposes the two main holder angles directly in the OpenSCAD Customizer:

- `arm_slope_angle`: default 5°, range 0–15°
- `brace_slope_angle`: default 45°, range 30–60°

The cut-list ECHO also prints an angle overview for all principal wooden members.
