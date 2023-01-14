include <Units.scad>

spot_pcb_diameter       = mm(30.5);
spot_pcb_thickness      = mm( 1.5);
spot_pin_diameter       = mm( 0.95);
spot_pin_length         = mm(16.0);
spot_pin_pitch          = mm( 4.0);
spot_pin_clearance      = mm( 0.05);
spot_pos                = mm(17.4);

spot_clamb_xy           = mm( 0.5);
spot_clamb_z            = mm( 1.0);
spot_clamb_wall         = mm( 1.5);
spot_rim                = mm( 1.0);
spot_rim_bevel          = mm( 0.75);

conn_pin_pitch          = mm(5.08);
conn_pin_outer_diameter = mm(5.50);
conn_pin_l1             = mm(2.00);
conn_pin_l2             = mm(3.00);
conn_pin_w              = mm(10.1);
conn_pin_l3             = mm(8.5);
conn_pin_slot_width     = mm(2.0);
conn_pin_slot_depth     = mm(0.8);
conn_pin_length         = mm(8.6);
conn_pin_clearance_xy   = mm(0.15);
conn_pin_clearance_z    = mm(0.5);

connector_pin_case_wall = mm(1.0);

axel_d                  = mm(3.0);

foot_thickness          = mm( 1.5);
foot_diameter           = mm(18.0);
foot_a                  = mm(14);
foot_axel_pos           = [mm(-9.5), mm(4.0)];

rosette_height          = mm(.2);

holder_height           = mm(15.0);

/* Derived */

connector_pin_case_width = (
    conn_pin_w
    + 2 * (conn_pin_clearance_xy + connector_pin_case_wall)
);
connector_pin_case_height = (
    conn_pin_length
    + conn_pin_clearance_z
    + connector_pin_case_wall
);
foot_hench_gap = connector_pin_case_width/2;

base_holder_clearance = mm(.05);
base_wall = mm(1.5);
base_screw_length = mm(20.0);

base_d = sqrt(pow(base_screw_length, 2) + pow(2*foot_axel_pos[1],2));
base_foot_h = mm(2.5);
rotation = 35;
base_d2 = foot_axel_pos[1] / cos((90 + rotation) / 2);

screw_pos = mm(13.5);