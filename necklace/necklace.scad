
i = 0;

necklace_radius=78;

body_radius = 10;
recepticle_length = 2;
letter_depth=4;

module single_letter(text = "k"){
        translate([body_radius/2+recepticle_length,0,   body_radius/2+7/2-letter_depth])
    linear_extrude(5) {
        text(text, 9,halign="center",valign="center");
    }
}

//single_letter();
//import("link.stl");

module imprint(){ 
    //letters = "k";
    letters="ואהבת לרעך כמוך ";
    count = len(letters)*2;
    for( i = [0:count-1]){
        l = letters[i%len(letters)];
        rotate([0,0,360*i/count])
        translate([0, necklace_radius, 0])
        difference(){
            rotate([90,0,-5])
            import("link.stl", center=true);
            rotate([0,0,-5])
            single_letter(text=l);
            //rotate([270,0,0])
            //single_letter();
        }
    }
}

imprint();
