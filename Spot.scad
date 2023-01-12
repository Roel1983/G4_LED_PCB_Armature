function mm(x) = x;
function degree(x) = x;
$fn=128;

VEC_X = [1,0,0];
VEC_Y = [0,1,0];
VEC_Z = [0,0,1];

X = 0;
Y = 1;
Z = 2;

spot_pcb_diameter  = mm(30.5);
spot_pcb_thickness = mm( 1.5);
spot_pin_diameter  = mm( 0.95);
spot_pin_length    = mm(16.0);
spot_pin_pitch     = mm( 4.0);
spot_pin_clearance = mm( 0.05);
spot_pos           = mm(17.4);

spot_clamb_xy      = mm( 0.5);
spot_clamb_z       = mm( 1.0);
spot_clamb_wall    = mm( 1.5);
spot_rim           = mm( 1.0);
spot_rim_bevel     = mm( 0.75);

conn_pin_pitch          = mm(5.08);
conn_pin_outer_diameter = mm(5.50);
conn_pin_l1             = mm(2.00);
conn_pin_l2             = mm(3.00);
conn_pin_w               = mm(10.1);
conn_pin_l3             = mm(8.5);
conn_pin_slot_width     = mm(2.0);
conn_pin_slot_depth     = mm(0.8);
conn_pin_length         = mm(8.6);
conn_pin_clearance_xy   = mm(0.15);
conn_pin_clearance_z    = mm(0.5);

connector_pin_case_wall = mm(1.0);
connector_pin_case_width = conn_pin_w + 2 * (conn_pin_clearance_xy +
connector_pin_case_wall);
connector_pin_case_height = conn_pin_length + conn_pin_clearance_z +
connector_pin_case_wall;

axel_d = mm(3.0);

foot_thickness  = mm( 1.5);
foot_diameter   = mm(18.0);
foot_a          = mm(14);
foot_axel_pos   = [mm(-9.5), mm(4.0)];

foot_hench_gap  = connector_pin_case_width/2;
rosette_height  = mm(.2);

holder_height = mm(15.0);

// --------

translate([0, 0, holder_height]) {
    Holder() {
        %Spot();
    }
}
Base();
Foot();

module Holder() {
    difference() {
        union() {
            Body();
            for(a=[30,150,-90]) rotate(a) render() Arm();
            
        }
        ConnectorPinGap();
        HenchGap();
    }
    Rosettes();
    translate([0,0,spot_pos]) children(0);

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
            linear_extrude(connector_pin_case_width, center=true) {
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
            rotate_extrude() {
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
                     spot_pos + spot_pcb_thickness + spot_clamb_xy*.5 +
spot_clamb_z],
                    [spot_pcb_diameter/2+spot_clamb_wall - spot_rim_bevel,
                     spot_pos + spot_pcb_thickness + spot_clamb_xy*.5 +
spot_clamb_z],
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

base_holder_clearance = mm(.05);
base_wall = mm(1.5);
base_screw_length = mm(20.0);

base_d = sqrt(pow(base_screw_length, 2) + pow(2*foot_axel_pos[1],2));
base_foot_h = mm(2.5);
rotation = 35;
base_d2 = foot_axel_pos[1] / cos((90 + rotation) / 2);

screw_pos = mm(13.5);

module Foot() {
    translate([0, foot_axel_pos[0]]) {
        Pivot(
            part="stator",
            height = base_foot_h,
            base=[base_screw_length, 2*foot_axel_pos[1]]
        );
    }
}

module Base() {
    Rosettes();

    difference() {
        basic_shape();
        HenchWithSpringGap();
        ScrewAndNut();
    }
    translate([0, foot_axel_pos[0]]) {
        Pivot(
            part="rotor",
            height = base_foot_h,
            base=[base_screw_length, 2*foot_axel_pos[1]]
        );
    }

    module basic_shape() {
        translate([0, foot_axel_pos[0]]) {
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
    }

    module HenchWithSpringGap() {
        mirror_copy(VEC_X) {
            translate([
                connector_pin_case_width / 2 + rosette_height + base_holder_clearance,
                foot_axel_pos[0],
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
                    foot_axel_pos[0],
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
        translate([0, foot_axel_pos[0], holder_height + foot_axel_pos[1]]) {
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
}
module RibbleRing(BIAS = 0) {
    d1=base_d + 2 * (base_foot_h + BIAS);
    d2=base_d - 2 * BIAS;
    h=base_foot_h + 2 * BIAS;
    intersection() {
        union() {
            cylinder(
                d1=d1,
                d2=d2,
                h=h
            );
            Rosette(
                count = 72,
                d1    = d2/2,
                d2    = d1/2,
                h     = mm(.2),
                bias  = .01,
                negatief = false,
                h_offset1 = h,
                h_offset2 = 0
            );
        }
        rim = mm(.5);
        cylinder(
            d1=d1 - 2 * rim,
            d2=d1 - 2 * rim + h,
            h=h
        );
    }
}
module SnapRing(r=10, h=3, offset_xy=0, offset_z=0, clearance_z=0, coef = 1,BIAS=0) {
    rim = mm(.25);
    rotate_extrude() polygon([
        [
            0,
            -BIAS
        ], [
            offset_xy + r,
            -BIAS
        ], [
            offset_xy + r,
            offset_z  + h/3 - clearance_z
        ], [
            offset_xy + r + coef * -mm(1),
            offset_z  + h/3 - clearance_z
        ], [
            offset_xy + r + coef * -mm(1),
            offset_z  + h/3 * 2 - rim/4 + clearance_z
        ], [
            offset_xy + r + coef * (rim - mm(1)),
            offset_z  + h/3 * 2 + rim/4 + clearance_z
        ], [
            offset_xy + r + coef * (rim - mm(1)),
            base_foot_h + BIAS
        ], [
            0,
            base_foot_h + BIAS
        ]
    ]);
}

module Rosette(
    count = 24,
    d1    = mm(3.1),
    d2    = mm(5.9),
    h     = mm(.5),
    bias  = .01,
    negatief = false,
    h_offset1 = 0,
    h_offset2 = 0,
) {
    angle = 360.0 / count;
    
    points_outer_top = [for(i=[0 : count * 2 - 1] ) let(a = i * angle / 2) [
        sin(a) * d2,
        cos(a) * d2,
        (i%2==0?h:0) + h_offset2
    ]];
    points_outer_bottom = [for(i=[0 : count * 2 - 1] ) let(a = i * angle / 2) [
        sin(a) * d2,
        cos(a) * d2,
        -bias + h_offset2
    ]];
    points_inner_bottom = [for(i=[0 : count - 1] ) let(a = i * angle) [
        sin(a) * d1,
        cos(a) * d1,
        h_offset1
    ]];
    points_inner_top = [for(i=[0 : count - 1] ) let(a = i * angle) [
        sin(a) * d1,
        cos(a) * d1,
        h_offset1 - bias
    ]];
    points = concat(
        points_outer_top,    
        points_outer_bottom,
        points_inner_bottom,
        points_inner_top
    );
    
    face_top_triangle_cw = [for(i=[0 : count - 1])[
        i *  2,
        (i * 2 + 1) % (count * 2),
        i + count * 4
    ]];
    face_top_triangle_ccw = [for(i=[0 : count - 1])[
        (i * 2 + 1) % (count * 2),
        (i * 2 + 2) % (count * 2),
        (i + 1) % (count) + count * 4
    ]];
    face_top_between = [for(i=[0 : count - 1])[
        (i * 2 + 1) % (count * 2),
        (i + 1) % (count) + count * 4,
        (i + 0) % (count) + count * 4
    ]];    
    faces_top = concat(
        face_top_triangle_cw,
        face_top_triangle_ccw,
        face_top_between
    );
    faces_outer = [for(i=[0 : count * 2 - 1])[
        (i + 1) % (count * 2),
        (i + 0) % (count * 2),
        (i + 0) % (count * 2) + count * 2,
        (i + 1) % (count * 2) + count * 2,
    ]];
    faces_bottom = [for(i=[0 : count - 1])[
        (i * 2 + 2) % (count * 2) + count * 2,
        (i * 2 + 1) % (count * 2) + count * 2,
        (i * 2 + 0) % (count * 2) + count * 2,
        (i * 1 + 0) % (count * 1) + count * 5,
        (i * 1 + 1) % (count * 1) + count * 5,
        
    ]];
    faces_inner = [for(i=[0 : count - 1])[
        (i * 1 + 1) % (count * 1) + count * 5,    
        (i * 1 + 0) % (count * 1) + count * 5,
        (i * 1 + 0) % (count * 1) + count * 4,
        (i * 1 + 1) % (count * 1) + count * 4
    ]];
    faces = concat(
        faces_top,
        faces_outer,
        faces_bottom,
        faces_inner
    );
    rotate(negatief?angle / 2:0) {
        polyhedron(points=points, faces=faces);
    }
}





module Spot() {
    Pcb();
    Pins();
    module Pcb() {
        cylinder(
            d = spot_pcb_diameter,
            h = spot_pcb_thickness
        );
    }
    module Pins() {
        mirror_copy(VEC_X) {
            translate([
                spot_pin_pitch/2,
                0
            ]) {
                Pin();
            }
        }
        module Pin() {
            mirror(VEC_Z) cylinder(
                d= spot_pin_diameter,
                h= spot_pin_length
            );
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

module Drop(d, a) {
    circle(d=d);
    intersection_mirror(VEC_X) {
        rotate(a) square([d/2, d]);
    }
}

module Pivot(
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
    
    echo(str("Screw distance is: ", 2 * screw_pos_y));
    
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
            offset_xy = offset_xy,
            flip      = false
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

module HexNut(
    hex_nut_size = [mm(5.5), mm(2.5)],
    center = undef
) {
    linear_extrude(hex_nut_size[1], center=center) {
        Hex(hex_nut_size[0]);
    }
}
module Hex(size = 1) {
    intersection_for(a=[0:120:359]) rotate(a) {
        square([size, 2 * size], true);
    }
}
module intersection_mirror(vec=undef) {
    intersection() {
        children();
        mirror(vec) children();
    }
}
module mirror_copy(vec=undef) {
    children();
    mirror(vec) children();
}
