$fn = 30;
inner_width = 110;
inner_length= 75+8;
inner_height= 31;
standoff_height = 3;
tier1_inner_dims  = [inner_width, inner_length, inner_height + standoff_height];
// the screen is  4.76 x 3 x 0.51 inches 

tier2_inner_dims  = [123, 78, 12];
e = 0.001;
e2 = 0.002;
bottom_shell = 2;
side_width = 3;
bore_dia = 3;

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



// second tier
difference(){
    union(){
        roundedBox(tier2_inner_dims,side_width, bore_dia, bottom_shell);
        
    }
    translate([7,3,-e])
    cube([110, 70, 100]);
}