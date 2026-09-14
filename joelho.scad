/*
JOELHO DE 90 GRAUS DESCENDO NO EIXO Z

Medidas em milímetros.

Geometria:
- Entrada com seção interna poligonal de 10 lados.
- Entrada no plano y = 0.
- Trecho inicial avança no eixo +y.
- Curva reta de 90 graus.
- Saída desce no eixo -z.
- Saída com seção interna retangular.
- Espessura das paredes: 1 mm.
- Base do trecho inicial aberta.
- Entrada aberta.
- Saída aberta.
- Demais faces fechadas.
*/

epsilon = 0.02;


// =========================
// PARÂMETROS GERAIS
// =========================

espessura = 1.0;

// Comprimento interno do trecho reto antes da curva,
// medido no eixo y.
comprimento_entrada = 25;

// Comprimento da saída descendente,
// medido no eixo z.
comprimento_saida_z = 25;

// Comprimento da abertura inferior do trecho inicial.
// Por padrão, vai até a curva.
comprimento_abertura_base = comprimento_entrada;


// =========================
// SEÇÃO INTERNA DA ENTRADA
// POLÍGONO DE 10 LADOS
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
//
// Se você quiser forçar literalmente o oblíquo com dx = 1 mm,
// troque esta expressão por:
// entrada_obliquo_dx = 1;
entrada_obliquo_dx =
    (
        entrada_base_largura
        + 2 * entrada_degrau_horizontal
        - entrada_topo_largura
    ) / 2;


// =========================
// SEÇÃO INTERNA DA SAÍDA
// RETANGULAR, DESCENDO EM Z
// =========================

// Dimensão interna da saída no eixo x.
saida_largura_x_interna = entrada_base_largura;

// Dimensão interna da saída no eixo y.
// Por padrão, uso a altura total da seção poligonal,
// produzindo uma saída retangular de 16 mm x 11 mm.
saida_profundidade_y_interna = entrada_altura_total;


// =========================
// PERFIL POLIGONAL INTERNO
// DA ENTRADA
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


// =========================
// EXTRUSÃO NO EIXO Y
// Perfil 2D no plano xz
// =========================

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


// =========================
// TRECHO DE ENTRADA
// =========================

module volume_externo_entrada() {
    // O exterior avança um pouco além do comprimento interno,
    // para fechar a face posterior da curva.
    extrude_y(comprimento_entrada + espessura)
        perfil_entrada_externo_2d();
}


module vazio_interno_entrada() {
    // Abre a entrada no plano y = 0,
    // mas não atravessa a parede posterior da curva.
    translate([0, -epsilon, 0])
        extrude_y(comprimento_entrada + epsilon)
            perfil_entrada_interno_2d();
}


// =========================
// SAÍDA RETANGULAR DESCENDENTE
// =========================

module volume_externo_saida_descendo() {
    translate([
        -saida_largura_x_interna / 2 - espessura,
        comprimento_entrada - saida_profundidade_y_interna - espessura,
        -comprimento_saida_z
    ])
        cube([
            saida_largura_x_interna + 2 * espessura,
            saida_profundidade_y_interna + 2 * espessura,
            comprimento_saida_z
        ]);
}


module vazio_interno_saida_descendo() {
    translate([
        -saida_largura_x_interna / 2,
        comprimento_entrada - saida_profundidade_y_interna,
        -comprimento_saida_z - epsilon
    ])
        cube([
            saida_largura_x_interna,
            saida_profundidade_y_interna,
            comprimento_saida_z + 2 * epsilon
        ]);
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
// JOELHO COMPLETO
// =========================

module joelho_90_descendo_z() {
    difference() {

        union() {
            volume_externo_entrada();
            volume_externo_saida_descendo();
        }

        // Vazio interno do trecho poligonal
        vazio_interno_entrada();

        // Vazio interno da saída retangular descendente
        vazio_interno_saida_descendo();

        // Face removida: base do trecho de entrada
        abertura_base_entrada();
    }
}


// =========================
// GERAR MODELO
// =========================

joelho_90_descendo_z();