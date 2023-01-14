include <Config.inc>
include <Constants.inc>
use <PivotPlate.scad>

Foot(
    is_printable = true
);

module Foot(
    is_printable = false
) {
    CHILD_INDEX_BASE = 0;
    
    if(is_printable) {
        rotate(180, VEC_X) Foot(is_printable = false);
    } else {
        PivotPlate(
            part="stator",
            height = base_foot_h,
            base=[base_screw_length, 2*foot_axel_pos[1]]
        );
        if($children > CHILD_INDEX_BASE) {
            children(CHILD_INDEX_BASE);
        }
    }
}
