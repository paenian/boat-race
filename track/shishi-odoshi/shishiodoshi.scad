use <../gutter.scad>

in = 25.4;
height = 157;
rad = 23;
leg_rad = 7;
leg_angle = 13+4;

wall = 4;

width = rad+wall/2+leg_rad;

//braces on the legs
brace_angle = 31;
brace_height = -41;
brace_rad = 7;

//this is the final outlet
//change of plans: outlet is printed separately.  So this is thick now.
drip_wall = 2;
inside_drip_wall = 3;
drip_rad = 7;
drip_len = 13;
drip_angle = -67;

%translate([0,0,height/2-7]) cylinder(r=36, h=.1, center=true);
%translate([0,0,height/2+9.5]) cylinder(r=36, h=.1, center=true);

inlet_rad = 3/8*in/2+.5;
inlet_wall = 2;
inlet_length = 13+6;
inlet_angle = 29;
inlet_offset = 0;

echo(drip_rad-drip_wall);
echo(inlet_rad-inlet_wall);

axle_rad = 7/2;



%cube([10,10,100], center=true);
    
%translate([0,0,-height/2-14]) gutter();

odoshi_angle = 57;
odoshi_lift = 47; //29;   //this is the space at the base, so that we're sure it'll get top-heavy and tip over.
extra_height = 10;

$fn = 60;

part = 0;

if(part == 0)
    shishi();
if(part == 1)
    rotate([-odoshi_angle,0,0]) odoshi();
if(part == 2)
    drip_spout();
if(part == 3)
    peg_axle();

if(part == 10){
    union(){
        odoshi();
        
        rotate([-drip_angle,0,0]) rotate([0,180,0]) translate([0,0,-66.8]) drip_spout();
        peg_axle();
        
        difference(){
            shishi();
    
            //translate([0,100,0]) cube([200,200,200], center=true); //slices to check the internal pipes
            //translate([100,0,0]) cube([200,200,200], center=true);
        }
    }
}



//for printing
*rotate([-odoshi_angle,0,0])
odoshi();





module peg_axle(){
        cap = axle_rad/2+1;
    flip = 17;
    length = (rad+wall+leg_rad)*2+leg_rad*2+cap+flip;
    
    flip_offset = length/2-flip+9;
    flip_drop = -1;
    
    axle_slop = .25;
    flip_slop = .5;
    axle_r1 = .75;
    axle_r2 = 4;
    axle_len = 8;
    flip_angle = 45;
    
    translate([5.5,0,0])
    difference(){
        union(){
            translate([-3,0,0]) rotate([0,90,0]) cap_cylinder(r=axle_rad-axle_slop, h=length-6, center=true);
            //cap on one end 
            translate([axle_rad/2-length/2,0,0]) rotate([0,90,0]) cap_cylinder(r=axle_rad*2, h=axle_rad, center=true);
            
            //flare on the other
            translate([-flip/2+length/2-2,0,0]) hull(){
                intersection(){
                    %rotate([0,90,0]) cap_cylinder(r=axle_rad*1.5, h=1, center=true);
                    
                    rotate([0,90,0]) cap_cylinder(r=axle_rad*1.125, h=flip/2-1, center=true);
                    
                    hull(){
                        for(i=[0,1]) mirror([0,i,0]) translate([0,flip/2,0]) rotate([0,90,0]) cylinder(r=axle_rad, h=leg_rad*1.75, center=true);
                    }
                }
                                
                for(i=[0,1]) mirror([i,0,0]) translate([flip/4,0,0]) sphere(r=axle_rad);
            }
        }
        
        //cutout the flare
        translate([-flip/2+length/2-2,0,0]) hull(){
            for(i=[0,1]) mirror([i,0,0]) translate([flip/4,0,0]) cylinder(r=axle_rad/2, h=20, center=true);
            translate([-4,0,0]) for(i=[0,1]) mirror([i,0,0]) translate([flip/4+1.5,0,0]) cylinder(r=axle_rad/2-1, h=20, center=true);
        }
        
        //flatten the bottom
        translate([0,0,-100-axle_rad+1.25]) cube([200,200,200], center=true);
        
        //and half the top
        translate([131,0,100+axle_rad-1.25]) cube([200,200,200], center=true);
    }
}

module drip_spout(solid=1){
    bump_height = 10;
    pipe_rad = leg_rad;
    output_len = 57;
    
    drip_rad = drip_rad-drip_wall-.05;
    
    real_drip_len = drip_len + 19;
    
    translate([0,0,66.8]) rotate([0,180,0]) rotate([drip_angle,0,0])
    difference(){
        union(){
            mirror([0,0,1]) translate([0,-output_len,0]) rotate([leg_angle,0,0]) translate([0,0,-height/2-pipe_rad-bump_height/2]) rotate([90-leg_angle,0,0])
        rotate([drip_angle,0,0]) rotate([0,0,90]) translate([0,0,-.1]) rotate([0,0,180])
            {
                //cap on top
                translate([0,0,-wall]) cap_tube(solid=1, r=drip_rad+2, h=wall, center=false, outside=true, wall=drip_wall);
            
                //the tube
                cap_tube(solid=1, r=drip_rad, h=real_drip_len, center=false, outside=true, wall=drip_wall);
            }
        }
        
        //outlet hole
        mirror([0,0,1]) translate([0,-output_len,0]) rotate([leg_angle,0,0]) translate([0,0,-height/2-pipe_rad-bump_height/2]) rotate([90-leg_angle,0,0])
        rotate([drip_angle,0,0]) rotate([0,0,90]) translate([0,0,wall/2])
        {
            cap_tube(solid=-1, r=drip_rad+.5, h=real_drip_len+wall*2, center=false, outside=true, wall=drip_wall);
        }
        
        //cut a hole in the side
        hull(){
            mirror([0,0,1]) translate([0,-output_len,0]) rotate([leg_angle,0,0]) translate([0,0,-height/2-pipe_rad-bump_height/2]) rotate([90-leg_angle,0,0])
        rotate([drip_angle,0,0]) rotate([0,0,90]) translate([0,0,wall]) cap_tube(solid=0, r=drip_rad-1.3, h=drip_len-wall*3, center=false, outside=true, wall=inside_drip_wall);
            rotate([17,0,0]) translate([0,0,61]) sphere(r=leg_rad-2);
        }
        
        //oh fine, we'll lop off the tip.  Whatevs.
        translate([0,-65,70+drip_len/2-31]) rotate([23,0,0]) cube([30,50,50], center=true);
        
        //flatten one side for easy printing
        translate([0,-61-6.25,70+drip_len/2]) rotate([-drip_angle,0,0]) cube([30,100,50], center=true);
    }
}

module flip_axle(){
    cap = axle_rad/2+1;
    flip = 23;
    length = (rad+wall+leg_rad)*2+leg_rad*2+cap+flip;
    
    flip_offset = length/2-flip+9;
    flip_drop = -1;
    
    axle_slop = .25;
    flip_slop = .5;
    axle_r1 = .75;
    axle_r2 = 4;
    axle_len = 8;
    flip_angle = 45;
    
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
            translate([flip_offset,0,0]) rotate([0,flip_angle,0])
        cube([flip_slop,10,10], center=true);
            
            //leave the axis to rotate around
            translate([flip_offset,0,0]) rotate([0,-flip_angle,0]) translate([flip_drop,0,-flip_slop/2-.01]) cylinder(r1=axle_r1, r2=axle_r2, h=axle_len);
        }
        
        //carve out around the axle
        difference(){
            translate([flip_offset,0,0]) rotate([0,-flip_angle,0]) translate([flip_drop,0,-axle_slop/2-.01]) cylinder(r1=axle_r1+flip_slop, r2=axle_r2+flip_slop, h=axle_len+axle_slop);
            
            translate([flip_offset,0,0]) rotate([0,-flip_angle,0]) translate([flip_drop,0,-flip_slop/2-.01]) cylinder(r1=axle_r1, r2=axle_r2, h=axle_len);
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

module odoshi(wall = 2, height = extra_height+height){
    echo(wall);
    echo(height);
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
    
    upper_frame_lift = 13;
    
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
    
    //and this is the inlet - connects to 1/2OD, 3/8ID hose.
    rotate([leg_angle,0,0]) translate([inlet_offset,0,-height/2+leg_rad]) rotate([-leg_angle,0,0]) translate([0,-42,0]) rotate([inlet_angle,0,0]) translate([0,-inlet_length/2,0,0]) rotate([90,0,0]) rotate([0,0,-90]) translate([0,0,-inlet_length/2]) rotate([0,0,180]) cap_tube(r=inlet_rad, h=inlet_length, solid=solid, wall=inlet_wall);
    
    
    //lower frame
    for(i=[0,1]) mirror([i,0,0]) translate([width,0,0]){
        //X beams
        rotate([leg_angle,0,0]) rotate([0,0,-90]) translate([0,0,-height/4]) cap_tube(r=leg_rad, h=height/2-leg_rad*2, solid=solid, wall=wall);
        rotate([-leg_angle,0,0]) rotate([0,0,90]) translate([0,0,-height/4]) cap_tube(r=leg_rad, h=height/2-leg_rad*2, solid=solid, wall=wall);
        
        //this is to let water flow around the axle
        rotate([0,-90,0]) cap_tube(r=axle_rad+wall*3, h=leg_rad*2-wall/2+solid*wall, solid=solid, wall=wall);
    }
    
    //upper frame - meetup in the middle
    for(i=[0,1]) mirror([i,0,0]) rotate([17,0,0]) translate([width,0,0]){
        //lift the upper
        rotate([0,0,180]) translate([0,0,upper_frame_lift/2]) cap_tube(r=leg_rad, h=upper_frame_lift, solid=solid, wall=wall);
        
        //sphere joint for the lift
        translate([0,0,upper_frame_lift]) sphere(r=(leg_rad*2+solid*wall)/2);
        
        //angled beams to meet in the middle
        translate([0,0,upper_frame_lift]) rotate([0,-31,0]) rotate([0,0,180]) translate([0,0,63/2]) rotate([0,0,180]) cap_tube(r=leg_rad, h=63, solid=solid, wall=wall);
    }
    
    //this is the final outlet!
    if(solid == 1){
        hull(){
            mirror([0,0,1]) translate([0,-output_len,0]) rotate([leg_angle,0,0]) translate([0,0,-height/2-pipe_rad-bump_height/2]) rotate([90-leg_angle,0,0])
        rotate([drip_angle,0,0]) rotate([0,0,-90]) cap_tube(solid=solid, r=drip_rad, h=drip_len-wall, center=false, outside=true, wall=drip_wall);
            rotate([17,0,0]) translate([0,0,61]) sphere(r=(leg_rad*2+solid*wall)/2);
        }
    }else{
        //inside path
        hull(){
            mirror([0,0,1]) translate([0,-output_len,0]) rotate([leg_angle,0,0]) translate([0,0,-height/2-pipe_rad-bump_height/2]) rotate([90-leg_angle,0,0])
        rotate([drip_angle,0,0]) rotate([0,0,90]) translate([0,0,wall]) cap_tube(solid=solid, r=drip_rad, h=drip_len-wall*3, center=false, outside=true, wall=inside_drip_wall);
            rotate([17,0,0]) translate([0,0,61]) sphere(r=(leg_rad*2+solid*wall)/2);
        }
        //exit
        mirror([0,0,1]) translate([0,-output_len,0]) rotate([leg_angle,0,0]) translate([0,0,-height/2-pipe_rad-bump_height/2]) rotate([90-leg_angle,0,0])
        rotate([drip_angle,0,0]) rotate([0,0,90]) translate([0,0,wall]) rotate([0,0,180]) cap_tube(solid=solid, r=drip_rad, h=drip_len*2+wall*2, center=true, outside=true, wall=drip_wall);
        
        //cut the tip a bit
        translate([0,-61,70+drip_len/2-7]) rotate([13,0,0]) cube([30,50,50], center=true);
        
        //cut the top, for no reason.
        translate([0,0,height/2+9]) cylinder(r=50, h=10);
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
                    translate([0,0,-height/2+leg_rad/2-1.8]) gutter_inside(h=200);
                    translate([0,0,height/2]) gutter_inside(h=200);
                }
            }
            
            
            //axle
            for(i=[0,1]) mirror([i,0,0]) translate([rad+wall+leg_rad,0,0]) rotate([0,-90,0]) cap_tube(r=axle_rad+wall, h=leg_rad*2, solid=1, wall=wall);
        }
        
        difference(){
            frame(solid=-1);
            
            //axle
            rotate([0,-90,0]) cap_tube(r=axle_rad+wall, h=200, solid=1, wall=wall);
        }
        
        //axle
        rotate([0,-90,0]) cap_tube(r=axle_rad+wall, h=200, solid=-1, wall=wall);
        
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
