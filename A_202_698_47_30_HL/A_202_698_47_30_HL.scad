/* Sebastian A. Mueller
 * Mercedes-Benz W202 C43 AMG spoiler-cover
 * A 202 698 47 30 HL
 */
use <scans/scan_1.scad> // module name: g833
use <scans/scan_2.scad> // module name: g887
use <scans/lower_overlapping_notch.scad> // module name: g001

__version__ = "v0.1";

module rear_edge(extrude_width=1) {
    translate([0,80,0]) {
        linear_extrude(extrude_width) {
            g833();
        }
    }
}

module lower_overlapping_notch(width) {
    translate([0,80,0]) {
        linear_extrude(width) {
            g001();
        }
    }
}

module front_edge(extrude_width=1) {
    scale(1.04)
    translate([-1.0,78.8,0]) {
        linear_extrude(extrude_width) {
            g887();
        }
    }
}

outer_cover_height = 73;
outer_cover_width = 60.5;
outer_cover_corner_radius = 3.5;

module outer_shape(width) {
    extrude_width = 1;
    hull() {
        rear_edge(extrude_width=extrude_width);
        translate([0, 0, width - extrude_width]) {
            front_edge(extrude_width=extrude_width);
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


module round_corner_mold(x,y,z,inner_x, inner_y,r) {
    dx = (x - inner_x) / 2;
    dy = (y - inner_y) / 2;

    xww = inner_x;
    yww = inner_y;
    hww = z * 3;


    difference() {
        translate([-dx, -dy, 0]) {
            cube([x,y,z]);
        }
        translate([0,0,-z]) {
            hull() {
                translate([r, -r + yww,0]) cylinder(r=r, h=hww);
                translate([-r + xww, -r + yww,0]) cylinder(r=r, h=hww);
                translate([r, r,0]) cylinder(r=r, h=hww);
                translate([-r + xww, r,0]) cylinder(r=r, h=hww);
            }
        }
    }
}


module cover_wall_round_corners() {
    difference() {
        cover_wall();
        translate([15,-13.8,0]){
            rotate([0,-90,0]) {
                round_corner_mold(
                    x=100,
                    y=100,
                    z=30,
                    inner_x=outer_cover_width,
                    inner_y=outer_cover_height,
                    r=outer_cover_corner_radius
                );
            }
        }
    }
}

LOWER_OVERLAPPING_NOTCH_WIDTH = 40;

SNAP_TOOTH_WIDTH = 6.0;
SNAP_SPAN_FRONT_TO_BACK = 52;
SNAP_TOOTH_DEPTH = 0.5;

module tooth(width, height, depth) {
    translate([height,width * 0.5,0]) {
        rotate([-90,0,180]) {
            linear_extrude(width) {
                polygon(
                    points=[
                        [0, 0],
                        [height, 0],
                        [height, depth]
                    ]
                );
            }
        }
    }
}

module snaps() {
    ni = 0;
    ww = 10;
    th = 3.75;
    tw = SNAP_TOOTH_WIDTH * 0.75;

    nt = 7.5;
    translate([-nt,0,ni]) {
        cube([nt,SNAP_TOOTH_WIDTH,ww]);
        translate([nt - th,SNAP_TOOTH_WIDTH/2,0]) {
            rotate([0,0,10]) tooth(width=tw, height=th, depth=SNAP_TOOTH_DEPTH);
        }
    }

    nb = 7.5;
    translate([-nb,40 - SNAP_TOOTH_WIDTH,ni]) {
        cube([nb,SNAP_TOOTH_WIDTH,ww]);
        translate([nt - th - 1,SNAP_TOOTH_WIDTH/2,0]) {
            rotate([0,0,-10]) tooth(width=tw, height=th, depth=SNAP_TOOTH_DEPTH);
        }
    }
}

to_inner = (outer_cover_width - SNAP_SPAN_FRONT_TO_BACK) / 2;

module A_202_698_47_30() {

    translate([0,0,to_inner]) {
        snaps();
    }
    translate([0,0, outer_cover_width - to_inner]) {
        mirror([0,0,1]) {
            snaps();
        }
    }

    to_inner_notch = (outer_cover_width - LOWER_OVERLAPPING_NOTCH_WIDTH) / 2;


    cover_wall_round_corners();

    module support_polygon() {
        polygon(
            points=[
                [-7, 0],
                [-9, 15],
                [-8, 30],
                [-7, 40],
                [-6, 45],
                [-4, 48],
                [0, 52],
                [6, 56],
                [12, 56],
                [17, 60],
                [18, 61],
                [19, 61],
                [10, 50],
                [0, 40],
                [0, 0],
                [0, -6],
                [-5, -7],
            ]
        );
    }

    translate([0,0,to_inner_notch]) {
        lower_overlapping_notch(width=LOWER_OVERLAPPING_NOTCH_WIDTH);
        linear_extrude(LOWER_OVERLAPPING_NOTCH_WIDTH) {
            support_polygon();
        }
    }
}

module type_text(side_name) {
    h = 1;
    mirror([0,0,0]) {
        translate([-10,0,0]) {
            scale([0.75,0.75,1]) {
            translate([0,0,0]){linear_extrude(h) text("A202");}
            translate([0,-11,0]){linear_extrude(h) text("698");}
            translate([0,-22,0]){linear_extrude(h) text("4730");}
            translate([0,-33,0]){linear_extrude(h) text(side_name);}
            translate([0,-44,0]){linear_extrude(h) text(__version__);}
            }
        }
    }
}

module A_202_698_47_30_HL() {
    A_202_698_47_30();
    translate([0,30,30]){rotate([0,90,0]) {type_text(side_name="HL");}}
}

module A_202_698_47_30_HR() {
    mirror([0,0,1]) {A_202_698_47_30();}
    translate([0,30,-30]){rotate([0,90,0]) {type_text(side_name="HR");}}
}

//A_202_698_47_30_HL();

A_202_698_47_30_HR();
