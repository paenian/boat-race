include <../configuration.scad>
use <../track/gutter.scad>

part = 21;
wall=3;

scale_mold = 1.05;
scale_wall = 1.25;

if(part == 1)
    canoe();

if(part == 11){
    canoe_mold();
    %translate([0,0,3]) canoe();
}

if(part == 2)
    catamaran();

if(part == 21){
    catamaran_mold();
    %translate([0,0,3]) catamaran();
}



%translate([0,0,-gutter_wall]) gutter_inside();



module canoe_hull(){
    hull(){
        for(i=[0,1]) mirror([0,i,0]) translate([0,length/2,0]) {
            //prow
            translate([0,-prow_rad/2,prow_rad]) scale([.25,1,1]) sphere(r=prow_rad*1.25, $fn=18);
                
            for(j=[0,1]) mirror([j,0,0]) translate([width/2,-prow_rad-rad,rad]) {
                sphere(r=rad, $fn=6);
                translate([rad,-rad*2,prow_rad-rad]) sphere(r=rad, $fn=6);
            }
        }
    }
}

//canoe mold
module canoe_mold(){

    difference(){
        intersection(){
            cube([in*2, in*6, in*1], center=true);
            translate([0,0,-in/4]) scale([scale_wall,scale_wall,scale_wall]) hull() canoe();
        }
        
        scale([scale_mold,scale_mold,scale_mold]) canoe(solid=true);
        translate([0,0,-100-in/6]) cube([200,200,200], center=true);
    }
}

//flat-bottom canoe
module canoe(length = in*4, width=in, solid=false){
    
    rad = 6;
    prow_rad = width;
    
    difference(){
        canoe_hull(rad = rad, prow_rad = width, length=length, width=width);
        
        if(solid == false) difference(){
            translate([0,0,wall]) canoe_hull(rad = rad, prow_rad = width-wall, length=length, width=width-wall*2);
            translate([0,0,-100+wall]) cube([200,200,200], center=true);
        }
        
        hull(){
            for(i=[0,1]) mirror([0,i,0]) translate([0,length/2-prow_rad/2,prow_rad*2]) {
                rotate([0,90,0]) cylinder(r=prow_rad, h=width*2, center=true);
            }
        }
        
        //cut the bottom flat
        translate([0,0,-100]) cube([200,200,200], center=true);
        
        //flatten the top, so it's not poky
        translate([0,0,100+prow_rad*1.666]) cube([200,200,200], center=true);
    }
}

module catamaran_mold(){
    scale_wall = scale_wall*.875;
    mold_min = 1;
    difference(){
        intersection(){
            hull() scale([scale_wall, scale_wall, scale_wall]) catamaran();
            cube([in*3.75, in*6, in*.75], center=true);
        }
        
        translate([0,0,wall+mold_min]) minkowski(){
            catamaran(solid = true);
            sphere(r=mold_min);
        }
        //for(i=[0,1]) mirror([i,0,0]) translate([23,0,wall]) scale([scale_mold, scale_mold, scale_mold]) hull() canoe();
    }
}

//two canoes :-0
module catamaran(solid = false){
    difference(){
        intersection(){
            union(){
                //two canoes
                for(i=[0,1]) mirror([i,0,0]) translate([23,0,0]) canoe(solid = solid);
                    
                //bridge - ribbed so we can use it as a foil mold :-)
                for(i=[-5:1:5]) translate([0,i*3,in*.25]) rotate([0,90,0]) cylinder(r=3, h=13, center=true, $fn=6);
            }
            
            translate([0,0,-gutter_wall]) scale([.98, .98, .98]) gutter_inside();
        }
    }
}