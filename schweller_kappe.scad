use <schweller_kappe_vr_silloutette.scad>

$fs = 0.5;

cap_width = 60;

curvature_radius = 3;

module click_cut() {
    polygon(
        points=[
            [-1, -0.5],
            [5.6, -.5],
            [7.15, 5.5],
            [6.5, 33.9],
            [5.2, 40],
            [-1, 40]
        ]
    );
}
click_cut_depth = 3.5;

module lower_rest_edge() {
    polygon(
        points=[
            [0.0, 0.0],
            [4, -1.0],
            [7.0, 10.0],
            [9.0, 20.0],
            [9.0, 30.0],
            [8.0, 40.0],
            [6.0, 50.0],
            [4.0, 60.0],
            [-3.5, 67.0],
            [-4.5, 65.0],
            [-12, 74.0],
            [-14, 73.0],
            [-7.5, 63.0],
            [-0.0, 50.0],
        ]
    );
}
lower_rest_edge_length = 40;

nodge_tooth_overlap = 0.5;
nodge_tooth_height = 3.0;
nodge_tooth_length = 5.5;

module nodge_tooth() {
    translate([nodge_tooth_height, 0, 0]) {
        rotate([90, -90 , 0]) {
            linear_extrude(nodge_tooth_length) {
                polygon(
                    points=[
                        [-nodge_tooth_overlap, 0.0],
                        [nodge_tooth_overlap, 0.0],
                        [0.0, nodge_tooth_height],
                    ]
                );
            }
        }
    }
}

union() {
difference () {
    difference () {
        translate([0, 297]) {
            linear_extrude(cap_width) {
                Layer_1();
            }
        }
        translate([20, 64.1, 0]) {
            rotate([90, 0, -90]) {
                difference() {
                    translate([-15, -15, 0]) cube([120, 90, 30]);
                    translate([0, 0, -10]) {
                        linear_extrude(cap_width) {
                            hull() {
                                hh_short = 77 - 2 * curvature_radius;
                                hh_long = 79 - 2 * curvature_radius;
                                width = cap_width - 2 * curvature_radius;
                                translate(
                                    [curvature_radius, curvature_radius ,0]
                                ) {
                                    translate([0, -1, 0]) {
                                        circle(curvature_radius);
                                    }
                                    translate([hh_short, -1 ,0]) {
                                        circle(curvature_radius);
                                    }
                                    translate([hh_long, width ,0]) {
                                        circle(curvature_radius);
                                    }
                                    translate([0, width ,0]) {
                                        circle(curvature_radius);
                                    }
                                }
                            } 
                        }
                    }
                }
            }
        }
    }
    linear_extrude(click_cut_depth) {
        click_cut();
    }
    translate([0, 0, 60 - click_cut_depth]) {
        linear_extrude(click_cut_depth) {
            click_cut();
        }
    }
}

translate([0, -8, (cap_width - lower_rest_edge_length) / 2]) {
    linear_extrude(lower_rest_edge_length) {
        lower_rest_edge();
    }
}

translate([0, nodge_tooth_length, click_cut_depth]) {
    nodge_tooth();
}
translate([0, nodge_tooth_length, cap_width - click_cut_depth]) {
    nodge_tooth();
}

translate([0, nodge_tooth_length  + 34, click_cut_depth]) {
    nodge_tooth();
}
translate([0, nodge_tooth_length + 34, cap_width - click_cut_depth]) {
    nodge_tooth();
}

}