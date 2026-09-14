/*
CAIXA PARA COLMEIA — versão sem tampa
Medidas em milímetros.

Modelo:
- Caixa aberta em cima
- Altura: 40 mm
- Fundo fino: 0,4 mm
- Parede: 2 mm
- Canaleta interna para tampa deslizante
- Entrada da canaleta aberta na parede da frente
- 6 presilhas laterais com furos para parafuso
- Furo poligonal na parede da frente e na parede de trás
*/

$fn = 64;

epsilon = 0.02;

// =========================
// MEDIDAS PRINCIPAIS
// =========================
largura_caixa      = 35;     // eixo X
comprimento_caixa  = 60;     // eixo Y
altura_caixa       = 40;     // eixo Z

espessura_parede   = 2;
espessura_fundo    = 0.4;

// =========================
// CANALETA DA TAMPA
// =========================
altura_canaleta    = 36;     // onde começa a canaleta
canaleta_altura    = 2;      // altura da canaleta
canaleta_profund   = 1;      // profundidade da canaleta na parede

// =========================
// PRESILHAS
// =========================
entrada_colmeia    = 18.4;   // parte que entra na madeira da colmeia
presilha_extensao  = 12;     // quanto a presilha sai para fora da caixa
presilha_largura_y = 14;     // tamanho da presilha no comprimento da caixa
presilha_espessura = 3;      // espessura vertical da presilha
furo_parafuso      = 4;      // diâmetro do furo

// posições das 3 presilhas em cada lado
posicoes_presilhas_y = [5, 23, 41];


// =========================
// FURO POLIGONAL NA FRENTE E ATRÁS
// =========================

// Altura da base inferior do polígono em relação ao fundo da caixa
furo_base_z = 18.4;

// Posição horizontal do centro do furo na parede da frente
furo_centro_x = largura_caixa / 2;

// Medidas do polígono
furo_base_largura = 16;
furo_topo_largura = 14;

furo_vertical_baixo = 1.8;
furo_degrau_horizontal = 1;
furo_vertical_meio = 6;
furo_obliquo_altura = 4;

// Para que a base seja 16 mm e o topo seja 14 mm,
// com o degrau horizontal de 1 mm para fora,
// o deslocamento horizontal do trecho oblíquo precisa ser 2 mm.
furo_obliquo_dx =
    (furo_base_largura + 2 * furo_degrau_horizontal - furo_topo_largura) / 2;


// =========================
// MÓDULO DO FURO POLIGONAL
// =========================
module furo_poligonal_frente() {

    b = furo_base_largura / 2;

    z1 = furo_vertical_baixo;
    z2 = furo_vertical_baixo + furo_vertical_meio;
    z3 = furo_vertical_baixo + furo_vertical_meio + furo_obliquo_altura;

    x_base = b;
    x_externo = b + furo_degrau_horizontal;
    x_topo = x_externo - furo_obliquo_dx;

    pontos = [
        [-x_base,   0],
        [ x_base,   0],

        [ x_base,   z1],
        [ x_externo, z1],
        [ x_externo, z2],
        [ x_topo,   z3],

        [-x_topo,   z3],
        [-x_externo, z2],
        [-x_externo, z1],
        [-x_base,   z1]
    ];

    translate([
        furo_centro_x,
        espessura_parede + epsilon,
        furo_base_z
    ])
        rotate([90, 0, 0])
            linear_extrude(height = espessura_parede + 2 * epsilon)
                polygon(points = pontos);
}


module furo_poligonal_tras() {

    b = furo_base_largura / 2;

    z1 = furo_vertical_baixo;
    z2 = furo_vertical_baixo + furo_vertical_meio;
    z3 = furo_vertical_baixo + furo_vertical_meio + furo_obliquo_altura;

    x_base = b;
    x_externo = b + furo_degrau_horizontal;
    x_topo = x_externo - furo_obliquo_dx;

    pontos = [
        [-x_base,   0],
        [ x_base,   0],

        [ x_base,   z1],
        [ x_externo, z1],
        [ x_externo, z2],
        [ x_topo,   z3],

        [-x_topo,   z3],
        [-x_externo, z2],
        [-x_externo, z1],
        [-x_base,   z1]
    ];

    translate([
        furo_centro_x,
        comprimento_caixa + epsilon,
        furo_base_z
    ])
        rotate([90, 0, 0])
            linear_extrude(height = espessura_parede + 2 * epsilon)
                polygon(points = pontos);
}


// =========================
// CORPO DA CAIXA SEM FURO
// =========================
module corpo_caixa_colmeia() {
    union() {

        // Fundo fino
        cube([largura_caixa, comprimento_caixa, espessura_fundo]);

        // Parede da frente
        // Ela para antes da canaleta para deixar a entrada da tampa aberta.
        cube([largura_caixa, espessura_parede, altura_canaleta]);

        // Parede de trás — parte inferior
        translate([0, comprimento_caixa - espessura_parede, 0])
            cube([largura_caixa, espessura_parede, altura_canaleta]);

        // Parede de trás — parte da canaleta
        translate([0, comprimento_caixa - canaleta_profund, altura_canaleta])
            cube([largura_caixa, canaleta_profund, canaleta_altura]);

        // Parede de trás — parte superior
        translate([0, comprimento_caixa - espessura_parede, altura_canaleta + canaleta_altura])
            cube([
                largura_caixa,
                espessura_parede,
                altura_caixa - altura_canaleta - canaleta_altura
            ]);

        // Parede lateral esquerda — parte inferior
        cube([espessura_parede, comprimento_caixa, altura_canaleta]);

        // Parede lateral esquerda — parte da canaleta
        translate([0, 0, altura_canaleta])
            cube([canaleta_profund, comprimento_caixa, canaleta_altura]);

        // Parede lateral esquerda — parte superior
        translate([0, 0, altura_canaleta + canaleta_altura])
            cube([
                espessura_parede,
                comprimento_caixa,
                altura_caixa - altura_canaleta - canaleta_altura
            ]);

        // Parede lateral direita — parte inferior
        translate([largura_caixa - espessura_parede, 0, 0])
            cube([espessura_parede, comprimento_caixa, altura_canaleta]);

        // Parede lateral direita — parte da canaleta
        translate([largura_caixa - canaleta_profund, 0, altura_canaleta])
            cube([canaleta_profund, comprimento_caixa, canaleta_altura]);

        // Parede lateral direita — parte superior
        translate([largura_caixa - espessura_parede, 0, altura_canaleta + canaleta_altura])
            cube([
                espessura_parede,
                comprimento_caixa,
                altura_caixa - altura_canaleta - canaleta_altura
            ]);

        // Presilhas laterais
        for (ypos = posicoes_presilhas_y) {
            presilha_esquerda(ypos);
            presilha_direita(ypos);
        }
    }
}


// =========================
// CAIXA COM FUROS
// =========================
module caixa_colmeia() {
    difference() {
        corpo_caixa_colmeia();

        // Furo na parede da frente, na face y = 0
        furo_poligonal_frente();

        // Furo na parede de trás, na face y = comprimento_caixa
        furo_poligonal_tras();
    }
}


// =========================
// PRESILHA ESQUERDA
// =========================
module presilha_esquerda(ypos) {
    difference() {
        translate([-presilha_extensao, ypos, entrada_colmeia])
            cube([
                presilha_extensao,
                presilha_largura_y,
                presilha_espessura
            ]);

        translate([
            -presilha_extensao / 2,
            ypos + presilha_largura_y / 2,
            entrada_colmeia - 0.5
        ])
            cylinder(
                h = presilha_espessura + 1,
                d = furo_parafuso
            );
    }
}


// =========================
// PRESILHA DIREITA
// =========================
module presilha_direita(ypos) {
    difference() {
        translate([largura_caixa, ypos, entrada_colmeia])
            cube([
                presilha_extensao,
                presilha_largura_y,
                presilha_espessura
            ]);

        translate([
            largura_caixa + presilha_extensao / 2,
            ypos + presilha_largura_y / 2,
            entrada_colmeia - 0.5
        ])
            cylinder(
                h = presilha_espessura + 1,
                d = furo_parafuso
            );
    }
}


// =========================
// GERAR MODELO
// =========================
caixa_colmeia();