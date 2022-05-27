e = 0.001;
shell_width = 2;
bottom_shell_width = 1;
triangle_a = 97; // outer side length
mirror_height = 1.5;
rev_mirror_height = 1.5;
led_height = 12;
total_height = led_height + bottom_shell_width + mirror_height/2 + rev_mirror_height;
bore = 2;
tri_gap = 6;
triangle_r = triangle_a / sqrt(3);// perimiter
triangle_P = 3*triangle_a;// perimiter
triangle_s = 3*triangle_a / 2;// semiperimeter 
triangle_K = (1/4) * sqrt(3) * triangle_a * 2;
triangle_h = (1/2) * sqrt(3) * triangle_a;

module inner_box(dims, shell_w, shell_h){
    translate([shell_w, shell_w, shell_h +e])
    cube(dims);
}

module hollow_box(dims, shell_w, shell_h){
    difference(){
        cube([dims[0] + shell_w*2, dims[1] + shell_w*2, dims[2] + shell_h]);
        inner_box(dims, shell_w, shell_h);
    }
    
}

module triangle_shell(r, h, bottom_shell, side_shell){
    difference(){
        cylinder(r=r, h=h, $fn=3);
        translate([0,0,bottom_shell])
        cylinder(r=r-side_shell*2, h=h, $fn=3);
    }
}

module screw_holes(sbore, h, f=30){
    // screw holes
    for(i = [0,120,240]){
        rotate([0,0,i])
        translate([triangle_r-4, 0,-e])
        cylinder(d=sbore, h=h*3, $fn=f, center=true);
        }
    
}

snap_width = 4;
// Mirror snaps
module mirror_snap(snap_overhang = 0.2){
    
    intersection(){
        union(){
            translate([-triangle_r/2+shell_width,snap_width/2,snap_overhang])
            rotate([90,30,0])
            cylinder(r=snap_overhang*2, h=snap_width, $fn=3);
        }
        
        translate([-triangle_r/2+shell_width,0,0])
        rotate([0,20,0])
        cube([9,snap_width,2], center=true);
        
        
    }
}

twoway_adj = 2;
// LED body
module led_body(){
    difference(){
        union(){
            triangle_shell(triangle_r, total_height, bottom_shell_width, side_shell = shell_width);
            // mirror snaps
            translate([0,0,mirror_height + bottom_shell_width])
            for(i = [0,120,240]){
                rotate([0,0,i])
                minkowski() {
                    mirror_snap();
                    sphere(.3);
                }
            }
            cyl_d = 6;
            cyl_h = 5;
            // necklace mount
            translate([0,0,led_height/2])
            for(i = [0,240]){
                rotate([120,270,i+30])
                translate([0,-29,0])
                difference(){
                    cylinder(d=cyl_d, h=cyl_h, center=true, $fn=30);
                    cylinder(d=cyl_d-3, h=cyl_h+1, center=true, $fn=30);
                }
            }
        }
        screw_holes(bore, total_height*2);
        // lip
        translate([0,0,total_height - mirror_height/2 + e])
        cylinder(r=triangle_r-twoway_adj, h=mirror_height/2, $fn=3);
    }
}

led_body();
// lid
lidheight = 1.6;
module lid(){
    difference(){
        triangle_shell(r=triangle_r, h=mirror_height/2+lidheight, bottom_shell = 2, side_shell = twoway_adj/2);
        screw_holes(bore, total_height);
        screw_holes(bore*2, 0.4);
        translate([0,0,-e]){
            cylinder(r=triangle_r-6, h=total_height, $fn=3);  
        }
    }
}

rotate([0,0,180])
translate([-triangle_r/2 ,triangle_a/2 + tri_gap,0])
lid();

sw = 1.2;
component_height = 6;
wiregap =2;
battery_dims = [42, 30, component_height-wiregap];
battery_offset = [-28, -10, 0];
module battery_box(){
    hollow_box(battery_dims, shell_w = sw, shell_h = bottomshell);
}


charger_dims = [30, 18, component_height-wiregap];
charger_offset =[-28, -29, 0];
module charger_box(){
    hollow_box(charger_dims, shell_w = sw, shell_h = bottomshell);
}

mcu_dims = [22, 19, component_height-wiregap];
mcu_offset =[43.8, -7 , 0];
module mcu_box(){
        hollow_box(mcu_dims, shell_w = 0.8, shell_h = bottomshell);
}

module mcu_usb_hole(){
    // usb hole
    translate([-mcu_dims[0]/3,mcu_dims[1] - 13,bottomshell])
    cube([mcu_dims[0],mcu_dims[1]-10,10]);
}
// components lid
bottomshell = 2;
module components_lid(){
difference(){
    union(){
        triangle_shell(r=triangle_r, h=bottomshell+component_height,  bottom_shell = bottomshell, side_shell = shell_width);
        translate(battery_offset)
        battery_box();
        translate(charger_offset)
        charger_box();
        translate(mcu_offset)
        rotate([0,0,120])
        mcu_box();
    }
    translate(battery_offset)
    inner_box(battery_dims + [0,0,wiregap], sw, bottomshell);
    translate(charger_offset)
    inner_box(charger_dims + [0,0,wiregap], sw, bottomshell);
    translate(mcu_offset)
    rotate([0,0,120]){
    inner_box(mcu_dims + [0,0,wiregap], 0.8, bottomshell);
        mcu_usb_hole();
    }
    screw_holes(bore, 100);
    screw_holes(bore*4, 2, 6);
    // switch hole
    rotate([0,0,120]){
    translate([-triangle_r/2+shell_width,triangle_r-60,component_height/2 + bottomshell+e]){
        cube([7,11,component_height], center=true);
        translate([0,7.5,0])
        rotate([0,90,0])
        cylinder(r=1.2, h = 15, $fn=50, center = true);
        translate([0,-7.5,0])
        rotate([0,90,0])
        cylinder(r=1.2, h = 15, $fn=50, center = true);
        }
    }
}
}

rotate([0,0,180])
translate([-triangle_r/2 ,-triangle_a/2 - tri_gap,0])
components_lid();
