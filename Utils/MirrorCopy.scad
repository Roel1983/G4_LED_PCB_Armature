include <../Constants.inc>

translate([0, 10]) {
    mirror_copy(VEC_X) text("mirror_copy(VEC_X)");
}

translate([0, -10]) {
    mirror_copy(VEC_Y) text("mirror_copy(VEC_Y)");
}

module mirror_copy(vec=undef) {
    children();
    mirror(vec) children();
}
