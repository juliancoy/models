
i = 0;

necklace_radius=82;
body_radius = 10;
recepticle_length = 2;
letter_depth=5;
//single_letter();
//import("link.stl");

module imprint(){
    //letters = "k";
    letters = "BREEZE BREEZE BREEZE BREEZE ";
    count = len(letters);
    for( i = [0:count-1]){
        l = letters[i];
        rotate([0,0,-360*(i+1)/(count+1)])
        translate([0, necklace_radius, 0])
        rotate([0,0,-5])
        difference(){
            import("link.stl", center=true);
            translate([body_radius/2+recepticle_length,0,   body_radius/2+7/2-letter_depth])
        linear_extrude(10) {
            text(l, 8,halign="center",valign="center");
        }
            echo(l);
            //rotate([270,0,0])
            //single_letter();
        }
    }
    translate([0, necklace_radius, 0])
    import("clasp.stl", center=true);

}

imprint();
