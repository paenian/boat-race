include <../configuration.scad>
use <pins2.scad>
use <../track/gutter.scad>

size = in*1.25;

pin_rad = 4;
pin_len = 13;
preload = .1;
pin_slop = .2;
pin_nub = .75;
thickness = 2.5;

block_slop = 1.5;

part = 10;

if(part == 0){
    peg();
    %translate([0,0,2.5]) rotate([90,0,0]) peg_hole();
}

if(part == 1)
    peg_cube();

if(part == 2)
    mirror([0,0,1]) peg_sidecube();

if(part == 3)
    peg_cylinder();

if(part == 4)
    peg_rod();

if(part == 5)
    peg_sphere();

if(part == 6)
    mirror([0,0,1]) peg_skiff_cube();

if(part == 7)
    mirror([0,0,1]) peg_skiff_sidecube();

if(part == 8){
    //%peg_cube();
    %translate([0,0,-gutter_wall]) rotate([0,0,90]) gutter_inside(notch = true);
    peg_tetrahedron();
}

if(part == 10){
    %translate([0,0,-gutter_wall]) gutter_inside(notch = true);
    
    translate([0,0,size/2]){
        peg_cube();
        for(i=[0,1]) mirror([i,0,0]) translate([-size,0,0])
            mirror([0,0,1]) peg_sidecube();
        
        translate([0,size,0]) {
            peg_cylinder();
            for(i=[0,1]) mirror([i,0,0]) translate([-size,0,0])
                peg_sphere();
        }
        
        translate([0,-size,0]) {
            peg_rod();
            for(i=[0,1]) mirror([i,0,0]) translate([-22/2-size/2+block_slop/2,0,0])
                peg_sphere();
        }
        
        translate([0,size*2,0]) {
            mirror([0,0,1]) peg_skiff_cube();
            for(i=[0,1]) mirror([i,0,0]) translate([-size,0,0])
                mirror([0,0,1]) peg_skiff_sidecube();
        }
    }
    
}

module peg(){
    pinpeg(r=pin_rad,l=pin_len,d=2.5-preload,nub=pin_nub,t=thickness,space=pin_slop);
}

module peg_hole(){
    pinhole(r=pin_rad,l=pin_len,d=2.5-preload,nub=pin_nub,t=thickness, space=pin_slop);
}

module peg_cube(){
    size = size-block_slop;
    difference(){
        cube([size, size, size], center=true);
        
        for(i=[0,1]) mirror([0,0,i])
            translate([0,0,-size/2]) peg_hole();
        
        for(i=[0,1]) mirror([0,i,0])
            translate([0,-size/2,0]) rotate([-90,0,0]) peg_hole();
        
        for(i=[0,1]) mirror([i,0,0])
            translate([-size/2,0,0]) rotate([0,90,0]) peg_hole();
    }
}

module peg_tetrahedron(){    
    size = 37;
    
    rad = 2;
    $fn=30;
    //translate([0,0,-2/3*size+rad])
    difference(){
        hull(){        
            translate([sqrt(8/9)*size, 0, -1/3*size]) sphere(r=rad);
            translate([-sqrt(2/9)*size, sqrt(2/3)*size, -1/3*size]) sphere(r=rad);
            translate([-sqrt(2/9)*size, -sqrt(2/3)*size, -1/3*size]) sphere(r=rad);
            translate([0, 0, 1*size]) sphere(r=rad);
        }
        
        translate([0,0,-size*1/3-rad]) peg_hole();
        #for(i=[0:360/3:359]) rotate([0,0,i]) rotate([0,109.5,0]) translate([0,0,-size*1/3-rad]) peg_hole();
    }
}

module peg_skiff_cube(){
    size = size-block_slop;
    difference(){
        intersection(){
            cube([size, size, size], center=true);
            
            hull(){
                translate([0,-size/4,-size/2+pin_rad]) rotate([0,90,0]) cylinder(r=pin_rad, h=size, center=true);
                translate([0,-size,-size/2+pin_rad]) rotate([0,90,0]) cylinder(r=pin_rad, h=size, center=true);
                translate([0,-size,size/2+pin_rad]) rotate([0,90,0]) cylinder(r=pin_rad, h=size, center=true);
                translate([0,size/2-pin_rad,size/2-pin_rad]) rotate([0,90,0]) cylinder(r=pin_rad, h=size, center=true);
            }
        }
        
        mirror([0,0,1])
            translate([0,0,-size/2]) peg_hole();
        
            translate([0,-size/2,0]) rotate([-90,0,0]) peg_hole();
        
        for(i=[0,1]) mirror([i,0,0])
            translate([-size/2,0,0]) rotate([0,90,0]) peg_hole();
    }
}

module peg_skiff_sidecube(){
    size = size-block_slop;
    difference(){
        intersection(){
            cube([size, size, size], center=true);
            
            translate([size,0,-gutter_wall-size/2]) gutter_inside(notch = true);
            
            hull(){
                translate([0,-size/4,-size/2+pin_rad]) rotate([0,90,0]) cylinder(r=pin_rad, h=size, center=true);
                translate([0,-size,-size/2+pin_rad]) rotate([0,90,0]) cylinder(r=pin_rad, h=size, center=true);
                translate([0,-size,size/2+pin_rad]) rotate([0,90,0]) cylinder(r=pin_rad, h=size, center=true);
                translate([0,size/2-pin_rad,size/2-pin_rad]) rotate([0,90,0]) cylinder(r=pin_rad, h=size, center=true);
            }
        }
        
        mirror([0,0,1])
            translate([0,0,-size/2]) peg_hole();
        
            translate([0,-size/2,0]) rotate([-90,0,0]) peg_hole();
        
        mirror([1,0,0])
            translate([-size/2,0,0]) rotate([0,90,0]) peg_hole();
    }
}

module peg_rod(){
    size = size-block_slop;
    difference(){
        intersection(){
            cube([size, size, size], center=true);
            cylinder(r=pin_rad+pin_nub+3, h=size, center=true);
        }
        
        for(i=[0,1]) mirror([0,0,i])
            translate([0,0,-size/2]) peg_hole();
    }
}

module peg_cylinder(){
    size = size-block_slop;
    difference(){
        intersection(){
            cube([size, size, size], center=true);
            cylinder(r=size/2, h=size, center=true);
        }
        
        for(i=[0,1]) mirror([0,0,i])
            translate([0,0,-size/2]) peg_hole();
        
        for(i=[0,1]) mirror([0,i,0])
            translate([0,-size/2,0]) rotate([-90,0,0]) peg_hole();
        
        for(i=[0,1]) mirror([i,0,0])
            translate([-size/2,0,0]) rotate([0,90,0]) peg_hole();
    }
}

module peg_sphere(){
    size = size-block_slop;
    difference(){
        intersection(){
            cube([size, size, size], center=true);
            sphere(r=size/2+block_slop);
        }
        
        for(i=[0,1]) mirror([0,0,i])
            translate([0,0,-size/2]) peg_hole();
        
        for(i=[0,1]) mirror([0,i,0])
            translate([0,-size/2,0]) rotate([-90,0,0]) peg_hole();
        
        for(i=[0,1]) mirror([i,0,0])
            translate([-size/2,0,0]) rotate([0,90,0]) peg_hole();
    }
}

module peg_sidecube(){
    size = size-block_slop;
    difference(){
        intersection(){
            cube([size, size, size], center=true);
            translate([size,0,-gutter_wall-size/2]) gutter_inside(notch = true);
        }
        
        for(i=[0,1]) mirror([0,0,i])
            translate([0,0,-size/2]) peg_hole();
        
        for(i=[0,1]) mirror([0,i,0])
            translate([0,-size/2,0]) rotate([-90,0,0]) peg_hole();
        
        mirror([1,0,0])
            translate([-size/2,0,0]) rotate([0,90,0]) peg_hole();
        
    }
}