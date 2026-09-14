/*
JOELHO DE 90 GRAUS

Geometria:
- Entrada com seção interna poligonal de 10 lados.
- Entrada no plano y = 0.
- Trecho inicial avança no eixo +y.
- Curva reta de 90 graus.
- Saída retangular avança no eixo -x.
- Espessura das paredes: 1 mm.
- Base do trecho inicial aberta.
- Entrada aberta.
- Saída retangular aberta no fim.
- Na face terminal da saída, a figura menor fica FECHADA.
- O restante da abertura retangular fica ABERTO.
*/

epsilon = 0.02;


// =========================
// PARÂMETROS GERAIS
// =========================

espessura = 1.0;

// Comprimento interno do trecho reto da entrada,
// medido no eixo y.
comprimento_entrada = 25;

// Comprimento interno da saída,
// medido no eixo x, no sentido negativo.
comprimento_saida_x = 15;

// Abertura inferior do trecho de entrada.
// Por padrão, vai até a curva.
comprimento_abertura_base = comprimento_entrada;


// =========================
// ENTRADA POLIGONAL INTERNA
// =========================

entrada_base_largura = 16;
entrada_topo_largura = 14;

entrada_vertical_baixo = 1;
entrada_degrau_horizontal = 1;
entrada_vertical_meio = 6;
entrada_obliquo_altura = 4;

entrada_altura_total =
    entrada_vertical_baixo
    + entrada_vertical_meio
    + entrada_obliquo_altura;


// Para compatibilizar:
// base = 16 mm,
// degrau horizontal = 1 mm para fora em cada lado,
// topo = 14 mm.
entrada_obliquo_dx =
    (
        entrada_base_largura
        + 2 * entrada_degrau_horizontal
        - entrada_topo_largura
    ) / 2;


// =========================
// SAÍDA RETANGULAR INTERNA
// =========================

// Dimensão interna da saída no eixo y.
saida_largura_y_interna = 13.8;

// Dimensão interna da saída no eixo z.
saida_altura_z_interna = 11;


// =========================
// FIGURA MENOR QUE FICARÁ FECHADA
// NA FACE TERMINAL DA SAÍDA
// =========================

abertura_y_1 = 6.2;
abertura_y_2 = 7.6;

abertura_z_1 = 2.8;
abertura_z_2 = 8.4;
abertura_z_total = 11.2;


// =========================
// PERFIL 2D DA ENTRADA
// Coordenadas no plano xz
// =========================

function perfil_entrada_pontos() =
    let(
        b = entrada_base_largura / 2,

        z1 = entrada_vertical_baixo,
        z2 = entrada_vertical_baixo + entrada_vertical_meio,
        z3 = entrada_altura_total,

        x_base = b,
        x_externo = b + entrada_degrau_horizontal,
        x_topo = entrada_topo_largura / 2
    )
    [
        [-x_base,    0],
        [ x_base,    0],

        [ x_base,    z1],
        [ x_externo, z1],
        [ x_externo, z2],
        [ x_topo,    z3],

        [-x_topo,    z3],
        [-x_externo, z2],
        [-x_externo, z1],
        [-x_base,    z1]
    ];


// =========================
// MÓDULOS 2D
// =========================

module perfil_entrada_interno_2d() {
    polygon(points = perfil_entrada_pontos());
}


module perfil_entrada_externo_2d() {
    offset(delta = espessura, chamfer = true)
        polygon(points = perfil_entrada_pontos());
}


// Retângulo interno da saída no plano yz.
// Coordenada horizontal local = eixo y.
// Coordenada vertical local   = eixo z.
module perfil_saida_interno_2d() {
    translate([
        -saida_largura_y_interna / 2,
        0
    ])
        square([
            saida_largura_y_interna,
            saida_altura_z_interna
        ]);
}


// Retângulo externo da saída no plano yz.
module perfil_saida_externo_2d() {
    translate([
        -saida_largura_y_interna / 2 - espessura,
        -espessura
    ])
        square([
            saida_largura_y_interna + 2 * espessura,
            saida_altura_z_interna + 2 * espessura
        ]);
}


// Perfil da região que ficará FECHADA na saída.
// Antes esta região era o furo; agora ela será a parte sólida.
//
// Plano local yz:
// - horizontal = y;
// - vertical   = z.
//
// Começa no canto de menor y e menor z da abertura retangular.
module perfil_fechado_terminal_2d() {

    y_min = -saida_largura_y_interna / 2;

    polygon(points = [
        [y_min,                                      0],
        [y_min,                                      abertura_z_1],

        [y_min + abertura_y_1,                       abertura_z_1],
        [y_min + abertura_y_1,                       abertura_z_2],

        [y_min + abertura_y_1 + abertura_y_2,        abertura_z_2],
        [y_min + abertura_y_1 + abertura_y_2,        abertura_z_total],

        [y_min,                                      abertura_z_total]
    ]);
}


// =========================
// EXTRUSÕES
// =========================

// Extrusão de perfil no plano xz ao longo do eixo +y.
module extrude_y(comprimento) {
    multmatrix([
        [1, 0, 0, 0],
        [0, 0, 1, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = comprimento, convexity = 10)
            children();
}


// Extrusão de perfil no plano yz ao longo do eixo +x.
// Coordenada horizontal 2D vira y.
// Coordenada vertical 2D vira z.
module extrude_x_positivo(comprimento) {
    multmatrix([
        [0, 0, 1, 0],
        [1, 0, 0, 0],
        [0, 1, 0, 0],
        [0, 0, 0, 1]
    ])
        linear_extrude(height = comprimento, convexity = 10)
            children();
}


// Extrusão de perfil no plano yz ao longo do eixo -x.
module extrude_x_negativo(comprimento) {
    mirror([1, 0, 0])
        extrude_x_positivo(comprimento)
            children();
}


// =========================
// TRECHO DE ENTRADA
// =========================

module volume_externo_entrada() {
    extrude_y(comprimento_entrada + espessura)
        perfil_entrada_externo_2d();
}


module vazio_interno_entrada() {
    translate([0, -epsilon, 0])
        extrude_y(comprimento_entrada + epsilon)
            perfil_entrada_interno_2d();
}


// =========================
// SAÍDA RETANGULAR NO SENTIDO -X
// =========================

module volume_externo_saida_x_negativo() {
    translate([
        0,
        comprimento_entrada - saida_largura_y_interna / 2,
        0
    ])
        extrude_x_negativo(comprimento_saida_x + espessura)
            perfil_saida_externo_2d();
}


// Vazio interno da saída retangular.
//
// Agora atravessa a face terminal inteira,
// para deixar a abertura retangular totalmente aberta.
module vazio_interno_saida_x_negativo_totalmente_aberto() {
    translate([
        epsilon,
        comprimento_entrada - saida_largura_y_interna / 2,
        0
    ])
        extrude_x_negativo(comprimento_saida_x + espessura + 2 * epsilon)
            perfil_saida_interno_2d();
}


// Placa terminal com a figura menor.
// Esta é a região que ficará fechada.
module placa_terminal_fechada() {
    translate([
        -comprimento_saida_x - espessura,
        comprimento_entrada - saida_largura_y_interna / 2,
        0
    ])
        extrude_x_positivo(espessura)
            perfil_fechado_terminal_2d();
}


// =========================
// ABERTURA INFERIOR DO TRECHO DE ENTRADA
// =========================

module abertura_base_entrada() {
    translate([
        -entrada_base_largura / 2 - epsilon,
        -epsilon,
        -espessura - epsilon
    ])
        cube([
            entrada_base_largura + 2 * epsilon,
            comprimento_abertura_base + epsilon,
            espessura + 2 * epsilon
        ]);
}


// =========================
// CORPO OCO DO JOELHO
// =========================

module corpo_oco_joelho() {
    difference() {

        union() {
            volume_externo_entrada();
            volume_externo_saida_x_negativo();
        }

        // Interior da entrada poligonal
        vazio_interno_entrada();

        // Interior da saída retangular,
        // atravessando a face terminal inteira
        vazio_interno_saida_x_negativo_totalmente_aberto();

        // Base aberta no trecho de entrada
        abertura_base_entrada();
    }
}


// =========================
// JOELHO COMPLETO
// =========================

module joelho_90() {
    union() {
        corpo_oco_joelho();

        // Agora esta peça fecha apenas a figura menor,
        // deixando aberto o restante do retângulo.
        placa_terminal_fechada();
    }
}


// =========================
// GERAR MODELO
// =========================

joelho_90();