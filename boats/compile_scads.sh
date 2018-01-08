#!/bin/sh

#block boats
openscad -o blockboat_parts/peg_tpu.stl -D part=0 blockboat.scad &
openscad -o blockboat_parts/peg_cube.stl -D part=1 blockboat.scad &
openscad -o blockboat_parts/peg_sidecube.stl -D part=2 blockboat.scad &
openscad -o blockboat_parts/peg_cylinder.stl -D part=3 blockboat.scad &
openscad -o blockboat_parts/peg_rod.stl -D part=4 blockboat.scad &
openscad -o blockboat_parts/peg_sphere.stl -D part=5 blockboat.scad &
openscad -o blockboat_parts/peg_skiff_cube.stl -D part=6 blockboat.scad &
openscad -o blockboat_parts/peg_skiff_sidecube.stl -D part=7 blockboat.scad &
openscad -o blockboat_parts/peg_tetrahedron.stl -D part=8 blockboat.scad &


#hull forms
openscad -o hull_forms_parts/canoe.stl -D part=1 hull_forms.scad &
openscad -o hull_forms_parts/canoe_mold.stl -D part=11 hull_forms.scad &
openscad -o hull_forms_parts/catamaran.stl -D part=2 hull_forms.scad &
openscad -o hull_forms_parts/catamaran_mold.stl -D part=21 hull_forms.scad &
