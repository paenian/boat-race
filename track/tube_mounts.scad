in = 25.4;

tube_rad = in * .25;
gutter_wall = 2.6;

screw_rad = 5.3/2;
screw_cap_rad = 9.2/2;
nut_rad = 10.3/2;
wall = 4;

!endcap_tube_mount();
gutter_tube_mount();



$fn=60;

//clamp to downspouts and hang the vacuum tube?
module drain(){
}

//clamp the tube to the side of the k-type gutter
module tube_mount(solid = 1, length=15, open_angle = 40, chamfer = false){
    if(solid == 1){
        rotate([90,0,0]) cylinder(r=tube_rad+wall, h=length, center=true);
    }else{
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
        
        if(chamfer == true){
            for(i=[0:1]) mirror([0,i,0]) translate([0,-length/4,0]) rotate([90,0,0]) cylinder(r1=tube_rad+.1, r2=tube_rad+.1+length/2, h=length/2, center=false);
        }
    }
}

module gutter_tube_mount(length = 29, slit_depth = 13, open_angle = 50, lift = 16){
    lip_width = 15;
    lip_height = 10;
    lip_lift = 6;
    
    slit_offset = -6;
    
    difference(){
        hull(){
            tube_mount(solid = 1, length=length, open_angle = open_angle);
            translate([0,0,-tube_rad-slit_depth/2-lift]) cube([length,gutter_wall+wall*6,slit_depth], center=true);
        }
        tube_mount(solid = -1, length=length, open_angle = open_angle, chamfer=true);
        
        translate([0,slit_offset,0]){
            //gutter lip
            translate([0,lip_width/2-gutter_wall/2,-tube_rad-lip_height/2-lip_lift]) cube([100, lip_width, lip_height], center=true);
        
            //slit for gutter
            translate([0,0,-tube_rad-slit_depth/2-lift]) cube([length*2,gutter_wall+.1,slit_depth+.1], center=true);
        
            //screwhole
            translate([0,0,-tube_rad-slit_depth/2-lift]) rotate([90,0,0]){
                cylinder(r=screw_rad, h=50, center=true);
                translate([0,0,gutter_wall*3]) cylinder(r=screw_cap_rad, h=50);
                translate([0,0,-gutter_wall*3]) rotate([180,0,0]) cylinder(r=nut_rad, h=50, $fn=6);
            }
        }
    }
}

//clamp the tube to the back of the gutter.  Screws to clamp on, print in TPU.
module endcap_tube_mount(length = 15, slit_depth = 13, open_angle = 50, lift = 7){
    difference(){
        hull(){
            tube_mount(solid = 1, length=length, open_angle = open_angle);
            translate([0,0,-tube_rad-slit_depth/2-lift]) cube([length,gutter_wall+wall*4,slit_depth], center=true);
        }
        tube_mount(solid = -1, length=length, open_angle = open_angle);
        
        //slit for gutter
        translate([0,0,-tube_rad-slit_depth/2-lift]) cube([length*2,gutter_wall+.1,slit_depth+.1], center=true);
        
        //screwhole
        translate([0,0,-tube_rad-slit_depth/2-lift]) rotate([90,0,0]){
            cylinder(r=screw_rad, h=50, center=true);
            translate([0,0,gutter_wall*3]) cylinder(r=screw_cap_rad, h=50);
            translate([0,0,-gutter_wall*3]) rotate([180,0,0]) cylinder(r=nut_rad, h=50, $fn=6);
        }
    }
}