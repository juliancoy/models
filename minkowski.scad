module rounded_square(d,r,h=30) {
    minkowski() {
        translate([r,r]) cube([d[0]-2*r, d[1]-2*r, h]);
        sphere(r);
    }
}
rounded_square([20,30], 5);