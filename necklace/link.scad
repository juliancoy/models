$fn=70;
include <torus.scad>

body_length = 13;
body_width = 10;
body_radius = 5;
lateralFreedom = 2.5;
neg_dist = 5;
flatcut = 0;
taperlen=3;

module body(){
    rotate([0,90,0])
    cylinder(h=body_length, r=body_radius);
}

module linkNegative(){
    
    // recepticle ring      
    translate([-body_radius+0.8,0,0])
    scale([0.2,0.2,0.2])
    //sphere_path(num_spheres=25, r = 20, sphere_radius = 14);
    torus(or = 20, ir = 15);
}

module linkingPart(){
    translate([0, 0,0, ])
    sphere(r=body_radius);
}


module totalPos(){
    body();
    linkingPart();
    translate([body_length,0,0])
    rotate([90,0,180])
    linkingPart();
}

module total(){
    difference(){
        totalPos();
        linkNegative();
        translate([body_length,0,0])
        rotate([90,0,180])
        linkNegative();
    }
}


total();
