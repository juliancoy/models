$fn=120;

size_z = 85;
r_bottom = 5;
r_top = 8;
shell_width = 1;
friction_overlap = 6;
breakpoint_offset = 4;
cap_height = 4;
friction_tolerance = 0.02;
sphere_z_scale = 0.5;

module body(){
    cylinder(h = size_z-friction_overlap-breakpoint_offset, r1=r_bottom, r2=r_top);
    translate([0,0,size_z-friction_overlap-breakpoint_offset])
    cylinder(h = friction_overlap+breakpoint_offset, r=r_top);
    scale([1,1,sphere_z_scale])
    sphere(r=r_bottom);
}

translate([0,0,r_bottom*sphere_z_scale])
difference(){
    body();
    translate([0,0,size_z])
    // friction overlap
    cylinder(r = r_top-shell_width, h=friction_overlap*2, center=true);
    
    // main hollow body
    cylinder(h = size_z-friction_overlap+0.005 , r1=r_bottom-shell_width, r2=r_top-shell_width*2);

    scale([1,1,sphere_z_scale])
    sphere(r=r_bottom-shell_width);
}

knurl_depth = 1;
module knurling(cap_height, num_knurls, knurl_height) {
    for (i = [0:num_knurls-1]) {
        angle = i * 360 / num_knurls;
        translate([
            (r_top - knurl_depth) * cos(angle), 
            (r_top - knurl_depth) * sin(angle), 
            cap_height / 2
        ])
        rotate([0, 0, angle])
        cylinder(r=knurl_depth, h=knurl_height, center=true);
    }
}

ring_height = 0.8;
module cap(){
    translate([0,0,cap_height/2])
    cylinder(r = r_top-knurl_depth, h=cap_height, center=true);
    translate([0,0,ring_height/2])
    cylinder(r = r_top, h=ring_height, center=true);
    translate([0,0,cap_height/2])
    cylinder(r = r_top-knurl_depth, h=cap_height, center=true);
    translate([0,0,cap_height+friction_overlap/2-0.2])
    cylinder(r = r_top-shell_width-friction_tolerance, h=friction_overlap, center=true);
    // Knurling
    knurling(cap_height, num_knurls=30, knurl_height=cap_height);
}

translate([0,15,0])
difference(){
    cap();
    translate([0,0,shell_width*2])
    cylinder(r = r_top-shell_width*2, h=friction_overlap+0.001+cap_height);
}