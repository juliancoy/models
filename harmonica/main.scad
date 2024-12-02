thickness = 2;

// Harmonica dimensions
harmonica_x = 50.2;
harmonica_y = 169.2;
harmonica_z = 11;
x_overhang = 0;
y_overhang = 3;
width = harmonica_y + y_overhang * 2;
$fn = 55;

x_stretch = 0.8;
z_stretch = 1.2;

// Bézier curve function and 3D extrusion
module bezier_curve_3d(p0, p1, p2, p3, steps=50) {
    for (i = [0 : steps - 1]) {
        t1 = i / steps;
        t2 = (i + 1) / steps;
        point1 = bezier_point(t1, p0, p1, p2, p3);
        point2 = bezier_point(t2, p0, p1, p2, p3);

        hull() {
            translate([point1.x, 0, point1.z])
                rotate([90, 0, 0])
                    scale([x_stretch, z_stretch, 1])
                        cylinder(d = thickness, h = width, center = true);
            translate([point2.x, 0, point2.z])
                rotate([90, 0, 0])
                    scale([x_stretch, z_stretch, 1])
                        cylinder(d = thickness, h = width, center = true);
        }
    }
}



function bezier_point(t, P0, P1, P2, P3) = 
    let (
        u = 1 - t,
        tt = t * t,
        uu = u * u,
        uuu = uu * u,
        ttt = tt * t
    )
    [
        uuu * P0[0] + 3 * uu * t * P1[0] + 3 * u * tt * P2[0] + ttt * P3[0],
        0,  // Y is constant as this is an XZ curve
        uuu * P0[1] + 3 * uu * t * P1[1] + 3 * u * tt * P2[1] + ttt * P3[1]
    ];

// Top holes
hole_r = 2.5;
spacing_y = 7;
outwardness_y = 45;
outwardness_x = 3.5;

module top_holes() {
    for (i = [0 : 1 : 3]) {
        translate([outwardness_x, outwardness_y + spacing_y * i, 0])
            cylinder(h = 20, r = hole_r);
    }
}

module all_top_holes() {
    top_holes();
    mirror([0, 1, 0])
        top_holes();
    mirror([1, 0, 0])
        top_holes();
    mirror([1, 0, 0])
    mirror([0, 1, 0])
        top_holes();
}

// Bézier curve control points
xcheat = -0.2;
zcheat = -0.2;
zheight = 7;
p0 = [-harmonica_x / 2 - xcheat, -zcheat];  // Start point
p1 = [-harmonica_x / 5, zheight]; // Control point 1
p2 = [harmonica_x / 5, zheight];  // Control point 2
p3 = [harmonica_x / 2 + xcheat, -zcheat];   // End point

// nail in the wood
nail_height=5.2;
x_offset = 3.5;
module nail(){
    translate([x_offset,0,nail_height/2])
    cylinder(d=3, h = nail_height, center=true);
}

module harmonica_body(){
    // Harmonica body
    mirror([0, 0, 1])
        translate([-harmonica_x / 2, -harmonica_y/ 2, 0])
            cube([harmonica_x, harmonica_y, harmonica_z], center = false);

}

// Draw the combined object
module cover(){
    difference() {
        // Bézier curve extrusion
        translate([0, 0, 0.5])
            bezier_curve_3d(p0, p1, p2, p3);

        // Top holes
        all_top_holes();
        
        harmonica_body();
        
        // nail holes
        nail();
        mirror([1,0,0])
        nail();
        
        // logo
        // Logo rendering
        translate([0, 0, zheight - 1.2])  // Adjust zheight to place the text properly
            rotate([0, 0, 90])          // Rotate text along Z-axis
                scale([1, 1, 2])        // Adjust scaling if necessary
                    linear_extrude(height = 2)  // Extrude the text to give it volume
                        text("ECHO", size = 20, font = "Futura Bold", valign = "center", halign = "center");

    }
}

translate([0,0,harmonica_z/2])
cover();



latchthickness = 5;
latchHeight = harmonica_z/2-latchthickness/2+1.16;
// Bézier curve function and 3D extrusion
module bezier_curve_3d_sphere(p0, p1, p2, p3, depthAdjust =0, steps=20) {
    for (i = [0 : steps - 1]) {
        t1 = i / steps;
        t2 = (i + 1) / steps;
        point1 = bezier_point(t1, p0, p1, p2, p3);
        point2 = bezier_point(t2, p0, p1, p2, p3);

        hull() {
            translate([point1.x, 0, point1.z+latchHeight])
                rotate([90, 0, 0])
                    scale([x_stretch, z_stretch, 1])
                        sphere(d = latchthickness);
            translate([point2.x, 0, point2.z+latchHeight])
                rotate([90, 0, 0])
                    scale([x_stretch, z_stretch, 1])
                        sphere(d = latchthickness);
            translate([point1.x, 0, -point1.z-latchHeight+depthAdjust])
                rotate([90, 0, 0])
                    scale([x_stretch, z_stretch, 1])
                        sphere(d = latchthickness);
            translate([point2.x, 0, -point2.z-latchHeight+depthAdjust])
                rotate([90, 0, 0])
                    scale([x_stretch, z_stretch, 1])
                        sphere(d = latchthickness);
        }
    }
}

module antilatch(){
    difference(){
        union(){
            translate([0,-(harmonica_y+y_overhang+latchthickness/2-1.8)/2,0])
                scale([1,0.71,1])
                    bezier_curve_3d_sphere(p0, p1, p2, p3, depthAdjust=0);
            
            /*translate([0,-(harmonica_y+y_overhang+latchthickness/2-3)/2,-4])
                   scale([10,6,10])
                    sphere(d=1);*/
        }    
        translate([0,0,harmonica_z/2])
            harmonica_body();
        
    }
}

module latch(){
    difference(){
            translate([0,(harmonica_y+y_overhang+latchthickness/2+1.8)/2,0])
        bezier_curve_3d_sphere(p0, p1, p2, p3);
    translate([0,0,harmonica_z/2])
        harmonica_body();
        
    }
}


module fractalLatch(){
difference(){
    latch();
    mirror([0,1,0])
    antilatch();
    
}
}

fractalLatch();
antilatch();
