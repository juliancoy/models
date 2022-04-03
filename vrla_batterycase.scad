$fn = 10; 
include <util.scad>;

difference(){
    halfbatt([228, 136, 208, 132, 211]);
    rotate([0,0,180]){
        halfbatt([228, 136, 208, 132, 211]);
    }
}
