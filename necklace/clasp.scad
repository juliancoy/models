include <link.scad>
include <torus.scad>
clasp_body_length = body_length;
sphere_count = 40;

outer_rad = 2;
inner_rad = 1.4;
inner_rad_recep = 1.55;
cube_height = 4;

module totalPositive(){
    rotate([0,90,0])
    cylinder(h=body_length-5.5, r=body_radius);

    linkingPart();
    translate([clasp_body_length,0,0]){
        rotate([90,0,180])
        linkingPart();
        translate([-4.5,0,-body_radius+outer_rad+inner_rad]){
        rotate([0,90,0]){
            torus(or=outer_rad, ir=inner_rad);
        }   
    }
        translate([-3,0, body_radius-cube_height/2])
        cube([4.5,1.4,cube_height], center=true);
    }        
}



module total(){
    difference(){
        totalPositive();
        linkNegative();
        translate([clasp_body_length,0,0])
        rotate([90,0,180])
        linkNegative();
        
        translate([7,0,-body_radius+outer_rad+inner_rad_recep])
        rotate([0,90,0])
        torus(or=outer_rad, ir=inner_rad_recep);
        
        
        translate([4.5,0,-body_radius+outer_rad+inner_rad])
        rotate([0,90,0]){
            cylinder(h=3,r1=3,r2=3);
        }
        
        
        translate([6,0, body_radius-cube_height/2])
        cube([3,1.6,cube_height], center=true);

    }
}


total();
