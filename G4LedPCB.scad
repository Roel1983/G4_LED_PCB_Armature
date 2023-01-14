include <Config.inc>
include <Constants.inc>
use <Utils/MirrorCopy.scad>

$fn = 64;
G4LedPCB();

module G4LedPCB() {
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