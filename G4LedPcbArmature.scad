include <Constants.inc>
use <G4LedPCB.scad>
use <Head.scad>
use <Base.scad>
use <Foot.scad>

Foot() {
    rotate(-30, VEC_Z) Base() {
        rotate(30, VEC_X)Head() {
            %G4LedPCB();
        }
    }
}