include <../configuration.scad>
use <../gutter.scad>

skiff();

%translate([0,0,-gutter_wall]) gutter_inside();

//mold for a flat-bottom skiff boat.
module skiff(length = 5*in){
    difference(){
        union(){
            hull(){
                sphere(r=5);
            }
        }
        
        //flatten the bottom
        translate([0,0,-100]) cube([200,200,200], center=true);
    }
}