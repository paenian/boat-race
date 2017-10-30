use <gutter.scad>
use <screwthread.scad>

in = 25.4;
height = 157;
rad = 23;
leg_rad = 7;
leg_angle = 13+4;

wall = 3;

width = rad+wall/2+leg_rad;

//braces on the legs
brace_angle = 31;
brace_height = -41;
brace_rad = 7;

//this is the final outlet!
drip_wall = 2;
drip_rad = 4;
drip_len = 13;
drip_angle = -67;

inlet_rad = 3/8*in/2;
inlet_wall = 2;
inlet_length = 13+leg_rad;
inlet_angle = 43;
inlet_offset = width/2;

echo(drip_rad-drip_wall);
echo(inlet_rad-inlet_wall);

axle_rad = 5/2;



%cube([10,10,100], center=true);
    
%translate([0,0,-height/2-14]) gutter();

odoshi_angle = 57;
odoshi_lift = 47; //29;   //this is the space at the base, so that we're sure it'll get top-heavy and tip over.



$fn = 60;

difference(){
    shishi();
    *translate([0,100,0]) cube([200,200,200], center=true); //slices to check the internal pipes
    *translate([100,0,0]) cube([200,200,200], center=true);
}

//for printing
*rotate([-odoshi_angle,0,0])
odoshi();

//for positioning
rotate([-5,0,0]) rotate([13+43*1,0,0])
odoshi();



//an axle that screws in
!flip_axle();

module flip_axle(){
    cap = axle_rad/2+1;
    flip = 23;
    length = (rad+wall+leg_rad)*2+leg_rad*2+cap+flip;
    
    flip_offset = length/2-flip+9;
    flip_drop = -1;
    
    axle_slop = .2;
    axle_r1 = .75;
    axle_r2 = 2;
    axle_len = 3;
    
    translate([8,0,0])
    difference(){
        union(){
            rotate([0,90,0]) cap_cylinder(r=axle_rad-axle_slop, h=length, center=true);
            //cap on one end 
            translate([axle_rad/2-length/2,0,0]) rotate([90,0,0]) rotate([0,0,-90]) cap_cylinder(r=axle_rad, h=axle_rad*3, center=true);
        }
        
        //other end rotates down
        difference(){
            //angled cut
            translate([flip_offset,0,0]) rotate([0,45,0])
        cube([axle_slop,10,10], center=true);
            
            //leave the axis to rotate around
            translate([flip_offset,0,0]) rotate([0,-45,0]) translate([flip_drop,0,-axle_slop/2-.01]) cylinder(r1=axle_r1, r2=axle_r2, h=axle_len);
        }
        
        //carve out around the axle
        difference(){
            translate([flip_offset,0,0]) rotate([0,-45,0]) translate([flip_drop,0,-axle_slop/2-.01]) cylinder(r1=axle_r1+axle_slop, r2=axle_r2+axle_slop, h=axle_len+axle_slop);
            
            translate([flip_offset,0,0]) rotate([0,-45,0]) translate([flip_drop,0,-axle_slop/2-.01]) cylinder(r1=axle_r1, r2=axle_r2, h=axle_len);
        }
        
        //ensure a flat bottom
        translate([0,0,-100-axle_rad+axle_slop+.01]) cube([200,200,200], center=true);
    }
}

//a rubber cap type base/top.
//deprecated!
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

//deprecated
module base_pipes(solid=1, base=true){
    bump_height = 10;
    pipe_rad = leg_rad;
        output_len = 53;
    
    pump_wall = 2.5;
    pump_rad = .5*in/2+wall;
    pump_len = 71;

    
    
    base_rad = leg_rad+2;
    
    base_len = width*3;

    
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
//deprecated
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
        rotate([-odoshi_angle,0,0]) translate([0,0,height/2+50-29-13-2]) cube([200,200,100], center=true);
        
        //cut the bottom?
    }
}

module frame(solid = 1){
    
    bump_height = 10;
    pipe_rad = leg_rad;
    output_len = 57;
    
    upper_frame_lift = 17;
    
    tube_id = 1/4*in;
    tube_rad = tube_id/2;
    
    
    //base - connect up the tubes, and allow for an inlet.
    //u-shape - leave the front open.
    //spheres at the bottom intersections
    for(i=[0:1]) for(j=[0:1]) mirror([i,0,0]) translate([width,0,0]) {
        mirror([0,j,0]) rotate([leg_angle,0,0]) rotate([0,0,-90]) translate([0,0,-height/2+leg_rad]){
            sphere(r=(leg_rad+wall*1.6+solid*wall*.75)/2);
        }
        
        //connect the side legs
        rotate([leg_angle,0,0]) translate([0,0,-height/2+leg_rad]) rotate([-leg_angle,0,0]) translate([0,-21,0]) rotate([90,0,0]) rotate([0,0,90]) cap_tube(r=leg_rad, h=43, solid=solid, wall=wall);
    }
    
    //connect the front legs
    rotate([-leg_angle,0,0]) translate([0,0,-height/2+leg_rad]) 
    rotate([leg_angle,0,0])
    translate([0,0,0]) rotate([0,0,90]) rotate([90,0,0]) rotate([0,0,90]) cap_tube(r=leg_rad, h=width*2, solid=solid, wall=wall);
    
    //and this is the inlet - connects to 3/8OD, 1/4ID hose.
    rotate([leg_angle,0,0]) translate([inlet_offset,0,-height/2+leg_rad]) rotate([-leg_angle,0,0]) translate([0,-42,0]) rotate([inlet_angle,0,0]) translate([0,-inlet_length/2,0,0]) rotate([90,0,0]) rotate([0,0,-90]) translate([0,0,-inlet_length/2]) cap_tube(r=inlet_rad, h=inlet_length, solid=solid, wall=inlet_wall);
    
    
    //lower frame
    for(i=[0,1]) mirror([i,0,0]) translate([width,0,0]){
        //X beams
        rotate([leg_angle,0,0]) rotate([0,0,-90]) translate([0,0,-height/4]) cap_tube(r=leg_rad, h=height/2-leg_rad*2, solid=solid, wall=wall);
        rotate([-leg_angle,0,0]) rotate([0,0,90]) translate([0,0,-height/4]) cap_tube(r=leg_rad, h=height/2-leg_rad*2, solid=solid, wall=wall);
        
        //this is to let water flow around the axle
        rotate([0,-90,0]) cap_tube(r=axle_rad+wall*3, h=leg_rad*2+solid*wall/2, solid=solid, wall=wall);
    }
    
    //upper frame - meetup in the middle
    for(i=[0,1]) mirror([i,0,0]) translate([width,0,0]){
        //lift the upper
        rotate([0,0,180]) translate([0,0,upper_frame_lift/2]) cap_tube(r=leg_rad, h=upper_frame_lift, solid=solid, wall=wall);
        
        //sphere joint for the lift
        translate([0,0,upper_frame_lift]) sphere(r=(leg_rad*2+solid*wall)/2);
        
        //angled beams to meet in the middle
        translate([0,0,upper_frame_lift]) rotate([0,-43,0]) rotate([0,0,180]) translate([0,0,43/2]) cap_tube(r=leg_rad, h=43, solid=solid, wall=wall);
    }
    
    //this is the final outlet!
    if(solid == 1){
        hull(){
            mirror([0,0,1]) translate([0,-output_len,0]) rotate([leg_angle,0,0]) translate([0,0,-height/2-pipe_rad-bump_height/2]) rotate([90-leg_angle,0,0])
        rotate([drip_angle,0,0]) rotate([0,0,90]) cap_tube(solid=solid, r=drip_rad, h=drip_len, center=false, outside=true, wall=drip_wall);
            translate([0,0,49]) sphere(r=(leg_rad*2+solid*wall)/2);
        }
    }else{
        //inside path
        hull(){
            mirror([0,0,1]) translate([0,-output_len,0]) rotate([leg_angle,0,0]) translate([0,0,-height/2-pipe_rad-bump_height/2]) rotate([90-leg_angle,0,0])
        rotate([drip_angle,0,0]) rotate([0,0,90]) translate([0,0,wall]) cap_tube(solid=solid, r=drip_rad, h=drip_len-wall*4, center=false, outside=true, wall=drip_wall);
            translate([0,0,50]) sphere(r=(leg_rad*2+solid*wall)/2);
        }
        //exit
        mirror([0,0,1]) translate([0,-output_len,0]) rotate([leg_angle,0,0]) translate([0,0,-height/2-pipe_rad-bump_height/2]) rotate([90-leg_angle,0,0])
        rotate([drip_angle,0,0]) rotate([0,0,90]) translate([0,0,wall]) cap_tube(solid=solid, r=drip_rad, h=drip_len+wall*2, center=false, outside=true, wall=drip_wall);
        //cut the tip a bit
        translate([0,-61,70+drip_len/2-1]) rotate([5,0,0]) cube([30,50,50], center=true);
    }
    
    
    if(solid == 1){
        //cross brace the base
        //for(k=[0,1]) mirror([0,k,0])
        for(i=[-1,1]) rotate([leg_angle,0,0]) translate([0,0,brace_height]) rotate([0,90+brace_angle*i,0]) cylinder(r=axle_rad, h=(rad+wall+leg_rad)*2.2, center=true);
    }
}

//this is the base.  Shishi doesn't mean frame, but, well, it
//needed to be split up.
module shishi(){
    difference(){
        union(){
            intersection(){
                frame(solid=1);
                
                hull(){
                    translate([0,0,-height/2+leg_rad/2+.75]) gutter_inside(h=200);
                    translate([0,0,height/2]) gutter_inside(h=200);
                }
            }
            
            
            //axle
            #for(i=[0,1]) mirror([i,0,0]) translate([rad+wall+leg_rad,0,0]) rotate([0,90,0]) cap_tube(r=axle_rad+wall, h=leg_rad*2, solid=1, wall=wall);
        }
        
        difference(){
            frame(solid=-1);
            
            //axle
            rotate([0,90,0]) cap_tube(r=axle_rad+wall, h=200, solid=1, wall=wall);
        }
        
        //axle
        rotate([0,90,0]) cap_tube(r=axle_rad+wall, h=200, solid=-1, wall=wall);
        
        //flatten the base a little
        *translate([0,0,-100-height/2+4]) cube([200,200,200], center=true);
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
