import 'package:flutter/material.dart';

class CampaignDetailPage extends StatelessWidget {
  const CampaignDetailPage({Key? key}) : super(key: key);

  // Função auxiliar para formatar títulos com sombra verde (estilo dark fantasy)
  Widget buildFormattedTitle(String text, {double fontSize = 20}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'UncialAntiqua',
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          Shadow(
            color: const Color(0xFF1B5E20),
            offset: const Offset(1, 1),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Obtém os dados da campanha passados via argumento
    final campaign =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Color accentColor = const Color(0xFF1B5E20);
    final Color backgroundColor = const Color(0xFF121212);
    final Color lightGreen = const Color(0xFF4CAF50);
    const double labelFontSize = 16;
    const double valueFontSize = 16;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: accentColor, size: 36),
        title: Text(
          campaign['titulo'] ?? 'Detalhes da Campanha',
          style: TextStyle(
            fontFamily: 'UncialAntiqua',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagem da campanha
                Center(
                  child: Image.asset(
                    campaign['imagem'] ?? 'assets/images/ecos-logo.png',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                // Título repetido com formatação (texto branco com sombra verde)
                buildFormattedTitle(campaign['titulo'] ?? '', fontSize: 20),
                const SizedBox(height: 16),
                // Corpo do texto da campanha
                Text(
                  campaign['corpo'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Localidade, formatada e posicionada acima da dificuldade
                Text(
                  'Localidade:',
                  style: TextStyle(
                    color: lightGreen,
                    fontFamily: 'UncialAntiqua',
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  campaign['localidade'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: valueFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                // Dificuldade
                Text(
                  'Dificuldade:',
                  style: TextStyle(
                    color: lightGreen,
                    fontFamily: 'UncialAntiqua',
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  campaign['dificuldade'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: valueFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Grupo Mínimo
                Text(
                  'Grupo Mínimo:',
                  style: TextStyle(
                    color: lightGreen,
                    fontFamily: 'UncialAntiqua',
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${campaign['grupoMinimo'] ?? 'N/A'} participantes',
                  style: const TextStyle(
                    fontSize: valueFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                // NPCs
                Text(
                  'NPCs:',
                  style: TextStyle(
                    color: lightGreen,
                    fontFamily: 'UncialAntiqua',
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  (campaign['npcs'] as List<dynamic>? ?? []).join(', '),
                  style: const TextStyle(
                    fontSize: valueFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Monstros
                Text(
                  'Monstros:',
                  style: TextStyle(
                    color: lightGreen,
                    fontFamily: 'UncialAntiqua',
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  (campaign['monstros'] as List<dynamic>? ?? []).join(', '),
                  style: const TextStyle(
                    fontSize: valueFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Chefões
                Text(
                  'Chefões:',
                  style: TextStyle(
                    color: lightGreen,
                    fontFamily: 'UncialAntiqua',
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  (campaign['chefões'] as List<dynamic>? ?? []).join(', '),
                  style: const TextStyle(
                    fontSize: valueFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Recompensas
                Text(
                  'Recompensas:',
                  style: TextStyle(
                    color: lightGreen,
                    fontFamily: 'UncialAntiqua',
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  (campaign['recompensas'] as List<dynamic>? ?? []).join(', '),
                  style: const TextStyle(
                    fontSize: valueFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
