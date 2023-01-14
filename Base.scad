include <Config.inc>
include <Constants.inc>

use <Rosette.scad>
use <HexNut.scad>
use <PivotPlate.scad>
use <Utils/MirrorCopy.scad>
use <Shapes/Drop.scad>

$fn=64;

Base();

module Base() {
    CHILD_INDEX_HEAD = 0;
    
    Rosettes();

    difference() {
        basic_shape();
        HenchWithSpringGap();
        ScrewAndNut();
    }
    PivotPlate(
        part="rotor",
        height = base_foot_h,
        base=[base_screw_length, 2*foot_axel_pos[1]]
    );
    
    if($children > CHILD_INDEX_HEAD) {
        translate([0, 0, holder_height + foot_axel_pos[1]]) {
            children(CHILD_INDEX_HEAD);
        }
    }

    module basic_shape() {
        rotate(90, VEC_Y) rotate(90) {
            linear_extrude(
                base_screw_length,
                center=true
            ) {
                BIAS = 0.1;
                translate([0, holder_height + foot_axel_pos[1]]) {
                    circle(r = foot_axel_pos[1]);
                }
                translate([0, (holder_height + foot_axel_pos[1] + base_foot_h - BIAS) / 2]) {
                    square([
                        foot_axel_pos[1] * 2,
                        holder_height + foot_axel_pos[1] - base_foot_h + BIAS
                    ], true);
                }
            }
        }
    }

    module HenchWithSpringGap() {
        mirror_copy(VEC_X) {
            translate([
                connector_pin_case_width / 2 + rosette_height + base_holder_clearance,
                0,
                foot_axel_pos[1] + holder_height
            ]) {
                rotate(-90, VEC_Y) {
                    BIAS = 0.1;
                    a = (connector_pin_case_width - foot_hench_gap) / 2;
                    b = a + rosette_height + 2 * base_holder_clearance;
                    c = -holder_height/2-foot_axel_pos[1] + BIAS;
                    linear_extrude(
                        b
                    ) {
                        square(2 * foot_axel_pos[1] + mm(.5), true);
                    }
                    wall = mm(.8);
                    gap = (b - 2 * wall) / 3;
                    translate([c, wall]) {
                        linear_extrude(
                            gap
                        ) {
                            square([
                                holder_height,
                                2 * foot_axel_pos[1]
                            ] , true);
                        }
                    }
                    translate([c, wall, b]) {
                        mirror(VEC_Z) linear_extrude(
                            gap
                        ) {
                            square([
                                holder_height,
                                2 * foot_axel_pos[1]
                            ] , true);
                        }
                    }
                    translate([c, -wall, b/2]) {
                        mirror(VEC_Z) linear_extrude(
                            gap ,
                            center=true
                        ) {
                            square([
                                holder_height,
                                2 * foot_axel_pos[1]
                            ] , true);
                        }
                    }
                }
            }
        }
    }
    module Rosettes() {
        translate([0, 0, holder_height]) {
            clearance = base_holder_clearance;
            mirror_copy(VEC_X) {
                translate([
                    -connector_pin_case_width/2 - rosette_height - clearance,
                    0,
                    foot_axel_pos[1]
                ]) rotate(90, VEC_Y){
                    Rosette(
                        count = 24,
                        d1    = axel_d / 2 ,
                        d2    = foot_axel_pos[1] ,
                        h     = rosette_height,
                        negatief = true
                    );
                }
            }
        }
    }
    module ScrewAndNut(
        screw_shaft_diameter = mm(3.0),
        screw_head_size = mm(1.7),
        screw_shaft_length = base_screw_length
    ) {
        translate([0, 0, holder_height + foot_axel_pos[1]]) {
            rotate(90, VEC_Y) {
                BIAS= 0.05;
                translate([0,0,screw_shaft_length/2 + BIAS]) {
                    mirror(VEC_Z) HexNut();
                }
                translate([0,0,-screw_shaft_length/2 - BIAS]) {
                    Screw(
                        screw_shaft_diameter,
                        screw_head_size,
                        screw_shaft_length
                    );
                }
            }
        }
    }
    
    module Screw(
        screw_shaft_diameter,
        screw_head_size,
        screw_shaft_length
    ) {
        cylinder(
            d1=screw_shaft_diameter+2*screw_head_size,
            d2=screw_shaft_diameter,
            h=screw_head_size
        );
        linear_extrude(screw_shaft_length) {
            rotate(90) Drop(screw_shaft_diameter, degree(60));
        }
    }
}