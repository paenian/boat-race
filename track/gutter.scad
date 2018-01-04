include <../configuration.scad>

wall = gutter_wall;
mount_wall = gutter_mount_wall;
center_wall = gutter_center_wall;


bottom_width = gutter_bottom_width;
top_width = gutter_top_width;
mid_height = gutter_mid_height;
top_height = gutter_top_height;
min_rad = gutter_min_rad;

notch_inset = 12;

$fn=60;

part = 5;

if(part == 0){
    rotate([90,0,0]) gutter_mount_double(h=20);
}

if(part == 1){
    rotate([90,0,0]) gutter_mount_triple(h=20);
}

if(part == 2){
    rotate([90,0,0]) gutter_twist_lock();
}

if(part == 3){
    rotate([90,0,0]) gutter_inside(h=10, notch = true, lock = true, twist = true);
}

if(part == 4){
    gutter_inside();
}

if(part == 5){
    bucket_mount();
}

if(part == 6){
    mirror([1,0,0]) bucket_mount();
}

if(part == 10){
    assembled();
}

module assembled(){
    gutter_sep = top_width-wall+mount_wall+center_wall;
    //gutter stays
    gutter_mount_double(h=20);
    for(i=[0,180]) rotate([0,0,i]) translate([gutter_sep,0,0]) gutter_mount_triple(h=20);
        
    //gutter accoutrements
    translate([gutter_sep/2,0,0]) gutter_twist_lock();
    translate([-gutter_sep/2,0,0]) gutter_inside(h=10, notch = true, lock = true, twist = true);
    
    //bucket mounts
    translate([10,60,0]) bucket_mount();
    mirror([1,0,0]) translate([10,60,0]) bucket_mount();
}

//this mounts the hose manifold to the bucket.
module bucket_mount(){
    top_height = 18;
    thickness = 17;
    strap_wall = 5;
    
    mount_x_offset = 23;
    
    bucket_wall = 3.5;
    bucket_rim_height = 23.5;
    
    bolt_rad = 6/2;
    bolt_cap_rad = 14/2;
    
    min_rad = 1.5;
    
    difference(){
        minkowski(){
            sphere(r=min_rad);
    difference(){
        union(){
            //top
            translate([0,0,min_rad]) hull(){
                cylinder(r=top_height/2-min_rad, h=thickness-min_rad*2);
                translate([mount_x_offset-top_height/2+strap_wall,0,0]) cylinder(r=top_height/2-min_rad, h=thickness-min_rad*2);
            }
            
            //rear wall
            translate([mount_x_offset-top_height/2+strap_wall,0,min_rad]) 
            hull(){
                cylinder(r=top_height/2-min_rad, h=thickness-min_rad*2);
                translate([0,-bucket_rim_height-strap_wall,0]) cylinder(r=top_height/2-min_rad, h=thickness-min_rad*2);
            }
        }
        
        //bucket cutout
        translate([mount_x_offset,-top_height/2,0]) {
            translate([-bucket_wall/2,-bucket_rim_height/2,0]) cube([bucket_wall+min_rad*2, bucket_rim_height+min_rad*2, thickness*3], center=true);
            translate([-20/2,-(bucket_rim_height-bucket_wall)/2,0]) cube([20+min_rad*2, bucket_rim_height-bucket_wall+min_rad*2, thickness*3], center=true);
        }
        
        
        //chamfer to make the part look less chunky
        translate([0,0,50+9]) rotate([0,-17,0]) cube([100,100,100], center=true);
        
    }
    
    }
        //hole for the bolt
        translate([0,0,-1]) cylinder(r=bolt_rad, h=thickness*2);
        translate([0,0,bolt_rad]) cylinder(r=bolt_cap_rad, h=thickness*2);
    }
    
}

//locking gutter mount
module gutter_twist_lock(){
    center_width = in/2;
    difference(){
        union(){
            gutter_inside(h=center_width, notch = true, lock = true);
            
            //nubs
            translate([0,0,top_height-15]) for(i=[0:1]) for(j=[0:1]) mirror([i,0,0]) mirror([0,j,0]) translate([top_width/2*.99,center_width*.333,0]){
                scale([.5,1,1]) sphere(r=2);
            }
        }
        
        //big center hollow
        translate([0, 0, bottom_width/3]) 
        scale([.75,.75,.75]){
            gutter_inside(h=center_width*2);
        }
        
        //pipe hole
        translate([0,0,in/2]) rotate([90,0,0]) {
            cylinder(r1=in*3/16, r2=in*5/16, h=center_width+3, center=true);
            cylinder(r1=in*5/16, r2=in*3/16, h=center_width+3, center=true);
        }
    }
}

module gutter_inside(h=in * 6, notch = false, lock = false, twist = false){
    scale([.99,h/10,.99])
    difference(){
        gutter_helper(solid=0);
        echo((top_width/2-4.25)*2*.99);
        
        if(notch == false){
            for(i=[0,1]) mirror([i,0,0]) translate([50+top_width/2-4.25,0,0]) cube([100,100,200], center=true);
        }else{
            for(i=[0,1]) mirror([i,0,0]) translate([50+top_width/2-4.25,0,100+top_height+wall-.1-notch_inset]) cube([100,100,200], center=true);
        }
    }
}

module gutter_helper(solid=1){
    translate([0,0,wall])
    hull(){
        for(i=[0,1]) mirror([i,0,0]) {
            //bottom
            translate([bottom_width/2-min_rad,0,min_rad]) rotate([90,0,0]) cylinder(r=min_rad+solid*wall, h=10+1-solid, center=true);
            
            //middle
            translate([top_width/2-min_rad,0,mid_height]) rotate([90,0,0]) cylinder(r=min_rad+solid*wall, h=10+1-solid, center=true);
            
            //top
            translate([top_width/2-5+solid*wall,0,top_height-5]) cube([10,10+1-solid,10], center=true);
        }
    }
}

module gutter(h=25){
    scale([1,h/10,1])
    difference(){
        gutter_helper(solid = 1);
        gutter_helper(solid = 0);
    }
}

module gutter_mount_triple(h=10){
    difference(){
        union(){
            gutter_mount_double(h=20);
        
            translate([top_width+center_wall/2+wall*2,0,0]) rotate([0,0,180]) gutter_mount(h=20);
        
            translate([(top_width+center_wall+wall*2)/2,0,-mount_wall/2]) cube([25,h,mount_wall], center=true);
        }
        
        //make some screwholes on the ends
        translate([top_width+center_wall/2+wall,0,0]) screwhole(angle = true);
    }
}

module gutter_mount_double(h=10){
    difference(){
        union(){
            for(i=[0,180]) rotate([0,0,i]) translate([center_wall/2-.1,0,0]) gutter_mount(h=h);
            cube([20,h,mount_wall*2], center=true);
        }
            
        //center hole for pipes or whatevs
        translate([0,0,13]) rotate([90,0,0]) scale([.8,1,1]) rotate([0,0,90]) cylinder(r=center_wall+10, h=h*3, center=true, $fn=3);
        
         screwhole();
    }
        
    %cylinder(r=center_wall/2, h=200, center=true);
}

//strap a gutter to a surface.  Actually does half a gutter.
//Double does half of two gutters... they meet in the middle.
module gutter_mount(single = false, h=10){
    mount_width = top_width/2;
    mount_height = top_height+wall+mount_wall*2;
    difference(){
        union(){
            hull(){
                translate([0,0,center_wall/2-mount_wall]) rotate([90,0,0]) cylinder(r=center_wall/2, h=h, center=true);
                translate([0,0,top_height]) rotate([90,0,0]) cylinder(r=center_wall/2, h=h, center=true);
                
                translate([top_width/2+wall,0,0]) rotate([90,0,0]) cylinder(r=mount_wall, h=h, center=true);
            }
        }
        
        difference(){
            union(){
                translate([top_width/2+wall,0]) scale([1,(h+1)/10,1.01])
            gutter_helper(solid=1);
                
                //cut out above the gutter center
                translate([5+wall/2+wall,0,top_height+wall]) cube([10,50,20], center=true);
            }
            
            //leave a notch around the top to secure it
            translate([(wall)/2+wall+1.5,0,top_height+wall-1]) hull(){
                rotate([90,0,0]) cylinder(r=wall/2+1, h=h+10, center=true);
                translate([0,0,10]) rotate([90,0,0]) cylinder(r=wall/2+1, h=h+10, center=true);
            }
        }
        
        //cut a slant so we can interface with the next piece
        translate([h*1.5*sqrt(2) + top_width/2+wall-.2,0,-h*1.5-mount_wall/2+.1]) rotate([0,0,45]) cube([h*3,h*12,h*3], center=true);
        translate([h*1.5*sqrt(2) + top_width/2+wall-.2,0,h*1.5-mount_wall/2-.1]) rotate([0,0,-45]) cube([h*3,h*12,h*3], center=true);
        
        //mounting hole
        *translate([top_width/3.5,0,0]) screwhole();
    }
}

//todo: we'll need fancy inset screws.
module screwhole(angle = false){
    screw_rad = 2.5+.5;
    screw_cap_rad = 5.2;
    screw_cap_height = 3.5;
    
    if(angle==false){
        cylinder(r=screw_rad, h=300, center=true);
    }else{
        translate([0,0,-49]) cylinder(r=screw_rad, h=50);
    }
    translate([0,0,-screw_cap_height]) cylinder(r1=screw_rad, r2=screw_cap_rad, h=screw_cap_height);
    translate([0,0,-.1]) cylinder(r=screw_cap_rad, h=screw_cap_height*4+.1);
    
    if(angle==true){
        hull(){
            translate([0,0,-screw_cap_height]) cylinder(r1=screw_rad, r2=screw_cap_rad, h=screw_cap_height);
            rotate([0,20,0]) translate([0,0,-.1]) cylinder(r=screw_cap_rad, h=screw_cap_height*20);
        }
    }
    
}