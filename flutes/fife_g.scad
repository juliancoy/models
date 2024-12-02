// Tin Whistle in Key of G with Improved Calculations and Separate Mouthpiece

// Parameters
whistle_length = 300;          // Approximate total length of the whistle in mm
body_diameter = 19;            // Outer diameter of the whistle body in mm
wall_thickness = 1.5;          // Thickness of the walls in mm
hole_diameter = 10;             // Diameter of finger holes in mm
frequencies = [392, 440, 494, 523, 587, 659, 740]; // Frequencies for G major scale
e=0.001;                        // Small offset to avoid overlapping geometries

// Calculate hole positions based on the frequencies
function hole_position(f_n) = whistle_length * (1 - (1 / sqrt(f_n / 392)));

// Corrected position array for each note's distance from the end (open end)
hole_positions = [for (i = [0:5]) hole_position(frequencies[i])];

// Whistle Body
module whistle_body() {
    difference() {
        cylinder(h = whistle_length, d = body_diameter, $fn = 100);
        translate([0, 0, wall_thickness])
            cylinder(h = whistle_length + e * 2, d = body_diameter - 2 * wall_thickness, $fn = 100);
        
        // Call finger holes module to add holes to the body
        finger_holes();
    }
}

module slit(){
    scale([8,0.4,1])
    cylinder(h = wall_thickness * 1.5, d1 = hole_diameter, d2=0, $fn = 100);
}

// Finger Holes
module finger_holes() {
    for (i = [0 : 5]) {
        translate([0, body_diameter / 2, whistle_length - hole_positions[i]])
            rotate([90, 0, 0])
                slit();
    }
}


// Assemble the tin whistle with the separate mouthpiece
whistle_body();
