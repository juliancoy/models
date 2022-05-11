e = 0.001;
shell_width = 3;
bottom_shell_width = 1;
edge = 50;
mirror_height = 1.5;
rev_mirror_height = 1.5;
led_height = 10;
total_height = led_height + bottom_shell_width + mirror_height/2 + rev_mirror_height;
bore = 2;

module triangle_shell(r, h, bottom_shell){
    difference(){
        cylinder(r=r, h=h, $fn=3);
        translate([0,0,bottom_shell])
        cylinder(r=r-shell_width*2, h=h, $fn=3);
    }
}

module screw_holes(sbore, h, f=30){
    // screw holes
    for(i = [0,120,240]){
        trans = (edge*sqrt(3))/3;
        adjustment = 1.62;
        rotate([0,0,i])
        translate([trans*adjustment, 0,-e])
        cylinder(d=sbore, h=h*3, $fn=f, center=true);
        }
    
}

// LED body
module led_body(){
    difference(){
        triangle_shell(edge, total_height, bottom_shell_width);
        screw_holes(bore, total_height);
    }
}

difference(){
    led_body();
    translate([0,0,total_height - mirror_height/2 + e])
    cylinder(r=edge-3, h=mirror_height/2, $fn=3);
}

snap_width = 4;
// Mirror snaps
module mirror_snap(snap_overhang = 0.8){
    
    intersection(){
        union(){
            translate([-edge/2+shell_width,snap_width/2,snap_overhang])
            rotate([90,30,0])
            cylinder(r=snap_overhang*2, h=snap_width, $fn=3);
        }
        
        translate([-edge/2+shell_width,0,0])
        rotate([0,20,0])
        cube([9,snap_width,2], center=true);
        
        
    }
}

translate([0,0,mirror_height + bottom_shell_width])
for(i = [0,120,240]){
    rotate([0,0,i])
    minkowski() {
        mirror_snap();
        sphere(.3);
    }
}

// lid
lidheight = 1.6;
rotate([0,0,180])
translate([-25,46,0])
difference(){
    triangle_shell(r=edge, h=mirror_height/2+lidheight, bottom_shell = lidheight);
    screw_holes(bore, total_height);
    screw_holes(bore*2, 0.4);
    translate([0,0,-e]){
        cylinder(r=edge-9, h=total_height, $fn=3);  
    }
}


// back lid
bottomshell = 3;
backlidheight = 8;
rotate([0,0,180])
translate([-25,-46,0])
difference(){
    triangle_shell(r=edge, h=mirror_height/2+backlidheight, bottom_shell = bottomshell);
    screw_holes(bore, total_height);
    screw_holes(bore*2, 1.2, 6);
    // usb hole
    usb_h = 4;
    translate([-edge/2+shell_width,edge-35,usb_h/2+bottomshell])
    cube([20,20,usb_h], center=true);
    
}


