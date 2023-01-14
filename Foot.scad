include <Config.inc>

use <PivotPlate.scad>

Foot();

module Foot() {
    CHILD_INDEX_BASE = 0;
    
    PivotPlate(
        part="stator",
        height = base_foot_h,
        base=[base_screw_length, 2*foot_axel_pos[1]]
    );
    if($children > CHILD_INDEX_BASE) {
        children(CHILD_INDEX_BASE);
    }
}