in = 25.4;
height = 157;
rad = 19;
leg_rad = 7;
leg_angle = 13;
brace_angle = 31;
brace_height = -45;

axle_rad = 5/2;

brace_rad = 6;

odoshi_angle = 43;
odoshi_lift = 47; //29;   //this is the space at the base, so that we're sure it'll get top-heavy and tip over.

wall = 3;

width = rad+wall+leg_rad;

$fn = 60;

shishi();

//for printing
!rotate([-odoshi_angle,0,0])
//rotate([50,0,0]) 
odoshi();

//for positioning
rotate([50,0,0]) 
odoshi();


base();
mirror([0,0,1]) top();

//a rubber cap type base/top.
module top(){
    difference(){
        union(){
            base_pipes(solid=1, base=false);
        }
        
        base_pipes(solid=-1, base=false);
        
        //flatten the base
        translate([0,0,-100-height/2-17.5]) cube([300,300,200], center=true);
    }
}

module base_pipes(solid=1, base=true){
    bump_height = 10;
    pipe_rad = leg_rad;
    
    pump_wall = 2.5;
    pump_rad = .5*in/2+wall;
    pump_len = 71;
    
    drip_wall = 2;
    drip_rad = 4;
    drip_len = 20;
    drip_angle = -75;
    
    
    base_rad = leg_rad+2;
    
    base_len = width*3;
    output_len = 53;
    
    //interface with the uprights
    for(i=[0,1]) for(j=[0,1]) mirror([i,0,0]) mirror([0,j,0]) {
        rotate([leg_angle,0,0]) translate([width,0,-height/2]) rotate([0,0,-90]) {
            //pipes go into here
            if(solid == 1)
                translate([0,0,-pipe_rad/2]) cap_tube(solid=solid, wall=2, r = base_rad, center=true, h=bump_height+pipe_rad);
            if(solid == -1)
                translate([0,0,-pipe_rad/2*0+bump_height/2]) cap_tube(solid=solid, wall=2, r = base_rad+.1, center=true, h=bump_height+pipe_rad);
            
            //and stop against here
            translate([0,0,-pipe_rad/2-bump_height/4]) cap_tube(solid=solid, wall=2, r = leg_rad, center=true, h=bump_height/2+pipe_rad);
        }
    }
    
    //tubes to connect the stubs
    for(i=[0,1]) mirror([0,i,0]) {
        rotate([leg_angle,0,0]) translate([width,0,-height/2-pipe_rad-bump_height/2]) rotate([90-leg_angle,0,0]) rotate([0,-90,0]) rotate([0,0,90]) cap_tube(solid=solid, r=base_rad, h=width*2, center=false, outside=true, wall=4);
    }
    
    //make sure the ends are capped, with spheres
    for(i=[0,1]) for(j=[0,1]) mirror([0,i,0]) mirror([j,0,0]) {
        rotate([leg_angle,0,0]) translate([width,0,-height/2-pipe_rad-bump_height/2]) {
            if(solid == -1)
                sphere(r=leg_rad-wall+1);
            if(solid == 1)
                sphere(r=base_rad);
        }
    }
    
    //outlet pipe
    rotate([leg_angle,0,0]) translate([0,0,-height/2-pipe_rad-bump_height/2]) rotate([90-leg_angle,0,0]) rotate([0,0,90]) cap_tube(solid=solid, r=base_rad, h=output_len, center=false, outside=true, wall=4);
    
    if(base == true){
        //connect the outlet to the pump
        translate([0,-output_len,0])  rotate([leg_angle,0,0]) translate([0,0,-height/2-pipe_rad-bump_height/2]) rotate([90-leg_angle,0,0]) rotate([0,0,90]) cap_tube(solid=solid, r=pump_rad, h=pump_len, center=false, outside=true, wall=pump_wall);
    }else{
        //restrict the flow and turn it downwards
        translate([0,-output_len,0]) rotate([leg_angle,0,0]) translate([0,0,-height/2-pipe_rad-bump_height/2]) rotate([90-leg_angle,0,0]) {
            if(solid == -1)
                sphere(r=leg_rad-wall+1);
            if(solid == 1)
                sphere(r=base_rad);
            rotate([drip_angle,0,0]) rotate([0,0,90]) cap_tube(solid=solid, r=drip_rad, h=drip_len, center=false, outside=true, wall=drip_wall);
            
            //cut the tip a bit
            if(solid == -1){
                translate([0,5,25+drip_len/2-1]) rotate([-15,0,0]) cube([30,50,50], center=true);
            }
        }
    }
    
    //extra long base, to make it stable
    if(base == true){
        for(i=[0,1]) for(j=[0,1]) mirror([0,j,0]) mirror([i,0,0]) {
            if(solid == 1){
                rotate([leg_angle,0,0]) translate([width,0,-height/2-pipe_rad-bump_height/2]) rotate([90-leg_angle,0,0]) rotate([0,0,-90]) cap_tube(solid=solid, r=base_rad, h=width*3, center=false, outside=true, wall=4);
            }
        }
    }
}

//a rubber cap type base/top.
module base(){
    difference(){
        union(){
            base_pipes(solid=1);
        }
        
        base_pipes(solid=-1);
        
        //flatten the base
        translate([0,0,-100-height/2-17.5]) cube([300,300,200], center=true);
    }
}

module odoshi(wall = 2){
    echo(wall);
    rotate([odoshi_angle,0,0]) 
    difference(){
        union(){
            translate([0,0,0]) cylinder(r=rad, h=height, center=true);
            
            //axle
            rotate([0,90,0]) cap_tube(r=axle_rad+wall+1, h=rad*2, solid=1, wall=wall);
        }
        
        //hollow it out
        difference(){
            translate([0,0,-.1]) cylinder(r=rad-wall, h=height*2, center=true);
            //the bottom :-)
            translate([0,0,-height/2+odoshi_lift]) cube([100,100,wall], center=true);
            
            //axle repeated
            rotate([0,90,0]) cap_tube(r=axle_rad+wall+1, h=rad*2, solid=1, wall=wall);
        }
        
        //axle hole
        rotate([0,90,0]) cap_tube(r=axle_rad+wall+1, h=rad*2+leg_rad*2+wall*2, solid=-1, wall=wall);
        rotate([0,-90,0]) cap_tube(r=axle_rad+wall+1, h=rad*2+leg_rad*2+wall*2, solid=-1, wall=wall);
        
        //cut the top
        rotate([-odoshi_angle,0,0]) translate([0,0,height/2+50-29]) cube([200,200,100], center=true);
        
        //cut the bottom?
    }
}

module frame(solid = 1){
   
    
    //frame
    for(i=[0,1]) mirror([i,0,0]) translate([width,0,0]){
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
        
        //flatten the base a little
        translate([0,0,-100-height/2+3]) cube([200,200,200], center=true);
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
                    if(center == true){
                        translate([r/2,0,0]) cube([r,r,h], center=true);
                    }else{
                        translate([r/2,0,h/2]) cube([r,r,h], center=true);
                    }
                    cylinder(r=(r-r_slop)/cos(180/4), h=h, center=center, $fn=4);
                }
            }
        }
        
        //this makes it into a D-shaft, basically.
        if(outside == false){
            if(center == true){
                translate([r,0,0]) cube([r/6,r,h+1], center=true);
            }else{
                translate([r,0,(h+.5)/2]) cube([r/6,r,h+1], center=true);
            }
        }
    }
}
