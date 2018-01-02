include <../configuration.scad>
use <pins2.scad>
use <../gutter.scad>

size = in*1.25;

pin_rad = 4;
pin_len = 13;
preload = .1;
pin_slop = .3;
pin_nub = .5;
thickness = 1.7;

block_slop = 1;

part = 10;

if(part == 0){
    pinpeg(r=pin_rad,l=pin_len,d=2.5-preload,nub=pin_nub,t=thickness,space=pin_slop);
    %translate([0,0,2.5]) rotate([90,0,0]) peg_hole();
}

if(part == 10){
    %translate([0,0,-gutter_wall]) gutter_inside();
    
    translate([0,0,size/2]){
        peg_cube();
        translate([-size,0,0]) peg_sidecube(); 
    }
    
}

module peg_hole(){
    pinhole(r=pin_rad,l=pin_len,d=2.5-preload,nub=pin_nub,t=thickness, space=clearance);
}

module peg_cube(){
    difference(){
        cube([size-block_slop, size-block_slop, size-block_slop], center=true);
        
        for(i=[0,1]) mirror([0,0,i])
            translate([0,0,-size/2]) peg_hole();
        
        for(i=[0,1]) mirror([0,i,0])
            translate([0,-size/2,0]) rotate([-90,0,0]) peg_hole();
        
        for(i=[0,1]) mirror([i,0,0])
            translate([-size/2,0,0]) rotate([0,90,0]) peg_hole();
        
    }
}

module peg_sidecube(){
    difference(){
        intersection(){
            cube([size-block_slop, size-block_slop, size-block_slop], center=true);
            translate([size,0,-gutter_wall-size/2]) gutter_inside();
        }
        
        for(i=[0,1]) mirror([0,0,i])
            translate([0,0,-size/2]) peg_hole();
        
        for(i=[0,1]) mirror([0,i,0])
            translate([0,-size/2,0]) rotate([-90,0,0]) peg_hole();
        
        mirror([i,0,0])
            translate([-size/2,0,0]) rotate([0,90,0]) peg_hole();
        
    }
}