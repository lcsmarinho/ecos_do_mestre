import 'package:flutter/material.dart';

class FichasDetailPage extends StatelessWidget {
  const FichasDetailPage({Key? key}) : super(key: key);

  // Widget auxiliar para exibir uma linha de informação se o valor não estiver vazio.
  // Se o label for "Nome", aumenta a fonte para ambos, rótulo e valor.
  Widget buildInfoRow(String label, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    if (label == "Nome") {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$label: ",
              style: const TextStyle(
                fontFamily: 'UncialAntiqua',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Color(0xFF1B5E20),
                    offset: Offset(2, 2),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 26,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$label: ",
              style: const TextStyle(
                fontFamily: 'UncialAntiqua',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  // Widget auxiliar para exibir cabeçalhos (como "Atributos:", "Inventário Geral:" etc.)
  Widget buildHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'UncialAntiqua',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(color: Color(0xFF1B5E20), offset: Offset(2, 2), blurRadius: 3),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Recupera a ficha passada via argumento.
    final Map<String, dynamic> ficha =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    // Recupera o endereço da imagem a partir do campo "image".
    final String imagePath =
        ficha['image'] != null && ficha['image'].toString().trim().isNotEmpty
            ? ficha['image'].toString()
            : 'assets/images/ecos-logo.png';

    // Recupera os mapas de atributos e carteira, se existirem.
    final Map<String, dynamic>? atributos =
        ficha['atributos'] is Map
            ? ficha['atributos'] as Map<String, dynamic>
            : null;
    final Map<String, dynamic>? carteira =
        ficha['carteira'] is Map
            ? ficha['carteira'] as Map<String, dynamic>
            : null;

    const Color backgroundColor = Color(0xFF121212);
    const Color accentColor = Color(0xFF1B5E20);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          ficha['nome'] ?? 'Detalhes da Ficha',
          style: const TextStyle(
            fontFamily: 'UncialAntiqua',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: accentColor, size: 36),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem da ficha
            Center(
              child: Image.asset(imagePath, height: 200, fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),
            // Informações básicas
            if (ficha['nome'] != null &&
                ficha['nome'].toString().trim().isNotEmpty)
              buildInfoRow("Nome", ficha['nome'].toString()),
            if (ficha['classe'] != null &&
                ficha['classe'].toString().trim().isNotEmpty)
              buildInfoRow("Classe", ficha['classe'].toString()),
            if (ficha['raça'] != null &&
                ficha['raça'].toString().trim().isNotEmpty)
              buildInfoRow("Raça", ficha['raça'].toString()),
            if (ficha['alinhamento'] != null &&
                ficha['alinhamento'].toString().trim().isNotEmpty)
              buildInfoRow("Alinhamento", ficha['alinhamento'].toString()),
            if (ficha['pontosExperiencia'] != null)
              buildInfoRow("XP", ficha['pontosExperiencia'].toString()),
            if (ficha['nomeJogador'] != null &&
                ficha['nomeJogador'].toString().trim().isNotEmpty)
              buildInfoRow("Nome do Jogador", ficha['nomeJogador'].toString()),
            if (ficha['antecedente'] != null &&
                ficha['antecedente'].toString().trim().isNotEmpty)
              buildInfoRow("Antecedente", ficha['antecedente'].toString()),
            if (ficha['bonusProficiência'] != null)
              buildInfoRow(
                "Bônus de Proficiência",
                ficha['bonusProficiência'].toString(),
              ),
            if (ficha['inspiração'] != null)
              buildInfoRow("Inspiração", ficha['inspiração'].toString()),
            if (ficha['classeArmadura'] != null)
              buildInfoRow(
                "Classe de Armadura",
                ficha['classeArmadura'].toString(),
              ),
            if (ficha['iniciativa'] != null)
              buildInfoRow("Iniciativa", ficha['iniciativa'].toString()),
            if (ficha['deslocamento'] != null)
              buildInfoRow("Deslocamento", ficha['deslocamento'].toString()),
            if (ficha['pontosVida'] != null)
              buildInfoRow("Pontos de Vida", ficha['pontosVida'].toString()),
            if (ficha['pontosVidaAtuais'] != null)
              buildInfoRow("PV Atuais", ficha['pontosVidaAtuais'].toString()),
            const SizedBox(height: 16),
            // Atributos
            if (atributos != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader("Atributos:"),
                  const SizedBox(height: 8),
                  if (atributos['força'] != null)
                    buildInfoRow("Força", atributos['força'].toString()),
                  if (atributos['inteligência'] != null)
                    buildInfoRow(
                      "Inteligência",
                      atributos['inteligência'].toString(),
                    ),
                  if (atributos['sabedoria'] != null)
                    buildInfoRow(
                      "Sabedoria",
                      atributos['sabedoria'].toString(),
                    ),
                  if (atributos['destreza'] != null)
                    buildInfoRow("Destreza", atributos['destreza'].toString()),
                  if (atributos['constituição'] != null)
                    buildInfoRow(
                      "Constituição",
                      atributos['constituição'].toString(),
                    ),
                  if (atributos['carisma'] != null)
                    buildInfoRow("Carisma", atributos['carisma'].toString()),
                ],
              ),
            const SizedBox(height: 16),
            if (ficha['idiomas'] != null &&
                ficha['idiomas'].toString().trim().isNotEmpty)
              buildInfoRow("Idiomas", ficha['idiomas'].toString()),
            if (ficha['inventarioGeral'] != null &&
                ficha['inventarioGeral'].toString().trim().isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader("Inventário Geral:"),
                  const SizedBox(height: 8),
                  buildInfoRow("", ficha['inventarioGeral'].toString()),
                ],
              ),
            if (ficha['inventarioArmas'] != null &&
                ficha['inventarioArmas'].toString().trim().isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader("Inventário de Armas:"),
                  const SizedBox(height: 8),
                  buildInfoRow("", ficha['inventarioArmas'].toString()),
                ],
              ),
            const SizedBox(height: 16),
            if (carteira != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildHeader("Carteira:"),
                  const SizedBox(height: 8),
                  if (carteira['PC'] != null)
                    buildInfoRow("PC", carteira['PC'].toString()),
                  if (carteira['PP'] != null)
                    buildInfoRow("PP", carteira['PP'].toString()),
                  if (carteira['PO'] != null)
                    buildInfoRow("PO", carteira['PO'].toString()),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
