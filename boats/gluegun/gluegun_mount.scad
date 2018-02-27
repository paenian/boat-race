angle=51;

inner_rad = 23/2;
outer_rad = 35/2;

inner_len = 35;
outer_len = 40;
total_len = outer_len+inner_len;
lift = 13;

wall = 3;

top_slit = 10;

//glueHolster();

union(){
    for(i=[0:90:359]) rotate([0,0,i]) translate([17,0,0]) glueHolster();
    difference(){
        cylinder(r=41, h=wall*2);
        for(i=[45:90:359]) rotate([0,0,i]) translate([53,0,0]) cylinder(r=23, h=wall*5, center=true);
        
        translate([0,0,wall]) for(i=[0,1]) mirror([0,0,i]) translate([0,0,-1]) cylinder(r1=5, r2=11, h=11);
    }
}

module glueHolster(){
    
    difference(){
        union(){
            //gun
            hull(){
                translate([0,0,lift]) rotate([0,angle,0]){
                    translate([inner_rad-outer_rad, 0, 0]) cylinder(r=inner_rad+wall, h=inner_len);
                    translate([0,0,inner_len]) cylinder(r=outer_rad+wall, h=outer_len);
                }
                translate([40,0,inner_len/4]) cube([inner_len, inner_rad*2, inner_len/2], center=true);
            }
        }
        
        translate([0,0,lift]) rotate([0,angle,0]){
            translate([inner_rad-outer_rad,0,wall]) cylinder(r=inner_rad, h=total_len);
            translate([0,0,inner_len]) cylinder(r=outer_rad, h=total_len);
        }
        
        //heat channel
        translate([0,0,100+wall]) cube([200, inner_rad*2-wall*2, 200], center=true);
        
        //screw holes
        for(i=[25:15:60]) translate([i,0,wall]) screw_hole();
        
        //flatten base
        translate([0,0,-100]) cube([200,200,200], center=true);
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