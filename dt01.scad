$fn = 30;
inner_width = 110;
inner_length= 75;
inner_height= 25;
standoff_height = 3;
inner_dims  = [inner_width, inner_length, inner_height + standoff_height];
e = 0.001;
e2 = 0.002;
bottom_shell = 4;
side_width = 3;

module lid(dims, side_width, bore_dia, bottom_shell){
    rad = side_width/2;
    difference(){
        hull(){
            translate([-side_width, -side_width, 0])
            cylinder(d = side_width, h = bottom_shell);
            translate([-side_width , side_width + dims[1], 0])
            cylinder(d = side_width, h = bottom_shell);
            translate([side_width + dims[0], -side_width, 0])
            cylinder(d = side_width, h = bottom_shell);
            translate([side_width + dims[0], side_width + dims[1], 0])
            cylinder(d = side_width, h = bottom_shell);
        }
        
        translate([0,0,bottom_shell+.01])
        cube(dims);
        
        translate([-rad, -rad, -e])
        cylinder(d1 = bore_dia, d2 = side_width*2, h = bottom_shell + e2);
        translate([-rad , rad + dims[1], -e])
        cylinder(d1 = bore_dia, d2 = side_width*2, h = bottom_shell + e2);
        translate([rad + dims[0], -rad, -e])
        cylinder(d1 = bore_dia, d2 = side_width*2, h = bottom_shell + e2);
        translate([rad + dims[0], rad + dims[1], -e])
        cylinder(d1 = bore_dia, d2 = side_width*2, h = bottom_shell + e2);
    
    }
}

module roundedBox(dims, side_width, bore_dia, bottom_shell){
    rad = side_width/2;
    difference(){
        hull(){
            translate([-side_width, -side_width, 0])
            cylinder(d = side_width, h = dims[2] + bottom_shell);
            translate([-side_width , side_width + dims[1], 0])
            cylinder(d = side_width, h = dims[2] + bottom_shell);
            translate([side_width + dims[0], -side_width, 0])
            cylinder(d = side_width, h = dims[2] + bottom_shell);
            translate([side_width + dims[0], side_width + dims[1], 0])
            cylinder(d = side_width, h = dims[2] + bottom_shell);
        }
        
        translate([0,0,bottom_shell+.01])
        cube(dims);
        
        translate([-rad, -rad, e])
        cylinder(d = bore_dia, h = dims[2] + bottom_shell);
        translate([-rad , rad + dims[1], e])
        cylinder(d = bore_dia, h = dims[2] + bottom_shell);
        translate([rad + dims[0], -rad, e])
        cylinder(d = bore_dia, h = dims[2] + bottom_shell);
        translate([rad + dims[0], rad + dims[1], e])
        cylinder(d = bore_dia, h = dims[2] + bottom_shell);
    
    }
}


RPI_STANDOFF_CENTERS = [[0,0,0], [0,48.5,0], [58,0,0], [58,48.5,0]];
module standoffs(standoff_height, bore){
        standoff_dia = 5;
        for(center = RPI_STANDOFF_CENTERS){
            translate(center)
            difference(){
                cylinder(d2 = standoff_dia, d1 = standoff_dia*3, h = standoff_height + bottom_shell);
                cylinder(d = bore, h = standoff_height + bottom_shell + e);
            }
        }
}

module standoff_bore(standoff_height, bore){
        standoff_dia = 5;
        for(center = RPI_STANDOFF_CENTERS){
            translate(center)
            cylinder(d = bore, h = standoff_height + bottom_shell + e);
        }
}


bore_dia = 3;
difference(){
    union(){
        roundedBox(inner_dims,side_width, bore_dia, bottom_shell);
        translate([27, 20, e])
        standoffs(standoff_height, 3);
    }
    
    // USB + Ethernet hole
    translate([-18,19,bottom_shell])
    cube([20,55,23]);
    
    // Standoff holes
    translate([27, 20, e]){
        translate([0,0,-3])
        standoffs(standoff_height, 0);
        standoff_bore(standoff_height, 3);
    }
            
    
    // power hole
    translate([25,inner_dims[1]-e,-e])
    cube([63,12,16]);
    
    // sound hole
    translate([101,inner_dims[1]-e,bottom_shell+standoff_height])
    cube([8,10,21]);
    
    // air holes
    for(i = [0:7]){
        translate([101 - i*13,-10,bottom_shell+standoff_height])
        cube([4,11,26]);
    }
    for(i = [0:4]){
        translate([109,7 + i*13,bottom_shell+standoff_height])
        cube([11,4,26]);
    }
}

top_shell = 2.4;
translate([0,90,0]){
    difference(){
        lid(inner_dims, side_width, bore_dia, top_shell);
        // hole for screen
        translate([5, 22,-e2])
        cube([77,52,21]);
    }

}
