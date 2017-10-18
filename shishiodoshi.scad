height = 157;
rad = 19;
leg_rad = 7;
leg_angle = 13;
brace_angle = 31;
brace_height = -45;

axle_rad = 5/2;

brace_rad = 6;

odoshi_angle = 43;
odoshi_lift = 13;   //this is the space at the base, so that we're sure it'll get top-heavy and tip over.

wall = 3;

shishi();

odoshi();

//todo: make a rubber cap type base/top.


module odoshi(){
    rotate([odoshi_angle,0,0]) 
    difference(){
        union(){
            translate([0,0,odoshi_lift]) cylinder(r=rad, h=height+odoshi_lift, center=true);
            
            *translate([10,0,odoshi_lift]) cylinder(r=rad, h=height, center=true);
            
            //axle
            rotate([0,90,0]) cap_tube(r=axle_rad+wall+1, h=rad*2, solid=1, wall=wall);
        }
        
        //hollow it out
        difference(){
            translate([0,0,-.1]) cylinder(r=rad-wall, h=height*2, center=true);
            //the bottom :-)
            translate([0,0,-height/2+odoshi_lift]) cube([100,100,wall*2], center=true);
            
            //axle repeated
            rotate([0,90,0]) cap_tube(r=axle_rad+wall+1, h=rad*2, solid=1, wall=wall);
        }
        
        //axle hole
        rotate([0,90,0]) cap_tube(r=axle_rad+wall+1, h=rad*2+leg_rad*2+wall*2, solid=-1, wall=wall);
        
        //cut the top
        rotate([-odoshi_angle,0,0]) translate([0,0,height/2+50-17]) cube([200,200,100], center=true);
    }
}

module frame(solid = 1){
   
    
    //frame
    for(i=[0,1]) mirror([i,0,0]) translate([rad+wall+leg_rad,0,0]){
        //X beams
        rotate([leg_angle,0,0]) rotate([0,0,-90]) cap_tube(r=leg_rad, h=height, solid=solid, wall=wall);
        rotate([-leg_angle,0,0]) rotate([0,0,90]) cap_tube(r=leg_rad, h=height, solid=solid, wall=wall);
        
        //this is to let water flow around the axle
        rotate([0,-90,0]) cap_tube(r=axle_rad+wall*3, h=leg_rad*2+solid*wall/2, solid=solid, wall=wall);
    }
    
    if(solid == 1){
        //cross brace the base
        for(k=[0,1]) mirror([0,k,0])
        for(j=[0,1]) mirror([0,0,j])
        for(i=[-1,1]) rotate([leg_angle,0,0]) translate([0,0,brace_height]) rotate([0,90+brace_angle*i,0]) cylinder(r=axle_rad, h=(rad+wall+leg_rad)*2.2, center=true);
    }
}

//this is the base.  Shishi doesn't mean frame, but, well, it
//needed to be split up.
module shishi(){
    difference(){
        union(){
            frame(solid=1);
            
            //axle
            for(i=[0,1]) mirror([i,0,0]) translate([rad+wall+leg_rad,0,0]) rotate([0,90,0]) cap_tube(r=axle_rad+wall, h=leg_rad*2, solid=1, wall=wall);
        }
        
        difference(){
            frame(solid=-1);
            
            //axle
            rotate([0,90,0]) cap_tube(r=axle_rad+wall, h=200, solid=1, wall=wall);
        }
        
        //axle
        rotate([0,90,0]) cap_tube(r=axle_rad+wall, h=200, solid=-1, wall=wall);
    }
}

module cap_tube(wall=3, solid=1, r = 3, h=5, center=true, outside=true, r_slop=0){
    if(solid >= 0){
        cap_cylinder(r = r, h=h, center=center, outside=outside, r_slop=r_slop);
    }
    if(solid <= 0){
        cap_cylinder(r = r-wall, h=h+.1, center=center, outside=outside, r_slop=r_slop);
    }
}

//A cylinder with a flat on it - used for printing overhangs, mainly.
//
//When printing an axle, put the flat spot downwards - it'll make the bottom much cleaner.
//When printing an axle hole, put the flat spot upwards - it'll make the ceiling cleaner.
module cap_cylinder(r = 3, h=5, center=true, outside=true, r_slop=0){
    difference(){
        hull(){
            cylinder(r=r-r_slop, h=h, center=center);
        
            if(outside == true){
                intersection(){
                    translate([r/2,0,0]) cube([r,r,h], center=center);
                    cylinder(r=(r-r_slop)/cos(180/4), h=h, center=center, $fn=4);
                }
            }
        }
        
        //this makes it into a D-shaft, basically.
        if(outside == false){
            translate([r,0,0]) cube([r/6,r,h+1], center=center);
        }
    }
}
