rim_height = 6;
body_height = 3;
led_width = 5;
outer_width = led_width * 4;
led_section = 10;
section_length = 90;
cross_length = section_length/2.3;


module quarter_pos(body_width, body_height){
    translate([0, section_length/2, 0])
    cube([body_width, section_length, body_height], center=true);
    translate([section_length/2, 0, 0])
    cube([section_length, body_width, body_height], center=true);

    // outer cross ornament
    translate([cross_length/2, section_length, 0])
    cube([cross_length, body_width, body_height], center=true);
    translate([section_length, cross_length/2, 0])
    cube([body_width, cross_length, body_height], center=true); 

    // smaller cross
    translate([section_length/2, section_length/2, 0])
    cube([section_length, body_width, body_height], center=true);
    translate([section_length/2, section_length/2, 0])
    cube([body_width, section_length, body_height], center=true); 

}

quarter_pos(outer_width, body_height);