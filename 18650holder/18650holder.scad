HEIGHT = 75;
WIDTH = 24;

e = .001;
BATT_DIAMETER = 18.0 + 1; // leave a little space
BATT_RADIUS   = BATT_DIAMETER/2;
BATT_LENGTH   = 65.0;
CLIP_WIDTH    = 4; // compressed clip width
CAVITY_HEIGHT = BATT_LENGTH+CLIP_WIDTH*2;
CAVITY_RADIUS = BATT_LENGTH+CLIP_WIDTH*2;
END_SHELL_HEIGHT = (HEIGHT-(BATT_LENGTH+CLIP_WIDTH*2))/2;
COUNTERSINK_HEIGHT = 1.7;
PCB_WIDTH = 1.6;
NUBLEN = 2;
BATTERY_CLIP_OFFSET = 10;
BATTERY_CLIP_WIDTH  = 9;
BATTERY_CLIP_HEIGHT = 8;
SHELL_WIDTH = (WIDTH-BATT_DIAMETER)/2/2 + e;
echo(SHELL_WIDTH);
INNER_SHELL_RADIUS = BATT_RADIUS+SHELL_WIDTH;
// precision
$fn=200; 
   
module BATTERY() 
    cylinder(h = CAVITY_HEIGHT, r1 = BATT_RADIUS, r2 = BATT_RADIUS, center = true);

module INNER_CYLINDER(){
    cylinder(h = HEIGHT, r1 = INNER_SHELL_RADIUS, r2 = INNER_SHELL_RADIUS, center = true);
}

module BASIC_INNER_HULL() difference(){
    // main material
    INNER_CYLINDER();
    // battery size
    BATTERY();  
}

INNER_HULL_GRADE = -4.5; // degrees i think
module INNER_HULL_CHOP(){
    // take off the top half
    rotate([INNER_HULL_GRADE,0,0]){
        translate([0,INNER_SHELL_RADIUS, 0])
            cube(size = [INNER_SHELL_RADIUS*2+e,INNER_SHELL_RADIUS*2+e,CAVITY_HEIGHT+.3], center = true);
    }
}
module INNER_HULL_CHOP_WIDE(){
    // take off the top half
    rotate([INNER_HULL_GRADE,0,0]){
        translate([0,INNER_SHELL_RADIUS, 0])
            cube(size = [WIDTH-SHELL_WIDTH,INNER_SHELL_RADIUS*2+e,CAVITY_HEIGHT+.3], center = true);
    }
}

OUTER_HULL_GRADE = -INNER_HULL_GRADE; // degrees i think
module OUTER_HULL_CHOP(){
    rotate([OUTER_HULL_GRADE,0,0])
        translate([0,WIDTH/2, 0])
            cube(size = [WIDTH,WIDTH,CAVITY_HEIGHT+.3], center = true);
}
module OUTER_HULL_CHOP_LARGE(){
    rotate([OUTER_HULL_GRADE,0,0]){
        translate([0,WIDTH/2, 0])
            cube(size = [WIDTH+6,WIDTH,CAVITY_HEIGHT+16], center = true);
    }
}

module BATTERY_CLIP_HOLE()
    translate([0,0,-HEIGHT/2])
        cube(size = [BATTERY_CLIP_WIDTH,NUBLEN,BATTERY_CLIP_HEIGHT], center = true);

module BATTERY_CLIP_HOLE_LARGE()
    translate([0,0,-HEIGHT/2])
        cube(size = [BATTERY_CLIP_WIDTH,10,BATTERY_CLIP_HEIGHT], center = true);

module BATTERY_CLIP_HOLES(){
    // remove a space for the battery clip
    BATTERY_CLIP_HOLE();
    translate([0,BATTERY_CLIP_OFFSET,0])
        BATTERY_CLIP_HOLE_LARGE();
    intersection(){
        translate([0,-BATTERY_CLIP_OFFSET,0])
            BATTERY_CLIP_HOLE_LARGE();
    }
    // create arch 
    translate([0,-10,-HEIGHT/2 + BATTERY_CLIP_HEIGHT/2])
    rotate([90,0,0])
    cylinder(h = 5, r1 = BATTERY_CLIP_WIDTH/2, r2 = BATTERY_CLIP_WIDTH/2, center = true);
}

// outer hull
difference(){
    cylinder(h = HEIGHT, r1 = WIDTH/2, r2 = WIDTH/2, center = true);
    
    // remove the top side
    OUTER_HULL_CHOP();
    
    // remove the center
    cylinder(h = CAVITY_HEIGHT, r1 = WIDTH/2-SHELL_WIDTH, r2 = WIDTH/2-SHELL_WIDTH, center = true);
    
    // polish off the end cap
    translate([0, WIDTH/2+4, 0])
        cube(size = [WIDTH, WIDTH, CAVITY_HEIGHT], center = true);
    
    // remove one end cap
    translate([0,0,HEIGHT/2-END_SHELL_HEIGHT/2])
        cube(size = [WIDTH,WIDTH,END_SHELL_HEIGHT+e], center = true);
    
    BATTERY_CLIP_HOLES();
}

// inner hull
difference(){
    BASIC_INNER_HULL();
    INNER_HULL_CHOP();
    
    // remove one end cap
    translate([0,0,HEIGHT/2-END_SHELL_HEIGHT/2])
        cube(size = [WIDTH,WIDTH,END_SHELL_HEIGHT+e], center = true);
        
    // polish off the end cap
    translate([0, WIDTH/2-tan(INNER_HULL_GRADE)*HEIGHT/2-0.2, 0])
        cube(size = [WIDTH, WIDTH, CAVITY_HEIGHT], center = true);
        
    // countersink the battery clip (Keystone 209)
    // can't do
    
    // remove a space for the battery clip
    BATTERY_CLIP_HOLES();
}

// outer flange
FLANGE_WIDTH = 2;
FLANGE_DEPTH = .8;
difference(){
    translate([0, -(PCB_WIDTH/2+FLANGE_DEPTH/2), 0])
        cube(size=[WIDTH + FLANGE_WIDTH*2, FLANGE_DEPTH, HEIGHT], center=true);
    BATTERY();
    //INNER_HULL_CHOP_WIDE();
    OUTER_HULL_CHOP_LARGE();
    cylinder(h = HEIGHT, r1 = WIDTH/2-SHELL_WIDTH/2, r2 = WIDTH/2-SHELL_WIDTH/2, center = true);
}

