use <Units.scad>
use <Utils/MirrorCopy.scad>

include <Constants.inc>

$fn = 64;

PivotPlate(part = "rotor");
PivotPlate(part = "stator");

module PivotPlate(
    part        = "rotor, stator",
    base        = [mm(20), mm(8)],
    height      = mm(2.5),
    rim         = mm(.1),
    overhang    = mm(1),
    count       = 120,
    tooth       = mm(.1),
    screw_head  = mm(9),
    screw_shaft = mm(4),
    screw_wall  = mm(0.8),
    outer_wall  = mm(1.5),
    clearance_inner = mm(-.03),
    clearance_outer = mm(-.03)
) {
    y_p1 = sqrt(2) * base[Y]/2;
    screw_to_diagonal_wall = screw_head/2 + screw_wall;
    screw_pos_y = y_p1 + sqrt(2) * screw_to_diagonal_wall;
    r_outer = norm(base) / 2;
    r_inner = screw_pos_y - screw_head/2 - screw_wall - tooth;
    
    if(part == "rotor") {
        Rotor();
    }
    else if(part == "stator") {
        Stator();
    }
    
    module Rotor() {
        InnerRing();
        intersection() {
            OuterRing();
            linear_extrude(height) {
                square([
                    2*(r_outer + tooth + overhang),
                    base[Y]
                ], true);
            }
        }
    }
    
    module Stator() {
        difference() {
            linear_extrude(height) {
                hull() {
                    circle(r = r_outer + overhang + tooth + outer_wall);
                    mirror_copy(VEC_Y) {
                        translate([0,screw_pos_y]) {
                            circle(d = screw_head + 2 * screw_wall);
                        }
                    }
                }
            }
            BIAS=0.1;
            InnerRing(extra_z = BIAS, offset_xy=clearance_inner);
            difference() {
                OuterRing(extra_z = BIAS, offset_xy=clearance_outer);
                mirror_copy(VEC_Y) {
                    translate([0, y_p1, -2*BIAS]) linear_extrude(height + 4 * BIAS) {
                        rotate(45) square(10);
                    }
                }
            }
            mirror_copy(VEC_Y) {
                translate([0, screw_pos_y]) {
                    Screw();
                }
            }
        }
    }
    
    module Screw() {
        BIAS = 0.1;
        translate([0,0,-BIAS]) {
            cylinder(d=screw_shaft, h = height + 2*BIAS);
        }
        translate([0, 0, height + BIAS]) {
            mirror(VEC_Z)cylinder(
                d1= screw_head + 2*BIAS,
                d2= screw_shaft,
                h = (screw_head - screw_shaft) / 2
            );
        }
    }
    
    module OuterRing(extra_z = mm(0), offset_xy = mm(0)) {
        Ring(
            r         = r_outer,
            extra_z   = extra_z,
            offset_xy = offset_xy
        );
    }
    module InnerRing(extra_z = mm(0), offset_xy = mm(0)) {
        Ring(
            r         = r_inner,
            extra_z   = extra_z,
            offset_xy = offset_xy
        );
    }
    module Ring(r, extra_z = mm(0), offset_xy = mm(0)) {
        points = [
            [offset_xy + r, height+extra_z],    
            [offset_xy + r, (2/3)*height + rim/3],    
            [offset_xy + r - rim, (2/3)*height - rim/3],
            [offset_xy + r - rim, (1/3)*height],
            [offset_xy + r + overhang, (1/3)*height],
            [offset_xy + r + overhang, 0 - extra_z],
        ];
        
        ring_count = len(points);
        loop_count = count*2;
        
        points_3d = [
            for(i=[0:loop_count - 1], p=points)
                let(angle = 180.0 / count * i)
                let(offset = ((i%2==0)?0:1)*tooth)
            [
                sin(angle) * (p[X] + offset),
                cos(angle) * (p[X] + offset),
                p[Y]
            ]
        ];
        
        faces = faces_of_cyclinder(
            ring_count = ring_count,
            loop_count = loop_count
        );
        polyhedron(points_3d, faces, convexity=2);
            
        function faces_of_cyclinder(
            ring_count,
            loop_count
        ) = (
            let(
                faces_outer = [
                    for(
                        i = [0 : ring_count - 2],
                        j = [0 : loop_count - 1]
                    ) let(
                        a1 = i + 0,
                        a2 = i + 1,
                        b1 = (j + 0) * ring_count,
                        b2 = (j + 1) % loop_count * ring_count
                    ) [
                        a1 + b1,
                        a2 + b1,
                        a2 + b2,
                        a1 + b2,
                    ]   
                ],
                face_top = [[
                    for(
                        j=[0:loop_count-1]
                    ) (
                        j * ring_count
                    )
                ]],
                face_bottom = [[
                    for(
                        j=[loop_count-1:-1:0]
                    ) (
                        (j + 1) * ring_count - 1
                    )
                ]]
            )
            concat(
                face_top,
                faces_outer,
                face_bottom
            )
        );
    }
}