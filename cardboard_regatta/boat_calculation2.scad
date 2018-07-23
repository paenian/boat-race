in = 25.4;

tube_rad = 105/2;
tube_len = 48*in;
tube_wall = 1/8*in;

wall = tube_wall;

projection(cut = true) endcap();

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