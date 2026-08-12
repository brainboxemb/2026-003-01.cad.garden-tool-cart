# Garden tool cart - OpenSCAD concept


## v53 tube-clip geometry

The PETG broom-handle clip root has been rebuilt as one closed 2D profile before extrusion. This removes the gaps and rough boolean transitions between the C-clip, reinforcement triangles and base plate. The 23.5 mm broom-handle dimensions and mounting-hole positions remain unchanged.

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

## v35 – simple 33 × 69 beam holder

Added a deliberately simpler mounting concept for a single 33 × 69 mm timber beam positioned between two consecutive horizontal U-profiles.

The concept uses only two printed parts:

- **Lower rail insert** – 28 × 24.8 × 26 mm. The U-profile was measured at **25.0 mm inside width**; the insert uses **0.2 mm total print clearance**, giving a 24.8 mm fit. It is fixed to the underside of the timber with two countersunk screws.
- **Upper rail saddle** – a larger U-shaped printed part that fits **outside the complete upper steel U-profile**, not inside its groove. Its 9 mm thick bottom fills the difference between the 69 mm timber height and the 78 mm clear rail spacing. Two outer mounting lips are screwed to the top of the timber after the beam is positioned.

New Customizer views:

- `simple_beam_holder` – complete concept with two short rail sections
- `simple_holder_lower` – lower printed insert only
- `simple_holder_upper` – upper printed saddle only

The holder is also shown in `all` on the complete cart. Most fit dimensions are parameterised in `config.scad` so printer clearance, lip size and screw-hole dimensions can be tuned after the first prototype.

The CAD sources are intended to live in a `cad/` subdirectory of the repository. This documentation can therefore remain `README.md` inside that directory, separate from the repository-level `README.md`.


## v36 – saddle fillets and lower screw-hole fix

- Added a small fillet at the inside transition of the upper printed saddle.
- Added a larger radius to the exposed outside corners of the upper saddle.
- Corrected the lower insert so both countersunk screw holes run through the complete part, including in the standalone `simple_holder_lower` view.
- No holder dimensions or cart placement were otherwise changed.


## v37 – corrected saddle lip fillets and M4 wood-screw clearance

- Kept the small inside fillet in the upper U-shaped saddle.
- Moved the larger radius to the actual transition between each vertical U leg and its outside mounting lip.
- Removed the incorrect large rounding underneath the U leg.
- Changed the printed-part through-hole diameter from 4.5 mm to 4.25 mm for a 4 mm countersunk wood screw.
- Countersunk head diameter remains 9 mm.
- Lower insert holes remain fully through-going.


## v39 – thicker upper saddle

- Increased the upper saddle U-wall thickness from 3 mm to 5 mm.
- Increased the mounting-lip thickness from 4 mm to 5 mm so the lips match the U walls.
- Fillet geometry, screw-hole dimensions, timber dimensions and cart placement are unchanged.


## PETG tube clip on simple beam

The front end of the 33 x 69 mm simple beam now carries a separate snap-fit holder for a nominal 18 mm round handle. The printed base is 30 mm wide and uses two countersunk clearance holes for 4 mm wood screws (4.25 mm through bore). The flexible clip itself is 20 mm wide, has an 18.5 mm nominal inner diameter and a 14.5 mm top opening. In v45 the PETG clip wall is reduced to 2.5 mm, the mounting foot is lengthened to 58 mm, and the screw centres are moved to 40 mm spacing so both countersunk heads remain accessible. The root reinforcement and snap-in guide lips are also blended continuously into the C-profile. These dimensions are parameters in `config.scad` so the PETG snap force can be tuned after a test print. Use the `tube_clip` view to inspect or export the loose printed part.


## v40 – tube clip refinement

- Rotated the snap opening so the 18 mm handle is inserted from above.
- Added reinforcement wedges where the C-shaped clip joins the mounting base.
- Added outward-flared lead-in tips so pushing the handle downward naturally opens the PETG arms.
- Kept the 30 mm base, 20 mm clip width, 18.5 mm nominal inner diameter, 14.5 mm retention opening and two countersunk 4.25 mm screw bores.


### v44 tube-clip refinement

- Kept the snap-in lead-in lips from v41.
- Reduced the two root gussets at the C-to-base transition.
- Gussets now reinforce only the outside of the clip and have a shorter footprint.
- The Ø18.5 mm inner bore is re-cut after the gussets are added, so no reinforcement can protrude into the tube opening.


## v44 tube clip refinement

- Tapered snap opening replaces the separate guide lips.
- The opening now forms integral outward lead-in faces for the 18 mm handle.
- Lower reinforcement gussets overlap both the clip wall and base plate and are reduced in size.


### v45 tube-clip root reinforcement

- Rebuilt both C-to-base reinforcement wedges as solid hulls instead of explicit polyhedra.
- The lower reinforcement pads overlap the base plate, so there is no open gap beneath a gusset.
- The upper reinforcement pads overlap only the outer wall of the C-profile and stay outside the working bore.
- This also removes the asymmetric/open-face artefact visible on one side in v44.
- The tapered top opening and all fit dimensions remain unchanged from v44.


### v46 tube-clip closed root transition

- Kept the v45 root gusset shape and tapered snap opening.
- Changed the boolean construction order: the circular tube bore is cut in the C-ring first, then the two root gussets are added.
- The bore is no longer re-cut through the gussets afterwards. This closes the triangular gap between the reinforcement and the mounting base while keeping the gussets outside the working Ø18.5 mm tube opening.
- Screw-hole and snap-fit dimensions are unchanged.


## v47 changes

- Printed mounting width on the 33 mm timber standardized to **28 mm** (lower insert, upper saddle, and tube-clip base).
- Tube-clip root gussets rebuilt with a broad, fully supported foot to remove the remaining triangular gap.


## v48 changes

- Lower U-profile inside width changed from the theoretical profile dimension to the measured **25.0 mm**.
- Added **0.2 mm total print clearance** for the lower insert.
- Lower insert fit dimension is therefore **24.8 mm**.

## v49 changes

- Reduced the vertical arms of `simple_holder_upper` along the steel U-profile to 10 mm.
- The 9 mm spacer bottom between the 33 x 69 mm timber and upper rail is unchanged.
- Rail clearance, 5 mm wall thickness, mounting lips, fillets and screw geometry are unchanged.
- Added `simple_holder_saddle_wrap_height = 10` to `config.scad` so this height is explicit and easy to tune.



## v51

- Lengthened the tube-clip mounting base from 58 mm to 66 mm.
- Moved the two countersunk screw centres farther outward, from 40 mm to 48 mm centre-to-centre, so the screw heads stay clear of the clip reinforcement.
- Reduced the root-gusset size from 2.5 mm to 2.0 mm and shortened its footprint slightly.
- Kept the 18 mm mounting width, 23.5 mm broom-handle diameter and 2.5 mm PETG clip wall unchanged.


## v53 change

The tube clip now has a solid central web beneath the lower arc. This closes the remaining pockets between the C-clip, side reinforcements and mounting base while keeping the circular broom-handle bore clear.

### v55 tube-clip mounting geometry

The broom-handle clip mounting plate is now dimensioned from the actual clip and screw geometry rather than by visual trial-and-error. With a 24.0 mm inner diameter and 2.5 mm wall, the clip outer radius is 14.5 mm. The root reinforcement extends only 0.8 mm beyond that radius, the two Ø9 mm countersunk screw heads are placed at ±20 mm, and the base length is reduced to 56 mm. This keeps the diagonal reinforcement close to the clip while leaving the screw heads accessible.

### v56 – standalone component files

The files in `components/` are now deliberately usable on their own in OpenSCAD.
Each component file exposes practical standalone parameters at the top for the
Customizer and contains a top-level preview/render call at the bottom.

For example, opening `components/tube_clip.scad` directly now immediately shows
the tube clip and exposes its broom-handle, clip, base and screw dimensions in
the Customizer. The same principle is applied throughout `components/`,
including the U-profile, timber, base plate, upright and mounting parts.

Assemblies continue to load components with `use <...>`. OpenSCAD therefore
imports the component modules without executing their standalone top-level
preview geometry, so these preview calls do not create duplicate parts in the
complete model.

## v57 – PETG tube clip tuning

- Measured broom-handle diameter changed to **22.5 mm**.
- The PETG clip now uses **0.3 mm interference**, giving a nominal **22.2 mm bore**.
- Clip wall thickness increased to **4 mm**.
- Base thickness changed to **4 mm** and base length to **50 mm**.
- Screw centres moved 2 mm per side towards the clip: **36 mm centre-to-centre**.
- Added a small configurable underside print relief around both screw holes.
- Added explicit Customizer controls for the diagonal transition: `gusset_base_from_center` and `gusset_height`.
- Standalone `tube_clip.scad` uses `$fn = 96` for a smoother preview/render.


### Tube clip coordinate reference

The tube clip is symmetric. The centre of the clip and the centre of its base plate share the same zero reference. `gusset_base_from_center` is measured from that centre line to the outer foot of each gusset. `clip_leadin_height` is measured vertically from the narrowest point of the opening to the top of the flared entry; `clip_leadin_angle` is measured outward from vertical.


### v61
- Fixed the tube-clip lead-in so the subtractive opening always reaches beyond the physical top of the clip. This removes the detached cap/"roof" visible in v59.

### Tube clip standalone view

Open `components/tube_clip.scad` directly in OpenSCAD. The Customizer now has a `view` selector:

- `clip` — shows only the printable clip.
- `clip_with_tube` — additionally shows a preview cylinder using `tube_diameter`, centred in the clip bore.

`clip_width` is the extrusion width of the C-shaped clip (the X direction through the 18 mm multiplex thickness). It is not the snap opening; `clip_opening` is the gap between the two clip arms in the front view.


### v62 – fixed tube-clip baseline and two-holder cart view

The tested PETG tube-clip settings are now the project defaults: 22.5 mm measured broom-handle diameter, 0.5 mm interference, 4 mm clip wall and base thickness, 18.5 mm opening, 25° lead-in, 10 mm gusset base reference, 8 mm gusset height, 50 mm base length, 38 mm screw spacing and a 6 × 0.2 mm underside print relief.

The full `all` view now places two simple 74 × 18 mm multiplex-strip holders mirrored around the cart centre. `show_broom_handle` is a Customizer checkbox (off by default) that adds a Ø22.5 mm broom handle through both clips. Because the visual handle uses the measured diameter while the clip bore is 0.5 mm smaller, the handle intentionally intersects the clip slightly in the model to represent the PETG interference fit.


## v63

- Changed the simple-holder multiplex strip from **75 × 18 mm** to **74 × 18 mm**.
- With the regular **78 mm** free rail spacing, the upper printed spacer is now automatically **4 mm** thick.
- Updated the standalone upper-saddle preview to use the same 4 mm spacer thickness.


### v64 – Upper saddle print relief

The `simple_holder_upper` screw holes now have a shallow cylindrical print relief on the face opposite the countersinks. The default relief is Ø6.0 mm × 0.2 mm and is configurable independently from the countersink dimensions.

## v65

- `simple_holder_upper`: the complete horizontal base is now 4 mm thick.
- The 4 mm base is also the spacer between the 74 mm multiplex strip and the upper U-profile; no extra lip thickness is added.



## Upper saddle variants

The upper rail saddle now has two fit variants for variation between cart arms:

- `upper_4mm`: standard 4 mm thickness between the multiplex strip and steel U-rail.
- `upper_3mm`: the mounting base/lips remain 4 mm, but the local seat directly under the steel U-rail is 3 mm.

Open `components/rail_beam_mount.scad` directly and choose the required variant in the Customizer. The main model also provides `simple_holder_upper` and `simple_holder_upper_3mm` views.
