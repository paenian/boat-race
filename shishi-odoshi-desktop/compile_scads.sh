#!/bin/sh

#shishi-odoshi parts
openscad -o shishiodoshi_parts/shishi.stl -D part=0 shishiodoshi.scad &
openscad -o shishiodoshi_parts/odoshi.stl -D part=1 shishiodoshi.scad &
openscad -o shishiodoshi_parts/spout.stl -D part=2 shishiodoshi.scad &
openscad -o shishiodoshi_parts/axle.stl -D part=3 shishiodoshi.scad &
