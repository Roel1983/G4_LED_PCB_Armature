use <Units.scad>
use <Shapes/Hex.scad>

HexNut();

module HexNut(
    hex_nut_size = [mm(5.5), mm(2.5)],
    center = undef
) {
    linear_extrude(hex_nut_size[1], center=center) {
        Hex(hex_nut_size[0]);
    }
}
