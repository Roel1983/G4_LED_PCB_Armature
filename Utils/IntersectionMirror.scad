include <../Constants.inc>

intersection_mirror(VEC_X) {
    translate([-2, 0]) circle(d=10);
}

module intersection_mirror(vec=undef) {
    intersection() {
        children();
        mirror(vec) children();
    }
}
