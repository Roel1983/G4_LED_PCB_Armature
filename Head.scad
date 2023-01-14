include <Config.inc>
include <Constants.inc>

use <Rosette.scad>
use <Shapes/Drop.scad>
use <Utils/MirrorCopy.scad>

$fn = 64;

Head();

module Head() {
    CHILD_INDEX_G4_LED_PCB = 0;
    
    translate([0, -foot_axel_pos[0], -foot_axel_pos[1]]) {
        difference() {
            union() {
                Body();
                for(a=[30,150,-90]) rotate(a) Arm();
                
            }
            ConnectorPinGap();
            HenchGap();
        }
        Rosettes();
        if($children > CHILD_INDEX_G4_LED_PCB) {
            translate([0,0,spot_pos]) children(CHILD_INDEX_G4_LED_PCB);
        }
    }

    module Foot() {
        linear_extrude(foot_thickness) {
            difference() {
                circle(d=foot_diameter);
                translate([0,2.0]) rotate(45) square(8);
            }
        }
    }

    module Body() {
        rotate(90, VEC_Y) rotate(90, VEC_Z) {
            linear_extrude(connector_pin_case_width, center=true, convexity = 2) {
                ConnectorCase2D();
                HenchOuter2D();
            }
        }
        module HenchOuter2D() {
            polygon([
                [0,
                 0],
                [foot_axel_pos[0],
                 0],
                [foot_axel_pos[0] - foot_axel_pos[1],
                 foot_axel_pos[1]],
                [foot_axel_pos[0] - foot_axel_pos[1],
                 connector_pin_case_height],
                [0,
                 connector_pin_case_height]
            ]);
            translate(foot_axel_pos) {
                circle(r=(foot_axel_pos[1]));
            }
        }
        module ConnectorCase2D() {
            wall =connector_pin_case_wall;
            polygon([
                [conn_pin_l2 + conn_pin_clearance_xy + wall,
                 mm(0)],
                [conn_pin_l2 + wall + mm(0.6),
                 mm(2.7)],
                [conn_pin_l2 + conn_pin_clearance_xy + wall,
                 mm(2.7)],
                [conn_pin_l2 + conn_pin_clearance_xy + wall,
                 connector_pin_case_height],
                [-conn_pin_outer_diameter/2 - conn_pin_clearance_xy - wall,
                 connector_pin_case_height],
                [-conn_pin_outer_diameter/2 - conn_pin_clearance_xy - wall,
                 mm(0)]
            ]);
        }
    }

    module Arm() {
        arm = mm(6.0);
        intersection() {
            rotate(90, VEC_X) linear_extrude(arm, center=true) {
                square([
                    spot_pcb_diameter/2+spot_clamb_wall,
                    spot_pos + spot_pcb_thickness + spot_clamb_z + spot_clamb_xy
                ]);
            }
            rotate_extrude(convexity=3) {
                polygon([
                    [spot_pcb_diameter/2-spot_rim,
                     spot_pos - spot_clamb_z],
                    [spot_pcb_diameter/2-spot_rim,
                     spot_pos],
                    [spot_pcb_diameter/2,
                     spot_pos],
                    [spot_pcb_diameter/2,
                     spot_pos + spot_pcb_thickness],
                    [spot_pcb_diameter/2-spot_clamb_xy,
                     spot_pos + spot_pcb_thickness + spot_clamb_xy*.5],
                    [spot_pcb_diameter/2-spot_clamb_xy + spot_clamb_z/2,
                     spot_pos + spot_pcb_thickness + spot_clamb_xy*.5 
                     + spot_clamb_z],
                    [spot_pcb_diameter/2+spot_clamb_wall - spot_rim_bevel,
                     spot_pos + spot_pcb_thickness + spot_clamb_xy*.5
                     + spot_clamb_z],
                    [spot_pcb_diameter/2+spot_clamb_wall,
                     spot_pos + spot_pcb_thickness + spot_clamb_xy*.5 +
spot_clamb_z - spot_rim_bevel],
                    [spot_pcb_diameter/2+spot_clamb_wall,
spot_pos-spot_clamb_z],
                    [foot_diameter/2,0],
                    [0,0],
                    [0,mm(2.0)],
                    [foot_diameter/2 - mm(2.0), mm(2.0)]
                ]);
            }
        }

        rotate(90, VEC_X) {
            linear_extrude(mm(1.1), center=true) {
                polygon([
                    [-4,0],
                    [foot_diameter/2 - mm(1.0), 0],
                    [spot_pcb_diameter/2-spot_rim, spot_pos - spot_clamb_z]
                ]);
            }
        }
    }
    
    module Rosettes() {
        BIAS = 0.01;
        mirror_copy(VEC_X) {
            translate([
                connector_pin_case_width/2,
                foot_axel_pos[0],
                foot_axel_pos[1]
            ]) rotate(90, VEC_Y){
                BIAS = 0.01;
                Rosette(
                    count = 24,
                    d1    = axel_d / 2 + BIAS,
                    d2    = foot_axel_pos[1] - BIAS,
                    h     = rosette_height,
                    bias  = BIAS
                );
            }
        }
    }
    
    module ConnectorPinGap() {
        BIAS=mm(1.0);
        translate([0,0,-BIAS]) {
            linear_extrude(conn_pin_length + BIAS) {
                offset(delta=conn_pin_clearance_xy) {
                    ConnectorPin2d();
                }
            }
        }
        pitch=conn_pin_pitch * 0.33 + spot_pin_pitch * 0.67;
        mirror_copy(VEC_X) {
            translate([
                pitch/2,
                0
            ]) {
                linear_extrude(spot_pin_length) {
                    square(spot_pin_diameter+spot_pin_clearance, true);
                }
            }
            linear_extrude(conn_pin_length + mm(.4)) intersection() {
                translate([
                    pitch/2,
                    0
                ]) {
                    square(
                        [spot_pin_diameter + spot_pin_clearance,
                         10],
                        true
                    );
                }
                offset(delta=conn_pin_clearance_xy) {
                    ConnectorPin2d();
                }
            }
        }

        module ConnectorPin2d() {
            difference() {
                union() {
                    intersection() {
                        mirror_copy(
                            VEC_X
                        ) {
                            translate([
                                conn_pin_pitch/2,
                                0
                            ]) {
                                circle(
                                    d=conn_pin_outer_diameter
                                );
                            }
                        }
                        square([
                            conn_pin_w,
                            conn_pin_outer_diameter
                        ], true);
                    }
                    translate([
                        -conn_pin_w/2,
                        -conn_pin_l1
                    ]) {
                        square(
                            [conn_pin_w,
                             conn_pin_l1 + conn_pin_l2]
                        );
                    }
                }
                mirror_copy(VEC_X) {
                    translate([
                        conn_pin_pitch / 2,
                        conn_pin_l2
                    ]) {
                        square([
                            conn_pin_slot_width,
                            2 * conn_pin_slot_depth
                        ], true);
                    }
                }
            }
        }
    }

    module HenchGap() {
        translate([
            0,
            foot_axel_pos[0],
            foot_axel_pos[1]
        ]) {
            rotate(90, VEC_Y) {
                BIAS = 1.0;
                linear_extrude(
                    connector_pin_case_width + BIAS,
                    center=true
                ) rotate(90) Drop(axel_d,60);
                linear_extrude(foot_hench_gap, center=true) {
                    A();
                }
                
            }
        }
        module A() {
            a = (axel_d + 2*mm(3.5));
            circle(d=a);
            translate([-a/2,-a])square((a));
            rotate(45) translate([-a/2,-a])square((a));
            rotate(90) translate([-a/2,-a])square((a));
        }
    }
}