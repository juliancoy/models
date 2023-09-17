
module torus(or = 2, ir = 1){
    rotate_extrude(convexity = 10, $fn = 100)
    translate([or, 0, 0])
    circle(r = ir, $fn = 100);

}
