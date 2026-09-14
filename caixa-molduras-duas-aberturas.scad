/*
CAIXA PARA COLMEIA COM TAMPA DESLIZANTE, MOLDURA FIXA E 2 MOLDURAS INTERNAS SEM FUROS
Medidas em milímetros.

Atualizações desta versão:
- Mantém a caixa e a tampa deslizante.
- As 2 molduras soltas ficam separadas para impressão.
- Molduras soltas SEM furos laterais, pois não serão parafusadas.
- Molduras soltas com 30,9 x 55,9 mm para encaixar dentro da caixa.
- Borda das duas molduras soltas e da moldura fixa alterada para 3 mm.
- Moldura fixa no fundo da caixa com borda de 3 mm.
- Centro do fundo/moldura deixado com 0,4 mm para destacar depois e abrir o vão da tela metálica.
*/

$fn = 64;
epsilon = 0.02;

// =========================
// MODO DE VISUALIZAÇÃO
// =========================
// "separada"  = caixa e tampa lado a lado, melhor para imprimir
// "encaixada" = tampa colocada dentro da canaleta, melhor para conferir o encaixe
modo_tampa = "separada";

// "separadas"     = molduras ao lado da caixa, melhor para imprimir
// "dentro_caixa"  = mostra as duas molduras soltas encaixadas dentro da caixa
modo_molduras = "separadas";

// Mostra uma telinha simbólica apenas para conferência visual.
mostrar_tela_visual = false;

// =========================
// MEDIDAS PRINCIPAIS
// =========================
largura_caixa      = 35;     // eixo X
comprimento_caixa  = 60;     // eixo Y
altura_caixa       = 40;     // eixo Z

espessura_parede   = 2;
espessura_fundo    = 0.4;    // camada fina destacável no centro

// =========================
// CANALETA DA TAMPA
// =========================
altura_canaleta    = 36;
canaleta_altura    = 2;
canaleta_profund   = 1;

// =========================
// TAMPA DESLIZANTE
// =========================
folga_lateral      = 0.10;
folga_altura       = 0.10;
folga_traseira     = 1.00;

largura_tampa      = largura_caixa - (2 * canaleta_profund) - folga_lateral; // 32,9 mm
comprimento_tampa  = comprimento_caixa - folga_traseira;                     // 59 mm
espessura_tampa    = canaleta_altura - folga_altura;                         // 1,9 mm

// =========================
// MOLDURAS / ESQUADROS INTERNOS PARA TELA METÁLICA
// =========================
// Medida interna real da caixa: 31 x 56 mm.
// Molduras soltas: 30,9 x 55,9 mm, com folga total de 0,1 mm.

moldura_folga_encaixe  = 0.10;

moldura_largura        = largura_caixa - (2 * espessura_parede) - moldura_folga_encaixe;     // 30,9 mm
moldura_comprimento    = comprimento_caixa - (2 * espessura_parede) - moldura_folga_encaixe; // 55,9 mm

moldura_pos_x          = espessura_parede + (moldura_folga_encaixe / 2);
moldura_pos_y          = espessura_parede + (moldura_folga_encaixe / 2);

// Molduras soltas
moldura_solta_espessura = 1.5;

// Borda da moldura fixa e das molduras soltas.
// Pedido: borda com 3 mm em todos os esquadros/molduras.
moldura_borda          = 3;

// Vão central onde ficará a tela metálica.
moldura_abertura_x     = moldura_largura - (2 * moldura_borda);       // 24,9 mm
moldura_abertura_y     = moldura_comprimento - (2 * moldura_borda);   // 49,9 mm

// Moldura fixa integrada ao fundo da caixa.
moldura_fixa_altura    = espessura_parede; // reforço de 2 mm de altura

// Espessura fina que fica fechando o centro para você destacar depois.
centro_destacavel_espessura = espessura_fundo; // 0,4 mm

// Tela visual, só referência.
tela_espessura_visual  = 0.25;

// =========================
// PRESILHAS
// =========================
entrada_colmeia    = 18.4;
presilha_extensao  = 12;
presilha_largura_y = 14;
presilha_espessura = 3;
furo_parafuso      = 4;
posicoes_presilhas_y = [5, 23, 41];

// =========================
// FURO POLIGONAL NA FRENTE
// =========================
furo_base_z = 18.4;
furo_centro_x = largura_caixa / 2;
furo_base_largura = 16;
furo_topo_largura = 14;
furo_vertical_baixo = 1.2;
furo_degrau_horizontal = 1;
furo_vertical_meio = 6;
furo_obliquo_altura = 4;
furo_obliquo_dx =
    (furo_base_largura + 2 * furo_degrau_horizontal - furo_topo_largura) / 2;

// =========================
// TAMPA
// =========================
module tampa_deslizante() {
    cube([
        largura_tampa,
        comprimento_tampa,
        espessura_tampa
    ], center = false);
}

// =========================
// MOLDURA SOLTA SEM FUROS
// =========================
module moldura_tela_metalica_solta() {
    difference() {
        cube([
            moldura_largura,
            moldura_comprimento,
            moldura_solta_espessura
        ], center = false);

        translate([
            moldura_borda,
            moldura_borda,
            -epsilon
        ])
            cube([
                moldura_abertura_x,
                moldura_abertura_y,
                moldura_solta_espessura + 2 * epsilon
            ], center = false);
    }
}

// =========================
// MOLDURA FIXA NO FUNDO DA CAIXA
// =========================
module moldura_fixa_fundo_caixa() {
    // Essa moldura fica grudada na caixa, por cima do fundo de 0,4 mm.
    // O centro NÃO é aberto completamente: fica só a camada fina de 0,4 mm
    // para destacar depois e colocar a tela metálica.
    translate([moldura_pos_x, moldura_pos_y, espessura_fundo])
        difference() {
            cube([
                moldura_largura,
                moldura_comprimento,
                moldura_fixa_altura
            ], center = false);

            translate([
                moldura_borda,
                moldura_borda,
                -epsilon
            ])
                cube([
                    moldura_abertura_x,
                    moldura_abertura_y,
                    moldura_fixa_altura + 2 * epsilon
                ], center = false);
        }
}

// =========================
// TELA VISUAL, APENAS PARA CONFERÊNCIA
// =========================
module tela_visual() {
    color([0.6, 0.6, 0.6, 0.45])
        translate([
            moldura_borda,
            moldura_borda,
            0
        ])
            cube([
                moldura_abertura_x,
                moldura_abertura_y,
                tela_espessura_visual
            ], center = false);
}

// =========================
// FURO POLIGONAL NA FRENTE
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

// =========================
// FURO POLIGONAL NA TRASEIRA
// =========================
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
// CORPO DA CAIXA SEM FUROS
// =========================
module corpo_caixa_colmeia() {
    union() {

        // Fundo fino de 0,4 mm.
        // Ele fica fechado no centro da moldura para poder destacar depois.
        cube([largura_caixa, comprimento_caixa, espessura_fundo]);

        // Moldura fixa interna no fundo da caixa.
        moldura_fixa_fundo_caixa();

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

        // Presilhas laterais da caixa
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

if (modo_tampa == "encaixada") {
    translate([
        (largura_caixa - largura_tampa) / 2,
        0,
        altura_canaleta + ((canaleta_altura - espessura_tampa) / 2)
    ])
        tampa_deslizante();
}
else {
    translate([
        largura_caixa + presilha_extensao + 10,
        0,
        0
    ])
        tampa_deslizante();
}

if (modo_molduras == "dentro_caixa") {
    // Mostra as duas molduras soltas encaixadas dentro da caixa.
    // A tela metálica ficaria entre a moldura fixa e uma moldura solta,
    // ou entre as duas molduras soltas, dependendo da montagem.

    translate([
        moldura_pos_x,
        moldura_pos_y,
        espessura_fundo + moldura_fixa_altura
    ])
        moldura_tela_metalica_solta();

    if (mostrar_tela_visual) {
        translate([
            moldura_pos_x,
            moldura_pos_y,
            espessura_fundo + moldura_fixa_altura + moldura_solta_espessura
        ])
            tela_visual();
    }

    translate([
        moldura_pos_x,
        moldura_pos_y,
        espessura_fundo + moldura_fixa_altura + moldura_solta_espessura + tela_espessura_visual
    ])
        moldura_tela_metalica_solta();
}
else {
    // Duas molduras idênticas, sem furos, separadas para impressão.

    translate([
        largura_caixa + presilha_extensao + 10,
        comprimento_caixa + 10,
        0
    ])
        moldura_tela_metalica_solta();

    translate([
        largura_caixa + presilha_extensao + 10,
        (2 * comprimento_caixa) + 20,
        0
    ])
        moldura_tela_metalica_solta();
}