include <Units.scad>

Rosette();

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
