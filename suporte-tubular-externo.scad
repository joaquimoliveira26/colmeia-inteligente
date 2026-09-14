$fn = 128;

// ==========================================================
// dimensões do tubo principal
// ==========================================================

tube_outer_d = 39.6;
tube_wall = 2.0;
tube_inner_d = tube_outer_d - 2*tube_wall;

vertical_tube_h = 50;
horizontal_tube_l = 100;

// ==========================================================
// joelho toroidal separado
// ==========================================================

// raio da linha central da curva do joelho
// precisa ser maior que aproximadamente elbow_outer_d/2
bend_radius = 32;

// folga radial para encaixe dos tubos no joelho
fit_clearance = 0.1;

// profundidade de encaixe dos tubos dentro do joelho
socket_depth = 18;

// parede externa do joelho
elbow_wall = 2.5;

// diâmetro interno da luva, onde o tubo entra
socket_inner_d = tube_outer_d + 2*fit_clearance;

// diâmetro externo da peça do joelho
elbow_outer_d = socket_inner_d + 2*elbow_wall;

// ==========================================================
// flange no fim do tubo horizontal
// ==========================================================

flange_thickness_x = 4;
flange_y = 70;
flange_z = 50;

// furos dos parafusos
screw_hole_d = 4.2;
hole_margin_y = 7;
hole_margin_z = 6;

eps = 0.05;

// ==========================================================
// módulos auxiliares
// ==========================================================

module cylinder_x(h, d) {
    rotate([0, 90, 0])
        cylinder(h = h, d = d, center = false);
}

module cylinder_z(h, d) {
    cylinder(h = h, d = d, center = false);
}

// segmento toroidal padrão:
// antes da transformação, o arco fica no plano xy.
// depois será orientado para ligar z a x.
module torus_segment_standard(R, d, angle = 90) {
    rotate_extrude(angle = angle, convexity = 10)
        translate([R, 0, 0])
            circle(d = d);
}

// transforma o toro padrão para que:
// uma extremidade tenha eixo no sentido z;
// a outra extremidade tenha eixo no sentido x.
module orient_torus_z_to_x(R) {
    translate([R, 0, 0])
        multmatrix([
            [-1, 0, 0, 0],
            [ 0, 0, 1, 0],
            [ 0, 1, 0, 0],
            [ 0, 0, 0, 1]
        ])
            children();
}

// segmento toroidal externo ou interno já orientado
module torus_segment_z_to_x(R, d) {
    orient_torus_z_to_x(R)
        torus_segment_standard(R, d, 90);
}

// ==========================================================
// peça 1: tubo vertical
// ==========================================================

module vertical_tube() {
    difference() {
        cylinder_z(vertical_tube_h, tube_outer_d);

        translate([0, 0, -eps])
            cylinder_z(vertical_tube_h + 2*eps, tube_inner_d);
    }
}

// ==========================================================
// peça 2: tubo horizontal com flange
// ==========================================================

module screw_holes() {
    for (sy = [-1, 1])
        for (sz = [-1, 1])
            translate([
                horizontal_tube_l - eps,
                sy*(flange_y/2 - hole_margin_y),
                sz*(flange_z/2 - hole_margin_z)
            ])
                cylinder_x(flange_thickness_x + 2*eps, screw_hole_d);
}

module horizontal_tube_with_flange() {
    difference() {
        union() {
            cylinder_x(horizontal_tube_l, tube_outer_d);

            translate([
                horizontal_tube_l - eps,
                -flange_y/2,
                -flange_z/2
            ])
                cube([
                    flange_thickness_x + eps,
                    flange_y,
                    flange_z
                ], center = false);
        }

        // vazio interno do tubo, atravessando também a flange
        translate([-eps, 0, 0])
            cylinder_x(
                horizontal_tube_l + flange_thickness_x + 2*eps,
                tube_inner_d
            );

        // furos dos parafusos
        screw_holes();
    }
}

// ==========================================================
// peça 3: joelho toroidal separado
// ==========================================================

module elbow_toroidal_piece() {
    difference() {

        union() {
            // corpo curvo externo: segmento de toro de 90 graus
            torus_segment_z_to_x(bend_radius, elbow_outer_d);

            // luva vertical reta para encaixe do tubo vertical
            translate([0, 0, -socket_depth])
                cylinder_z(socket_depth + eps, elbow_outer_d);

            // luva horizontal reta para encaixe do tubo horizontal
            translate([bend_radius, 0, bend_radius])
                cylinder_x(socket_depth + eps, elbow_outer_d);
        }

        union() {
            // canal interno curvo principal
            torus_segment_z_to_x(bend_radius, tube_inner_d);

            // canal interno vertical completo
            translate([0, 0, -socket_depth - eps])
                cylinder_z(
                    socket_depth + 2*eps,
                    socket_inner_d
                );

            // continuação interna vertical até a curva
            translate([0, 0, -eps])
                cylinder_z(
                    eps + 2*eps,
                    tube_inner_d
                );

            // canal interno horizontal completo da luva
            translate([bend_radius - eps, 0, bend_radius])
                cylinder_x(
                    socket_depth + 2*eps,
                    socket_inner_d
                );

            // continuação interna horizontal na saída da curva
            translate([bend_radius - eps, 0, bend_radius])
                cylinder_x(
                    eps + 2*eps,
                    tube_inner_d
                );
        }
    }
}

// ==========================================================
// visualização com as peças separadas e orientadas para impressão
// ==========================================================

// tubo vertical, mantido em pé
translate([-90, 0, 0])
    vertical_tube();


// joelho toroidal deitado sobre o plano xy
// rotação: o plano da curva deixa de ser xz e passa a ser xy
// translação em z: faz a parte inferior tocar o plano z = 0
translate([0, 80, elbow_outer_d/2])
    rotate([90, 0, 0])
        elbow_toroidal_piece();


// tubo horizontal com flange girado
// após a rotação, a flange fica apoiada no plano xy
// o eixo do tubo passa a ficar aproximadamente na direção z
translate([100, 0, horizontal_tube_l + flange_thickness_x])
    rotate([0, 90, 0])
        horizontal_tube_with_flange();