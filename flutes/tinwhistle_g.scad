// Tin Whistle in Key of G with Improved Calculations and Separate Mouthpiece

// Parameters
whistle_length = 300;          // Approximate total length of the whistle in mm
body_diameter = 19;            // Outer diameter of the whistle body in mm
wall_thickness = 1.5;          // Thickness of the walls in mm
hole_diameter = 5;             // Diameter of finger holes in mm
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
        translate([0, 0, -e])
            cylinder(h = whistle_length + e * 2, d = body_diameter - 2 * wall_thickness, $fn = 100);
        
        // Call finger holes module to add holes to the body
        finger_holes();
    }
}

// Finger Holes
module finger_holes() {
    for (i = [0 : 5]) {
        translate([0, body_diameter / 2, whistle_length - hole_positions[i]])
            rotate([90, 0, 0])
                cylinder(h = wall_thickness * 4, d = hole_diameter, $fn = 100);
    }
}

// Improved Mouthpiece with Windway and Labium Ramp
module mouthpiece() {
    // Main mouthpiece shape positioned to the side for separate printing
    translate([body_diameter / 2 + 30, -body_diameter / 2, 0])
        difference() {
            cube([body_diameter * 1.5, body_diameter, 30]);
            
            // Windway channel
            translate([body_diameter * 0.5, body_diameter / 4, 0])
                cube([body_diameter / 2, body_diameter / 4, 15]);
            
            // Labium ramp for air splitting
            translate([body_diameter * 0.5, body_diameter / 4, 15])
                rotate([0, 0, -45])
                    cube([body_diameter / 2, body_diameter / 2, 5]);
        }
}

// Assemble the tin whistle with the separate mouthpiece
whistle_body();
mouthpiece();
