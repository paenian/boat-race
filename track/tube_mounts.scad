in = 25.4;

tube_rad = in * .25;
gutter_wall = 2;

screw_rad = 5.3/2;
screw_cap_rad = 9.2/2;
nut_rad = 10.3/2;
wall = 4;

gutter_tube_mount();

$fn=60;

//clamp the tube to the back of the gutter.  Screws to clamp on, print in TPU.
module gutter_tube_mount(length = 15, slit_depth = 13, open_angle = 50, lift = 7){
    difference(){
        hull(){
            rotate([90,0,0]) cylinder(r=tube_rad+wall, h=length, center=true);
            translate([0,0,-tube_rad-slit_depth/2-lift]) cube([length,gutter_wall+wall*2,slit_depth], center=true);
        }
        //tube hole
        rotate([90,0,0]) cylinder(r=tube_rad+.1, h=50, center=true);
        
        //opening at the top
        difference(){
            intersection(){
                translate([0,-25,0]) rotate([0,-45+open_angle/2,0]) cube([50,50,50]);
                translate([0,-15,0]) rotate([0,-45-open_angle/2,0]) cube([50,50,50]);
            }
            for(i=[0,1]) mirror([i,0,0]) rotate([0,open_angle/2, 0]) translate([0,0,tube_rad+wall/2]) rotate([90,0,0]) cylinder(r=wall/2+.15, h=50, center=true);
        }
        
        //zip tie slot
        rotate([90,0,0]) rotate_extrude(){
            translate([tube_rad+wall,0,0]) square([2,4], center=true);
        }
        
        //slit for gutter
        translate([0,0,-tube_rad-slit_depth/2-lift]) cube([length*2,gutter_wall+.1,slit_depth+.1], center=true);
        
        //screwhole
        translate([0,0,-tube_rad-slit_depth/2-lift]) rotate([90,0,0]){
            cylinder(r=screw_rad, h=50, center=true);
            translate([0,0,gutter_wall*2]) cylinder(r=screw_cap_rad, h=50);
            translate([0,0,-gutter_wall*2]) rotate([180,0,0]) cylinder(r=nut_rad, h=50, $fn=6);
        }
    }
}