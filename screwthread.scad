// Metric Screw Thread Library
// by Maximilian Karl <karlma@in.tum.de> (2014)
// Modified by Paul Chase <paenian@gmail.com> 2014
//  - added slop
//  - added taper
//  - added thread_height, which makes threads with height instead of rotations.
//
// only use module thread(pitch,dia,angle,rotations, slop, taper)
// with the parameters:
// pitch    - screw thread pitch
// dia    - screw thread major diameter
// angle - angle size in degree
//	rotations - number of thread rotations.  This * pitch gives the height.
// slop - adjustment in tooth size to allow for slop.
//      - Should be positive if printing male threads
//      - (bolts) and negative if printing female (nuts).
// taper - number of threads you want to taper with - 0 for none, 2 for a good gradual taper.

// examples
//thread_height(pitch,dia,angle,height, slop, taper)
thread_height(4, 25.4*3.5, 10, 10, .3, 5);

translate([0,15,0]) difference(){
	cylinder(r=8, h=10);
	translate([0,0,2.01]) thread_height(1, 10, 10, 8, -.3, 2);
}

*translate([15,15,0]) thread_height(1, 8, 10, 3, .1, 0);

*translate([15,0,0]) difference(){
	translate([0,0,.01]) cylinder(r=6, h=9, $fn=6);
	thread_height(1, 8, 10, 20, -.1, 0);
}

module screwthread_triangle(pitch) {
	difference() {
		translate([-sqrt(3)/3*pitch+sqrt(3)/2*pitch/8,0,0])
		rotate([90,0,0])
		translate([0,0,-.0001]) cylinder(r=sqrt(3)/3*pitch,h=0.0002,$fn=3,center=true);

		translate([0,-pitch/2,-pitch/2])
		cube([pitch,pitch,pitch]);
	}
}

module screwthread_onerotation(pitch,dia_maj,angle) {
//	H = sqrt(3)/2*pitch;	//not used
	dia_min = dia_maj - 5*sqrt(3)/8*pitch;

	for(i=[0:angle:360-angle])
	hull()
		for(j = [0,angle])
		rotate([0,0,(i+j)])
		translate([dia_maj/2,0,(i+j)/360*pitch])
		screwthread_triangle(pitch);

	translate([0,0,pitch/2-.01])
	cylinder(r=dia_min/2,h=pitch+.02,$fn=360/angle,center=true);
}

module screwthread_taper(pitch, dia_maj, angle, slop, taper, taper_step) {
	taper_start = (dia_maj/2-(taper_step-1)/taper);

	dia_min = dia_maj - 5*sqrt(3)/8*pitch;

	//threads
	for(i=[0:angle:360-angle])
	hull()
		for(j = [0,angle])
			if(slop > 0){
				rotate([0,0,(i+j)]) translate([dia_maj/2-(taper_step-1)/taper-(i/360)/taper,0,(i+j)/360*pitch])
				screwthread_triangle(pitch);
			}else{
				rotate([0,0,(i+j)]) translate([dia_maj/2+(taper_step-1)/taper+taper_step*(i/360)/taper,0,(i+j)/360*pitch])
				screwthread_triangle(pitch);
				cube([.1, .1, pitch]);
			}

	//core
	translate([0,0,pitch/2-.01])
	if(slop > 0){
		cylinder(r1=dia_min/2-(taper_step-1)*(pitch/4)/taper, r2=dia_min/2-taper_step*(pitch/4)/taper, h=pitch+.02, $fn=360/angle, center=true);
	}else{
		cylinder(r1=dia_min/2+(taper_step-1)*(pitch/4)/taper, r2=dia_min/2+taper_step*(pitch/4)/taper, h=pitch+.02, $fn=360/angle, center=true);
	}
}

module thread_height(pitch,dia,angle,height, slop, taper) {
	rotations = ceil(height/pitch);
	echo(rotations);
	difference(){
		thread(pitch,dia,angle,rotations, slop, taper);
		translate([0,0,height+dia]) cube([dia*2, dia*2, dia*2], center=true);
	}
}

module thread(pitch,dia,angle,rotations, slop, taper) {
    // added parameter "rotations"
    // as proposed by user bluecamel
	difference(){
		union(){
			for(i=[-1:rotations-taper])
				translate([0,0,i*pitch]) screwthread_onerotation(pitch,dia-slop,angle);
			for(i=[rotations-taper+1:rotations])
				translate([0,0,i*pitch]) screwthread_taper(pitch,dia-slop,angle, slop, taper, i-(rotations-taper));

			//this adds a ring so that the threads go all the way to the top.
			if(taper == 0)
				translate([0,0,(rotations+1)*pitch]) screwthread_onerotation(pitch,dia-slop,angle);
		}
		
		//flatten top and bottom
		translate([0,0,dia+pitch*(rotations+1)]) cube([dia*2, dia*2, dia*2], center=true);
		translate([0,0,-dia]) cube([dia*2, dia*2, dia*2], center=true);
	}
}