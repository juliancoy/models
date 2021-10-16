MAGNET_RADIUS = 16;
MAGNET_HEIGHT = 5;
SHELL_WIDTH = 1.2;
FLAG_RADIUS = 3;
$fn=100;
module magnet()
    cylinder(h = MAGNET_HEIGHT, r = MAGNET_RADIUS, center = true);
    
module angle_text(){
    text_size = 4;
    translate([-100/2,-text_size/2,-text_size/2])
    rotate([90,0,90])
    linear_extrude(height = 100) {
           text(text = "5°", size = text_size);
    }
}

difference(){
    cylinder(h = MAGNET_HEIGHT+SHELL_WIDTH*2, r = MAGNET_RADIUS + SHELL_WIDTH*2, center = true);
    magnet();
    translate([MAGNET_RADIUS/2,0,0])
    magnet();
    //angle_text();
}



FLAG_HEIGHT = 300;
MOUNT_HEIGHT = 24;
module flag()
    translate([0,0,FLAG_HEIGHT/2])cylinder(h = FLAG_HEIGHT, r = FLAG_RADIUS, center = true);

rotate([0,-5,0]){
    difference(){
        translate([0,0,MOUNT_HEIGHT/2]) cylinder(h = MOUNT_HEIGHT, r = FLAG_RADIUS+SHELL_WIDTH*2, center = true);
        flag();
        magnet();
    }
}
