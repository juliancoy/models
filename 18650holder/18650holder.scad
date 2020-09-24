include <../lib/Chamfers-for-OpenSCAD/Chamfer.scad>;
HEIGHT = 75;
WIDTH = 24;

e = .001;
BATT_DIAMETER = 18.0 + 1; // leave a little space
BATT_RADIUS   = BATT_DIAMETER/2;
BATT_LENGTH   = 65.0;
COMPRESSED_CLIP_WIDTH    = 3.75; // compressed clip width
CAVITY_HEIGHT = BATT_LENGTH+COMPRESSED_CLIP_WIDTH*2;
CAVITY_RADIUS = BATT_LENGTH+COMPRESSED_CLIP_WIDTH*2;
END_SHELL_HEIGHT = (HEIGHT-(BATT_LENGTH+COMPRESSED_CLIP_WIDTH*2))/2;
PCB_WIDTH = 1.6;
NUBLEN = 2;
BATTERY_CLIP_STRAIT_WIDTH = 11;
BATTERY_CLIP_OFFSET = .5-e;
BATTERY_CLIP_WIDTH  = 9;
ARCH_HEIGHT = 2;
SHELL_WIDTH = (WIDTH-BATT_DIAMETER)/2/2 + e;
echo("SHELL_WIDTH");
echo(SHELL_WIDTH);
echo("END_SHELL_HEIGHT");
echo(END_SHELL_HEIGHT);
INNER_SHELL_RADIUS = BATT_RADIUS+SHELL_WIDTH;
// precision
$fn=200; 
INNER_HULL_GRADE = -8.5; // degrees i think
//OUTER_HULL_GRADE = -INNER_HULL_GRADE; // degrees i think
OUTER_HULL_GRADE = 0; // degrees i think
OUTER_CHAMFER = 2;
   
module BATTERY() 
    cylinder(h = CAVITY_HEIGHT, r = BATT_RADIUS, center = true);

module INNER_CYLINDER(){
    //cylinder(h = HEIGHT, r1 = INNER_SHELL_RADIUS, r2 = INNER_SHELL_RADIUS, center = true);
    chamferCylinder(h=HEIGHT, r=INNER_SHELL_RADIUS, ch=OUTER_CHAMFER-(WIDTH/2 - INNER_SHELL_RADIUS), center = true);
}

module BASIC_INNER_HULL() difference(){
    // main material
    INNER_CYLINDER();
    // battery size
    BATTERY();  
}

module INNER_HULL_CHOP(){
    // take off the top half
    rotate([INNER_HULL_GRADE,0,0]){
        translate([0,INNER_SHELL_RADIUS, 0])
            cube(size = [INNER_SHELL_RADIUS*2+e,INNER_SHELL_RADIUS*2+e,CAVITY_HEIGHT-INNER_HULL_GRADE/10], center = true);
    }
}
module INNER_HULL_CHOP_WIDE(){
    // take off the top half
    rotate([INNER_HULL_GRADE,0,0]){
        translate([0,INNER_SHELL_RADIUS, 0])
            cube(size = [WIDTH-SHELL_WIDTH,INNER_SHELL_RADIUS*2+e,CAVITY_HEIGHT+.3], center = true);
    }
}

module OUTER_HULL_CHOP(){
    difference(){
        rotate([OUTER_HULL_GRADE,0,0])
            translate([0,WIDTH/2, 0])
                cube(size = [WIDTH,WIDTH,CAVITY_HEIGHT+.7], center = true);
        // spare the end cap from the chop
    translate([0,0,-HEIGHT/2 + END_SHELL_HEIGHT/2])
        cylinder(h=END_SHELL_HEIGHT, r=INNER_SHELL_RADIUS, center = true);
    }
}
module OUTER_HULL_CHOP_LARGE(){
    rotate([OUTER_HULL_GRADE,0,0]){
        translate([0,WIDTH/2, 0])
            cube(size = [WIDTH+6,WIDTH,CAVITY_HEIGHT+16], center = true);
    }
}

module BATTERY_CLIP_HOLE_SMALL()
    translate([0,0,-HEIGHT/2+END_SHELL_HEIGHT/2])
        cube(size = [BATTERY_CLIP_WIDTH,NUBLEN,END_SHELL_HEIGHT+.1], center = true);

module BATTERY_CLIP_HOLE_LARGE()
    translate([0,0,-HEIGHT/2+END_SHELL_HEIGHT/2])
        cube(size = [BATTERY_CLIP_WIDTH,BATTERY_CLIP_STRAIT_WIDTH,END_SHELL_HEIGHT+ARCH_HEIGHT*2], center = true);

module BATTERY_CLIP_HOLE(){
    translate([0,BATTERY_CLIP_OFFSET,0]){
        // remove a space for the battery clip
        BATTERY_CLIP_HOLE_SMALL();
        translate([0,BATTERY_CLIP_STRAIT_WIDTH,0])
            BATTERY_CLIP_HOLE_LARGE();
    }
}

module BATTERY_CLIP_HOLES(){
    BATTERY_CLIP_HOLE();
    rotate([0,0,180])
        BATTERY_CLIP_HOLE();
    
    // create arch 
    translate([0,-10,-HEIGHT/2 + END_SHELL_HEIGHT/2 + ARCH_HEIGHT])
    rotate([90,0,0])
    cylinder(h = 5, r = BATTERY_CLIP_WIDTH/2, center = true);
}

module OUTER_CYLINDER(){
    chamferCylinder(h=HEIGHT, r=WIDTH/2, ch=OUTER_CHAMFER, center = true);
}

// strengthen the lower shell
STRENGTHEN_BASE_HEIGHT = COMPRESSED_CLIP_WIDTH-1;
module STREGNTHEN_BASE(){
    difference(){
        translate([0, 0, -HEIGHT/2 + STRENGTHEN_BASE_HEIGHT/2+END_SHELL_HEIGHT-e])
            cylinder(h = STRENGTHEN_BASE_HEIGHT, r = WIDTH/2+e*2, center = true);
        cube(size = [BATTERY_CLIP_WIDTH+1, WIDTH, CAVITY_HEIGHT+e*3], center = true);
    }
}
intersection(){
    STREGNTHEN_BASE();
    OUTER_CYLINDER();
}

module STRENGTHEN_INVERT(){
    mirror([0,0,1])
        STREGNTHEN_BASE();
}

// make a ball-in-hole snap
module ball(r){
    NUB_HEIGHT_OFFSET = 6;
    NUB_ANGLE_OFFSET = 15;
    rotate([0,0,NUB_ANGLE_OFFSET]) translate([INNER_SHELL_RADIUS,0,HEIGHT/2-NUB_HEIGHT_OFFSET])sphere(r = r);
    rotate([0,0,180-NUB_ANGLE_OFFSET]) translate([INNER_SHELL_RADIUS,0,HEIGHT/2-NUB_HEIGHT_OFFSET])sphere(r = r);
}
ball(0.8);

// outer hull
module OUTER_HULL(){
    difference(){
        OUTER_CYLINDER();
        
        // remove the top side
        OUTER_HULL_CHOP();
        
        // remove the center
        cylinder(h = CAVITY_HEIGHT, r1 = WIDTH/2-SHELL_WIDTH, r2 = WIDTH/2-SHELL_WIDTH, center = true);
        
        // polish off the end cap
        translate([0, WIDTH/2+5, 0])
            cube(size = [WIDTH, WIDTH, CAVITY_HEIGHT], center = true);
        
        // remove one end cap
        translate([0,0,HEIGHT/2-END_SHELL_HEIGHT/2])
            cube(size = [WIDTH,WIDTH,END_SHELL_HEIGHT+e], center = true);
        
        BATTERY_CLIP_HOLES();
        
        STRENGTHEN_INVERT();
        
        rotate([180,0,0]) ball(1.0);
    }
}
OUTER_HULL();

// inner hull
module INNER_HULL(){
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
        
        STRENGTHEN_INVERT();
    }
}

INNER_HULL();


// outer flange
FLANGE_WIDTH = 2;
FLANGE_DEPTH = .8;
intersection(){
    difference(){
        translate([0, -(PCB_WIDTH/2+FLANGE_DEPTH/2), 0])
            cube(size=[WIDTH + FLANGE_WIDTH*2, FLANGE_DEPTH, HEIGHT], center=true);
        BATTERY();
        //INNER_HULL_CHOP_WIDE();
        OUTER_HULL_CHOP_LARGE();
        cylinder(h = HEIGHT, r1 = WIDTH/2-SHELL_WIDTH/2, r2 = WIDTH/2-SHELL_WIDTH/2, center = true);
        
    }
    
    chamferCylinder(h=HEIGHT, r=WIDTH/2+OUTER_CHAMFER, ch=OUTER_CHAMFER*2, center = true);
}

