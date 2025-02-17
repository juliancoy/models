$fn=100;
radius=10;
loopRadius=70;
cornerRadius=10;
tubeInnerRadius=8;
tubeOuterRadius=10;

translateOut = 0.6;
wraparoundDeg = 330;

module mouthpieceHole(){
    translate([0,-loopRadius+2-translateOut,-translateOut])
    rotate([35,0,0])
    translate([0,-tubeInnerRadius+1,0])
    rotate([90,0,0])
    scale([3,1,1])
    cylinder(d=8, h=20, center=true);
}

module mouthpiece(){
    translate([0,-loopRadius+2-translateOut,-translateOut])
    rotate([35,0,0])
    translate([0,-tubeInnerRadius+1,0])
    rotate([90,0,90])
    scale([1,1.8,1])
    cylinder(d=8, h=40, center=true);
}

module innerGap(){
    rotate_extrude(angle = wraparoundDeg-3) { // Limit rotation to 300 degrees
        translate([loopRadius, 0, 0])
            circle(r = tubeInnerRadius);
    }
    
}


// Create the path for the triangular shape with rounded corners
module roundedTrianglePath(loopRadius, cornerRadius) {
    for (i = [0 : 120 : 240]) { // 240 degrees for the triangular path
        translate([cos(i) * loopRadius, sin(i) * loopRadius, 0])
            rotate([0, 0, i])
            translate([cornerRadius, 0, 0])
            circle(r=cornerRadius);
    }
}


module triangleTubeWithRoundedEnds() {
    mouthpiece();
    
    // Sweeping the circular profile along the triangular path
    rotate([0,0,20])
    rotate_extrude(angle = wraparoundDeg) { // Limit rotation to 300 degrees
        translate([loopRadius, 0, 0])
            circle(r = tubeOuterRadius);
    }
}

module fingerSlit(rotation){
    rotate([0,0,rotation])
    translate([loopRadius, 0, -tubeOuterRadius])
    rotate([0,90,0])
    scale([1,1.7,1])
    cylinder(h=30, r=3, center=true);
}

difference(){
    triangleTubeWithRoundedEnds();
    mouthpieceHole();
    innerGap();

    fingerSlit(155);
    fingerSlit(128);
    fingerSlit(102);
    fingerSlit(80);
    fingerSlit(62);
    fingerSlit(40);
}
