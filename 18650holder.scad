HEIGHT = 77;
WIDTH = 23;
SHELL_WIDTH = 1.15;

e = .001;
BATT_DIAMETER = 18.0 + 0.8; // leave a little space
BATT_RADIUS   = BATT_DIAMETER/2;
BATT_LENGTH   = 65.0;
CLIP_WIDTH    = 4; // compressed clip width
CAVITY_HEIGHT = BATT_LENGTH+CLIP_WIDTH*2;
CAVITY_RADIUS = BATT_LENGTH+CLIP_WIDTH*2;
INNER_SHELL_RADIUS = BATT_RADIUS+SHELL_WIDTH;
END_SHELL_WIDTH = (HEIGHT-(BATT_LENGTH+CLIP_WIDTH*2))/2;
COUNTERSINK_HEIGHT = 1.7;
NUBLEN = 2;
PCB_WIDTH = 1.6;
BATTERY_CLIP_OFFSET = 6.5;
BATTERY_CLIP_WIDTH  = 8;
// precision
$fn=200; 
   
LATCH_INTERSECTION_HEIGHT=4;

module LATCHBAR() cube(size = [WIDTH+e,NUBLEN+e,LATCH_INTERSECTION_HEIGHT+e], center = true);
module RECEPTIVE_LATCHS() union(){
    translate([0,NUBLEN/2,HEIGHT/2-LATCH_INTERSECTION_HEIGHT])
        LATCHBAR();
};

module BATTERY() 
    cylinder(h = CAVITY_HEIGHT, r1 = BATT_RADIUS, r2 = BATT_RADIUS, center = true);

module BASIC_INNER_HULL() difference(){
    // main material
    cylinder(h = HEIGHT, r1 = INNER_SHELL_RADIUS, r2 = INNER_SHELL_RADIUS, center = true);
    // battery size
    BATTERY();
}

INNER_HULL_GRADE = -6; // degrees i think
module INNER_HULL_CHOP(){
    // take off the top half
    rotate([INNER_HULL_GRADE,0,0]){
        translate([0,WIDTH/2, 0])
            cube(size = [WIDTH,WIDTH,CAVITY_HEIGHT+.3], center = true);
    }
}

OUTER_HULL_GRADE = 6; // degrees i think
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
        cube(size = [BATTERY_CLIP_WIDTH,NUBLEN,HEIGHT+e], center = true);

module BATTERY_CLIP_HOLES(){
    // remove a space for the battery clip
    BATTERY_CLIP_HOLE();
    translate([0,BATTERY_CLIP_OFFSET,0])
        BATTERY_CLIP_HOLE();
    translate([0,-BATTERY_CLIP_OFFSET,0])
        BATTERY_CLIP_HOLE();
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
    translate([0,0,HEIGHT/2-END_SHELL_WIDTH/2])
        cube(size = [WIDTH,WIDTH,END_SHELL_WIDTH+e], center = true);
    
    BATTERY_CLIP_HOLES();
}


// stable latch
difference(){
    intersection(){
        BASIC_INNER_HULL();
        translate([0,NUBLEN/2,-(HEIGHT/2-LATCH_INTERSECTION_HEIGHT)])
            LATCHBAR();
    }
    // smooth off one side
    translate([4.2,0,0])
    rotate([0,0,75])
        cube(size = [WIDTH-4,INNER_SHELL_RADIUS,HEIGHT], center = true);
    // smooth off other side
    translate([-4.2,0,0])
    rotate([0,0,-75])
        cube(size = [WIDTH-4,INNER_SHELL_RADIUS,HEIGHT], center = true);
}

// inner hull
difference(){
    BASIC_INNER_HULL();
    INNER_HULL_CHOP();
    
    // remove one end cap
    translate([0,0,HEIGHT/2-END_SHELL_WIDTH/2])
        cube(size = [WIDTH,WIDTH,END_SHELL_WIDTH+e], center = true);
        
    // polish off the end cap
    translate([0, WIDTH/2-tan(INNER_HULL_GRADE)*HEIGHT/2-0.2, 0])
        cube(size = [WIDTH, WIDTH, CAVITY_HEIGHT], center = true);
    
    // take out the receptive latches from either side
    RECEPTIVE_LATCHS();
    
    // countersink the battery clip (Keystone 209)
    // can't do
    
    // remove a space for the battery clip
    BATTERY_CLIP_HOLES();
}

FLANGE_WIDTH = 2;
FLANGE_DEPTH = 1.2;
// outer flange
difference(){
    translate([0, -(PCB_WIDTH/2+FLANGE_DEPTH/2), 0])
        cube(size=[WIDTH + FLANGE_WIDTH*2, FLANGE_DEPTH, HEIGHT], center=true);
    BATTERY();
    INNER_HULL_CHOP();
    OUTER_HULL_CHOP_LARGE();
}

