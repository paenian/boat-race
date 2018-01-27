width = 56-1.5;
height = 35;

thickness = 9;

stripclamp();

module stripclamp(){
    minrad = 2;
    difference(){
        minkowski(){
            union(){
                //base
                translate([-(width+thickness*3-minrad*2)/2,-minrad,0]) cube([width+thickness*2-minrad*2, thickness-minrad*2+minrad, thickness]);
            
                //around the strip
                translate([-(width+thickness-minrad*2)/2,0,0]) cube([width+thickness-minrad*2, height+thickness-minrad*2, thickness]);
            }
            
            sphere(r=minrad, $fn=12);
        }
        
        //hollow out the strip
        translate([0,height/2,0]) cube([width, height+.1, thickness*4], center=true);
        
        //flatten the base
        translate([-(100-width)/2,-50,0]) cube([100,100,100], center=true);
        
        //and add some screwholes
        for(i=[-1,1]) translate([i*(width+thickness*2-minrad*2)/2, thickness-minrad, thickness/2]) rotate([-90,0,0]) screw_hole();
    }
}



module screw_hole(){
    $fn=32;
    cap_rad = 5.25/2;
    rad = 3/2;
    cap_height = 2;
    
    translate([0,0,-cap_height+.1])
    cylinder(r1=rad, r2=cap_rad, h=cap_height);
    cylinder(r=rad, h=30, center=true);
}