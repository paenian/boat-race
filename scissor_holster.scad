scissor_x = 11.29;
scissor_y = 23;
scissor_taper = 7;
scissor_z = 79;

scissor_a = 37;

wall = 3;
difference(){
    four_pair();
    translate([0,0,-200+2]) cube([400,400,400], center=true);
}


module four_pair(){
    
    for(i=[0:4]) translate([i*(scissor_x*2+wall),0,0]) scissor_pair();
}

module scissor_pair(){
    difference(){
        union(){
            for(i=[0,180]) rotate([0,0,i]) translate([1,23,0]) rotate([scissor_a,0,0]) scissor_holster();
        }
    }
}

module scissor_holster(min_rad = wall){
    difference(){
        minkowski(){
            scissor_hole();
            sphere(r=min_rad, $fn=8);
        }
        
        translate([0,0,min_rad+.1]) scissor_hole();
    }
}

module scissor_hole(){
    hull(){
        cube([scissor_x,scissor_taper,.1]);
        translate([0,0,scissor_z]) cube([scissor_x,scissor_y,.1]);
    }
}