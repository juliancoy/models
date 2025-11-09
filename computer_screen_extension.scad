$fn = 120;
id_lower = 35;
od_upper = 36;
shell_width = 2.4;
e = 0.01;
overlap_height = 40;
transition_height = 5;
extension_height = 100;

// overlap
difference(){
    cylinder(h = overlap_height, r = id_lower/2 + shell_width);
    translate([0,0,-e/2])
    cylinder(h = overlap_height + e, r = id_lower/2);
}

// transition
translate([0,0,overlap_height]){
    difference(){
        cylinder(h = transition_height, r1 = id_lower/2 + shell_width, r2 = od_upper/2);
        translate([0,0,-e/2]){
            cylinder(h = transition_height + e, r = od_upper/2 - shell_width);
            cylinder(h = transition_height, r1 = id_lower/2, r2 = od_upper/2 - shell_width);
        }
    }
}


// extension
translate([0,0,overlap_height+transition_height]){
    difference(){
        cylinder(h = extension_height, r = od_upper/2);
        translate([0,0,-e/2])
        cylinder(h = extension_height + e, r = od_upper/2 - shell_width);
    }
}
