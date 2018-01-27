width = 40;
span = 18;
center_width = 15;

thickness = 11;

screw_inset = 3;

rod_rad = 6/2;
rod_height = 5;

fanclamp();

module fanclamp(){
    minrad = 2;
    difference(){
        minkowski(){
                //base
                translate([0,span/4,thickness/2]) cube([width, span, thickness-minrad*2], center=true);
            
            sphere(r=minrad, $fn=12);
        }
        
        //hollow out the strip
        translate([0,height/2,0]) cube([width, height+.1, thickness*4], center=true);
        
        //rod hole
        hull() {
            rotate([0,90,0]) cylinder(r=rod_rad, h=100, center=true);
            translate([0,0,rod_height]) rotate([0,90,0]) cylinder(r=rod_rad, h=100, center=true);
        }
        
        //mount hole
        cube([center_width,center_width,100], center=true);
        
        //and add some screwholes
        for(i=[-1,1]) translate([i*(width-7)/2, thickness-minrad, thickness/2+2]) screw_hole();
    }
}



module screw_hole(){
    $fn=32;
    cap_rad = 5.5/2;
    rad = 3/2;
    cap_height = 2;
    
    translate([0,0,-cap_height+.1])
    cylinder(r1=rad, r2=cap_rad, h=cap_height);
    cylinder(r=rad, h=30, center=true);
    cylinder(r=cap_rad, h=30);
}