in = 25.4;

tube_rad = 105/2;
tube_len = 48*in;
tube_wall = 1/8*in;

edge_tube_len = 48*in;

corner_tube_rad = in*6;

wall = tube_wall;

//Each tube displaces 20 pounds.

box_x = 12*in;
box_y = 16*in;
box_z = 12*in;

echo((4*12*in+tube_rad*4)/in);

boat_boxes_shift();
boat_boxes();

//my radius
%cylinder(r=in * (6*12+2)/2, h=.1, center=true);
%cube([56*in,56*in,.1], center=true);

module boat_boxes_6(sides = 6){
    rad = (24*in)/sin(180/sides)+corner_tube_rad*sqrt(2);
    rad = 51*in;
    box_rad = 47*in;
    //connecting tubes
    for(i=[-.5, .5 ,1.25,-1.1]) translate([0,0,tube_len/2*i]){
        for(j=[0:360/sides:359]) rotate([0,0,j]) {
            translate([rad*cos(180/sides),0,0]) rotate([90,0,0]) cylinder(r=tube_rad, h=edge_tube_len, center=true);
        }
    }
    echo(sides*4);
   
    //vertices
    for(j=[180/sides:360/sides:359]) rotate([0,0,j]) translate([box_rad,0,0]) {
        //vertex boxes
        for(k=[0:1]) mirror([0,0,k]) translate([0,0,tube_len/2]) cube([box_x, box_y, box_z], center=true);
        
        //walking tube
        translate([-corner_tube_rad*sqrt(2)+14,tube_rad,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        translate([-corner_tube_rad*sqrt(2)+14,-tube_rad,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //paddle tube
        //translate([tube_rad*2,0,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //paddle tube
        //translate([tube_rad*sqrt(2),tube_rad*sqrt(2),0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //translate([tube_rad*sqrt(2),-tube_rad*sqrt(2),0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //translate([tube_rad*sqrt(2)*2,0,0]) cylinder(r=tube_rad, h=tube_len, center=true);
    }
    echo(sides*2);
   
    //center walking tubes
    *for(j=[0:360/sides:359]) rotate([0,0,j]) translate([rad*cos(180/sides)+tube_rad*2,0,0]) {
        translate([0,tube_rad,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        translate([0,-tube_rad,0]) cylinder(r=tube_rad, h=tube_len, center=true);
    }
    echo(sides);
    echo((rad*cos(180/sides)+tube_rad*2)/in*2/12);
   
    
}

module boat_boxes_shift(sides = 4){
    rad = (24*in)/sin(180/sides)+corner_tube_rad*sqrt(2);
    
    rad = 40*in;
    //box_rad
    echo(rad/in*2/12);
    //connecting tubes
    for(i=[-.5, .5 ,1,-1]) translate([0,0,tube_len/2*i]){
        for(j=[0:360/sides:359]) rotate([0,0,j]) {
            #translate([rad*cos(180/sides),-tube_rad*3,0]) rotate([90,0,0]) cylinder(r=tube_rad, h=edge_tube_len, center=true);
        }
    }
    echo(sides*4);
   
    //vertices
    for(j=[0:360/sides:359]) rotate([0,0,j]) translate([rad*cos(180/4)+tube_rad*4,rad*cos(180/4)-tube_rad*3,0]) {
        //vertex boxes
        for(k=[0,1,-1]) translate([0,0,k*tube_len/2]) cube([box_x, box_y, box_z], center=true);
        
        //walking tube
        translate([-corner_tube_rad*sqrt(2)+14,tube_rad,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        translate([-corner_tube_rad*sqrt(2)+14,-tube_rad,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //paddle tube
        //translate([tube_rad*2,0,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //paddle tube
        translate([tube_rad*sqrt(2),tube_rad*sqrt(2),0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //translate([tube_rad*sqrt(2),-tube_rad*sqrt(2),0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //translate([tube_rad*sqrt(2)*2,0,0]) cylinder(r=tube_rad, h=tube_len, center=true);
    }
    echo(sides*5);
   
    //center walking tubes
    for(j=[0:360/sides:359]) rotate([0,0,j]) translate([rad*cos(180/sides)+tube_rad*2,0,0]) {
        translate([0,-tube_rad*2,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        translate([0,-tube_rad*4,0]) cylinder(r=tube_rad, h=tube_len, center=true);
    }
    echo(sides);
    echo((rad*cos(180/sides)+tube_rad*2)/in*2/12);
}

module boat_boxes(sides = 4){
    rad = (24*in)/sin(180/sides)+corner_tube_rad*sqrt(2);
    rad = 49*in;
    echo(rad/in*2/12);
    //connecting tubes
    for(i=[-.5, .5 ,1,-1]) translate([0,0,tube_len/2*i]){
        for(j=[0:360/sides:359]) rotate([0,0,j]) {
            translate([rad*cos(180/sides),0,0]) rotate([90,0,0]) cylinder(r=tube_rad, h=edge_tube_len, center=true);
        }
    }
    echo(sides*4);
   
    //vertices
    for(j=[180/sides:360/sides:359]) rotate([0,0,j]) translate([rad,0,0]) {
        //vertex boxes
        for(k=[0:1]) mirror([0,0,k]) translate([0,0,tube_len/2]) cube([box_x, box_y, box_z], center=true);
        
        //walking tube
        translate([-corner_tube_rad*sqrt(2)+14,tube_rad,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        translate([-corner_tube_rad*sqrt(2)+14,-tube_rad,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //paddle tube
        //translate([tube_rad*2,0,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //paddle tube
        translate([tube_rad*sqrt(2),tube_rad*sqrt(2),0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //translate([tube_rad*sqrt(2),-tube_rad*sqrt(2),0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //translate([tube_rad*sqrt(2)*2,0,0]) cylinder(r=tube_rad, h=tube_len, center=true);
    }
    echo(sides*5);
   
    //center walking tubes
    for(j=[0:360/sides:359]) rotate([0,0,j]) translate([rad*cos(180/sides)+tube_rad*2,0,0]) {
        translate([0,tube_rad,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        translate([0,-tube_rad,0]) cylinder(r=tube_rad, h=tube_len, center=true);
    }
    echo(sides);
    echo((rad*cos(180/sides)+tube_rad*2)/in*2/12);
}

module boat_sakrete(sides = 4){
    rad = (24*in)/sin(180/sides)+corner_tube_rad*sqrt(2);
    rad = 49*in;
    echo(rad/in*2/12);
    //connecting tubes
    for(i=[-.5, .5 ,1,-1]) translate([0,0,tube_len/2*i]){
        for(j=[0:360/sides:359]) rotate([0,0,j]) {
            translate([rad*cos(180/sides),0,0]) rotate([90,0,0]) cylinder(r=tube_rad, h=edge_tube_len, center=true);
        }
    }
    echo(sides*4);
   
    //vertices
    for(j=[180/sides:360/sides:359]) rotate([0,0,j]) translate([rad,0,0]) {
        //vertex tube
        cylinder(r=corner_tube_rad, h=tube_len, center=true);
        //walking tube
        translate([-corner_tube_rad*sqrt(2)+14,tube_rad,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        translate([-corner_tube_rad*sqrt(2)+14,-tube_rad,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //paddle tube
        //translate([tube_rad*2,0,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //paddle tube
        translate([tube_rad*sqrt(2),tube_rad*sqrt(2),0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //translate([tube_rad*sqrt(2),-tube_rad*sqrt(2),0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //translate([tube_rad*sqrt(2)*2,0,0]) cylinder(r=tube_rad, h=tube_len, center=true);
    }
    echo(sides*5);
   
    //center walking tubes
    for(j=[0:360/sides:359]) rotate([0,0,j]) translate([rad*cos(180/sides)+tube_rad*2,0,0]) {
        translate([0,tube_rad,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        translate([0,-tube_rad,0]) cylinder(r=tube_rad, h=tube_len, center=true);
    }
    echo(sides);
    echo((rad*cos(180/sides)+tube_rad*2)/in*2/12);
}

module boat(sides = 5){
    rad = (24*in)/sin(180/sides)+tube_rad*2;
    echo(rad/in*2/12);
    //connecting tubes
    for(i=[-.5, .5 ,1,-1]) translate([0,0,tube_len/2*i]){
        for(j=[0:360/sides:359]) rotate([0,0,j]) {
            translate([rad*cos(180/sides),0,0]) rotate([90,0,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        }
    }
    echo(sides*4);
   
    //vertices
    for(j=[180/sides:360/sides:359]) rotate([0,0,j]) translate([rad,0,0]) {
        //vertex tube
        cylinder(r=tube_rad, h=tube_len, center=true);
        //walking tube
        translate([-tube_rad*sqrt(2)*2,0,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //paddle tube
        //translate([tube_rad*2,0,0]) cylinder(r=tube_rad, h=tube_len, center=true);
        //paddle tube
        translate([tube_rad*sqrt(2),tube_rad*sqrt(2),0]) cylinder(r=tube_rad, h=tube_len, center=true);
        translate([tube_rad*sqrt(2),-tube_rad*sqrt(2),0]) cylinder(r=tube_rad, h=tube_len, center=true);
        translate([tube_rad*sqrt(2)*2,0,0]) cylinder(r=tube_rad, h=tube_len, center=true);
    }
    echo(sides*5);
   
    //center walking tubes
    for(j=[0:360/sides:359]) rotate([0,0,j]) translate([rad*cos(180/sides)+tube_rad*2,0,0]) {
        cylinder(r=tube_rad, h=tube_len, center=true);
    }
    echo(sides);
    echo((rad*cos(180/sides)+tube_rad*2)/in*2/12);
}

//projection(cut = true) endcap();

module endcap(border = in, num_cutouts = 15){
    difference(){
        cylinder(r=tube_rad+border, h=wall);
       
        //triangle cutouts for bending
        for(i=[0:360/num_cutouts:359]) rotate([0,0,i]) {
            translate([tube_rad+wall/2,0,0]) hull(){
                cylinder(r=.1, h=wall*3, center=true);
               
                for(j=[-180/num_cutouts,180/num_cutouts]) rotate([0,0,j])
                   translate([tube_rad,0,0])
                     cylinder(r=.1, h=wall*3, center=true);
            }
        }
    }
}
