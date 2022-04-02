$fn = 10; 
include <util.scad>;

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
