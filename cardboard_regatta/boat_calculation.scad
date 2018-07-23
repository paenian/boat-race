
thick = 12;
rad = 36;
wall = 12;

echo(acos((rad-wall)/rad)/180/3.14159);


echo((thick * (rad*rad * (3.14159/180) * acos((rad-wall)/rad)-(rad-wall)*sqrt(2*wall*rad-wall*wall))) / (12*12*12) );


num_boxes = 8;
rad = 7*12;
box_x = 12;
box_y = 12;
box_z = 12;
tube_rad = 2.5;

//stride is half of the radius with 6 boxes.
echo(rad);
echo(rad * sin(180/num_boxes));

for(i=[0:360/num_boxes:179]) rotate([0,0,i]) {
    translate([0,0,i/(360/num_boxes) * tube_rad*2]){
        //boxes
        for(j=[0,1]) for(k=[0,1]) mirror([j,0,0]) mirror([0,0,k]) translate([rad,0,rad/2]) rotate([0,0,45]) cube([box_x, box_y, box_z], center=true);
            
        //end tube
        for(k=[0,1]) mirror([0,0,k]) translate([0,0,rad/2]) rotate([0,90,0]) cylinder(r=tube_rad, h=rad*2, center=true);
        
        //connecting tubes
        for(j=[0,1]) for(k=[0,1]) mirror([j,0,0]) mirror([0,k,0]) translate([rad-box_x/2-tube_rad/2,tube_rad*2,0]) cylinder(r=tube_rad, h=rad, center=true);
    }
    
}