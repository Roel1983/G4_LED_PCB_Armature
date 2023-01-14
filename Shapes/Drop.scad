use <../Utils/IntersectionMirror.scad>
include <../Constants.inc>

Drop(10, 60);

module Drop(d, a) {
    circle(d=d);
    intersection_mirror(VEC_X) {
        rotate(a) square([d/2, d]);
    }
}
