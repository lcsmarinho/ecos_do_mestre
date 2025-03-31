import 'package:flutter/material.dart';

class CampaignDetailPage extends StatelessWidget {
  const CampaignDetailPage({Key? key}) : super(key: key);

  // Função para determinar a cor da dificuldade
  Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
        return Color(0xFF66BB6A); // Verde
      case 'médio':
        return Color(0xFFFFA000); // Amarelo/laranja
      case 'difícil':
      case 'alto':
        return Color(0xFFEF5350); // Vermelho
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtém os dados da campanha passados via argumento
    final campaign =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Color accentColor = Color(
      0xFF1B5E20,
    ); // Tom de verde usado na estética
    final Color backgroundColor = Color(0xFF121212);
    final Color lightGreen = Color(
      0xFF4CAF50,
    ); // Cor usada para os rótulos (chaves)
    const double labelFontSize = 16;
    const double valueFontSize = 16;

    final String difficultyText = (campaign['dificuldade'] ?? '').toString();
    final Color difficultyColor = getDifficultyColor(difficultyText);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: accentColor, // Botão de voltar em verde
          size: 36,
        ),
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
                SizedBox(height: 24),
                // Título repetido (chave)
                Text(
                  campaign['titulo'] ?? '',
                  style: TextStyle(
                    color: lightGreen,
                    fontFamily: 'UncialAntiqua',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                // Corpo do texto da campanha
                Text(
                  campaign['corpo'] ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                // Dificuldade e Grupo Mínimo (em fonte menor)
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
                  difficultyText,
                  style: TextStyle(
                    fontSize: valueFontSize,
                    color: difficultyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
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
                  style: TextStyle(
                    fontSize: valueFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
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
                  (campaign['npcs'] as List<dynamic>).join(', '),
                  style: TextStyle(
                    fontSize: valueFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
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
                  (campaign['monstros'] as List<dynamic>).join(', '),
                  style: TextStyle(
                    fontSize: valueFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
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
                  (campaign['chefoes'] as List<dynamic>).join(', '),
                  style: TextStyle(
                    fontSize: valueFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
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
                  (campaign['recompensas'] as List<dynamic>).join(', '),
                  style: TextStyle(
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
