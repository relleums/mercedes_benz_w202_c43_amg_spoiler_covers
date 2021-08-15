/* Sebastian A. Mueller
 * Mercedes-Benz W202 C43 AMG spoiler-cover
 * A 202 698 47 30 HL
 */
use <images/scan_1.scad> // module name: g833
use <images/scan_2.scad> // module name: g887

module rear_edge() {
    translate([0,80,0]) {
        linear_extrude(1) {
            g833();
        }
    }
}

module front_edge() {
    translate([-1.0,78.8,0]) {
        linear_extrude(1) {
            g887();
        }
    }
}

outer_cover_width = 60.0;
wall_width = 2.3;

module outer_shape(width) {
    hull() {
        rear_edge();
        translate([0, 0, width]) {
            front_edge();
        }
    }
}


module cover_wall() {
    difference() {
        outer_shape(outer_cover_width);
        translate([2,-0.7,-1]) {
            outer_shape(outer_cover_width + 2);
        }
    }
}

cover_wall();