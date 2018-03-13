#!/bin/sh

#track parts
openscad -o track_parts/gutter_mount_double.stl -D part=0 gutter.scad &
openscad -o track_parts/gutter_mount_triple.stl -D part=1 gutter.scad &
openscad -o track_parts/gutter_twist_lock.stl -D part=2 gutter.scad &
openscad -o track_parts/gutter_drip_edge.stl -D part=8 gutter.scad &
openscad -o track_parts/gutter_drip_mesh_insert.stl -D part=9 gutter.scad &
openscad -o ../gutter_inside.stl -D part=3 gutter.scad &
openscad -o ../boat_box.stl -D part=4 gutter.scad 

#bucket parts
openscad -o track_parts/bucket_mount.stl -D part=5 gutter.scad &
openscad -o track_parts/bucket_mount_mirror.stl -D part=6 gutter.scad 

#shishi-odoshi
(cd shishi-odoshi && /bin/sh compile_scads.sh)
