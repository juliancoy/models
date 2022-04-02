$fn = 10; 
include <util.scad>;

module pos_hemi(size = 300){
    translate([-size/2,00,-size/2])
        cube([size,size,size]);
}
module pn_hemi(size = 300){
    translate([00,-size/2,-size/2])
        cube([size,size,size]);
}

module halfbatt(dims){
    difference(){
        reenforced_case(dims);
        tapered_cube(dims);
        pn_hemi();
    }
} 

module half(){
    halfbatt([228, 136, 208, 132, 211]);
}
    
difference(){
    halfbatt([228, 136, 208, 132, 211]);
    rotate([0,0,180]){
        halfbatt([228, 136, 208, 132, 211]);
    }
}
