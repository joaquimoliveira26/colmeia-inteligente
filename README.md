🐝 Colmeia Inteligente

Sistema IoT desenvolvido para monitoramento de colmeias utilizando ESP32 e sensores, com coleta e transmissão de dados para acompanhamento das condições da colmeia.

📌 Sobre o projeto

A Colmeia Inteligente tem como objetivo auxiliar no acompanhamento das condições da colmeia por meio de sensores e monitoramento remoto.

O sistema coleta informações relacionadas à temperatura, umidade, som e abertura da colmeia, permitindo acompanhar alterações no ambiente e obter informações que podem auxiliar na observação das condições da colmeia.

Os dados são processados pelo ESP32 e enviados para uma plataforma de monitoramento, possibilitando o acompanhamento das informações de forma remota.

🔧 Tecnologias e componentes

- ESP32 DevKit V1
- Sensor DHT11 para temperatura e umidade interna
- Sensor DHT11 para temperatura e umidade externa
- Sensor BME
- Microfone INMP441
- Sensor magnético MC-38 para detecção da abertura da colmeia
- Firebase Realtime Database
- Baterias de lítio 18650
- Módulo de proteção/BMS
- Conversor Boost
- Modelagem e impressão 3D

📊 Dados monitorados

- 🌡️ Temperatura interna e externa
- 💧 Umidade interna e externa
- 🎙️ Som da colmeia
- 🚪 Abertura da colmeia

📡 Monitoramento e comunicação

O ESP32 realiza a leitura dos sensores e processa as informações coletadas. Por meio da conexão Wi-Fi, os dados são enviados para o Firebase Realtime Database, permitindo o armazenamento e acompanhamento remoto das informações.

🔋 Sistema de alimentação

O sistema utiliza células de lítio 18650 de 3,7 V, juntamente com circuito de proteção e conversor de tensão, fornecendo a alimentação necessária para o ESP32 e os sensores.

🖨️ Estrutura e fabricação

Parte da estrutura do projeto foi desenvolvida utilizando modelagem e impressão 3D, possibilitando a criação de peças adaptadas ao sistema de monitoramento da colmeia.

📁 Estrutura do projeto

- "codigo/" — Código utilizado no ESP32
- "modelos-3d/" — Modelos utilizados na impressão 3D
- "imagens/" — Fotos do projeto e da montagem
- "esquemas/" — Esquemas elétricos e conexões
- "documentos/" — Documentação do projeto
- "resultados/" — Testes, medições e resultados

👨‍💻 Projeto

Projeto desenvolvido para fins acadêmicos e de pesquisa, com o objetivo de aplicar tecnologias de IoT, eletrônica e monitoramento remoto no acompanhamento de colmeias de abelhas.
