include <link.scad>
include <torus.scad>

module magnetCut(r=3.2, h=2.2){

    rotate([0,90,0])
    cylinder(h=h, r=r, center=true);
    translate([0,0,body_radius/2])
    rotate([0,90,0])
    cylinder(h=h, r=r, center=true);
    translate([0,0,body_radius])
    rotate([0,90,0])
    cylinder(h=h, r=r, center=true);
}

difference(){
    link();
    rotate([0,90,0])
    cylinder(h=0.25, r=body_radius + 1, center=true);
    translate([2,0,0])
    magnetCut();
    translate([-2,0,0])
    magnetCut();
    
}