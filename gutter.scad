in = 25.4;

wall = .075*in;

mount_wall = 6.5;
center_wall = 16;


bottom_width = 2.75*in+.2*in;
top_width = 4.025*in - wall*2+.2*in;
mid_height = 1.3*in;
top_height = 2*in+1;
min_rad = .15*in;


$fn=60;

rotate([90,0,0]) gutter_mount(h=20);
rotate([90,0,0]) gutter_mount_double(h=20);
!rotate([90,0,0]) gutter_mount_triple(h=20);


rotate([90,0,0]) translate([top_width+center_wall/2+wall*2,0,0]) rotate([0,0,180]) gutter_mount(h=20);

%gutter();

*gutter_helper(solid=0);

module gutter_inside(h=25){
    scale([1,h/10,1])
    gutter_helper(solid=0);
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
        translate([0,0,10]) rotate([90,0,0]) scale([.8,1,1]) rotate([0,0,90]) cylinder(r=center_wall+5, h=h*3, center=true, $fn=3);
        
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
    screw_rad = 2.5+.2;
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