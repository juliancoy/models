include <../lib/Chamfers-for-OpenSCAD/Chamfer.scad>;
HEIGHT = 75;
OUTER_HULL_DIAMETER = 24;
OUTER_HULL_RADIUS   = OUTER_HULL_DIAMETER / 2.0;

e = .001;
BATT_DIAMETER = 18.0 + 1; // leave a little space
BATT_RADIUS   = BATT_DIAMETER/2;
BATT_LENGTH   = 65.0;
COMPRESSED_CLIP_HEIGHT    = 3.75; // compressed clip OUTER_HULL_DIAMETER
CAVITY_HEIGHT = BATT_LENGTH+COMPRESSED_CLIP_HEIGHT*2;
CAVITY_RADIUS = BATT_LENGTH+COMPRESSED_CLIP_HEIGHT*2;
END_SHELL_HEIGHT = 1.5;
PCB_THICKNESS = 1.6;
BATTERY_CLIP_STRAIT_WIDTH = 11;
BATTERY_CLIP_WIDTH  = 9;
ARCH_HEIGHT = 2;
INNER_SHELL_THICKNESS = 1;
INNER_SHELL_RADIUS = BATT_RADIUS+INNER_SHELL_THICKNESS;
// precision
$fn=100; 
INNER_HULL_GRADE = -8.5; // degrees
//OUTER_HULL_GRADE = -INNER_HULL_GRADE; // degrees i think
OUTER_HULL_GRADE = 0; // degrees
OUTER_CHAMFER = 2;
// strengthen the lower shell
END_CAP_HEIGHT = COMPRESSED_CLIP_HEIGHT + 0.5;
// outer flange
FLANGE_WIDTH = 2;
FLANGE_DEPTH = .8;
   
module BATTERY() 
    cylinder(h = CAVITY_HEIGHT, r = BATT_RADIUS, center = true);


module BATTERY_CLIP_HOLES(){
    cube(size = [BATTERY_CLIP_WIDTH,2,END_CAP_HEIGHT+e], center = true);
    
    translate([0,11,0])
    cube(size = [BATTERY_CLIP_WIDTH,BATTERY_CLIP_STRAIT_WIDTH,END_CAP_HEIGHT+e], center = true);
    
    translate([0,-11,0])
    cube(size = [BATTERY_CLIP_WIDTH,BATTERY_CLIP_STRAIT_WIDTH,END_CAP_HEIGHT+e], center = true);
}

module ARCH(){
    // create arch 
    translate([0,-10,-HEIGHT/2 + END_CAP_HEIGHT/2 + ARCH_HEIGHT])
    rotate([90,0,0])
    cylinder(h = 5, r = BATTERY_CLIP_WIDTH/2, center = true);
}

module END_CAP(){
    
    translate([0, 0, -HEIGHT/2 + END_CAP_HEIGHT/2-e])
    difference(){
        cylinder(h = END_CAP_HEIGHT, r = OUTER_HULL_RADIUS+e*2, center = true);
        // remove space for the clip
        translate([0,0,END_SHELL_HEIGHT])
        cube(size = [BATTERY_CLIP_WIDTH+1, OUTER_HULL_DIAMETER, END_CAP_HEIGHT], center = true);
    }
}

module END_CAP_INVERT(){
    /*scale(1 + e)
        mirror([0,0,1])
            END_CAP();*/
    mirror([0,0,1])
    translate([0, 0, -HEIGHT/2 + END_CAP_HEIGHT/2-e])
    cylinder(h = END_CAP_HEIGHT, r = OUTER_HULL_RADIUS+FLANGE_WIDTH*2+e, center = true);
}

// make a ball-in-hole snap
module ball(r){
    NUB_HEIGHT_OFFSET = 6;
    NUB_ANGLE_OFFSET = 15;
    rotate([0,0,NUB_ANGLE_OFFSET]) translate([INNER_SHELL_RADIUS,0,HEIGHT/2-NUB_HEIGHT_OFFSET])sphere(r = r);
    rotate([0,0,180-NUB_ANGLE_OFFSET]) translate([INNER_SHELL_RADIUS,0,HEIGHT/2-NUB_HEIGHT_OFFSET])sphere(r = r);
}

module OUTER_HULL_CHOP(){
    rotate([OUTER_HULL_GRADE,0,0])
        translate([0,OUTER_HULL_RADIUS, 0])
            cube(size = [OUTER_HULL_DIAMETER,OUTER_HULL_DIAMETER,HEIGHT+7], center = true);
}

// outer hull
module OUTER_HULL(){
    difference(){
        // main material
        cylinder(h=HEIGHT, r=OUTER_HULL_RADIUS,center = true);
        
        // cut at an angle
        OUTER_HULL_CHOP();
        
        // remove the center
        cylinder(h = HEIGHT+e, r = INNER_SHELL_RADIUS, center = true);
        
        
        rotate([180,0,0]) ball(1.0);
    }
}

module INNER_HULL_CHOP(){
    // take off the top half
    rotate([INNER_HULL_GRADE,0,0]){
        translate([0,INNER_SHELL_RADIUS, 0])
            cube(size = [INNER_SHELL_RADIUS*2+e,INNER_SHELL_RADIUS*2+e,HEIGHT+7], center = true);
    }
}

// inner hull
module INNER_HULL(){
    difference(){
        cylinder(h=HEIGHT, r=INNER_SHELL_RADIUS, center = true);
        INNER_HULL_CHOP();
        END_CAP_INVERT();
        BATTERY();  
    }
}

module FLANGE(){
    intersection(){
        difference(){
            translate([0, -(PCB_THICKNESS/2+FLANGE_DEPTH/2), 0])
                cube(size=[(OUTER_HULL_RADIUS + FLANGE_WIDTH)*2, FLANGE_DEPTH, HEIGHT], center=true);
            cylinder(h = HEIGHT, r = OUTER_HULL_RADIUS, center = true);
            
        }
    }
}

difference(){
    union(){
        ball(0.8);
        OUTER_HULL();
        INNER_HULL();
        FLANGE();
        END_CAP();
    }
    union(){
        
        // remove a space for the battery clip
        translate([0, 0, -HEIGHT/2 + END_CAP_HEIGHT/2-e])
        BATTERY_CLIP_HOLES();
        ARCH();
        END_CAP_INVERT();
    }
}

