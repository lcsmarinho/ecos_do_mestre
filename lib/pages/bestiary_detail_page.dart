import 'package:flutter/material.dart';

class BestiaryDetailPage extends StatelessWidget {
  const BestiaryDetailPage({super.key});

  // Função auxiliar para formatar ataques e ações com sombra verde no nome e dano em vermelho
  Widget buildFormattedText(String text) {
    // Divide o texto em duas partes pelo primeiro ":"
    final parts = text.split(':');
    if (parts.length > 1) {
      final attackName = "${parts[0]}:";
      final attackDetail = parts.sublist(1).join(':').trim();

      // Procura pela palavra "dano:" (case-insensitive) no detalhe
      final lowerDetail = attackDetail.toLowerCase();
      if (lowerDetail.contains("dano:")) {
        final index = lowerDetail.indexOf("dano:");
        final description = attackDetail.substring(0, index).trim();
        final damage = attackDetail.substring(index).trim();

        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$attackName ",
                style: TextStyle(
                  fontFamily: 'UncialAntiqua',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Color(0xFF1B5E20),
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              TextSpan(
                text: "$description ",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: damage,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFEF5350),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      } else {
        return RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "$attackName ",
                style: TextStyle(
                  fontFamily: 'UncialAntiqua',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Color(0xFF1B5E20),
                      offset: Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
              TextSpan(
                text: attackDetail,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }
    } else {
      return Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtém os dados do monstro passados via argumento
    final monster =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Color accentColor = Color(0xFF1B5E20); // Verde usado na estética
    final Color backgroundColor = Color(0xFF121212);
    final Color lightGreen = Color(0xFF4CAF50); // Para rótulos (chaves)
    const double labelFontSize = 16;
    const double valueFontSize = 16;

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: accentColor, size: 36),
        title: Text(
          monster['nome'] ?? 'Detalhes do Monstro',
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
                // Imagem do monstro (padrão ecos-logo.png)
                Center(
                  child: Image.asset(
                    monster['foto'] ?? 'assets/images/ecos-logo.png',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 24),
                // Informações básicas
                Text(
                  monster['nome'] ?? '',
                  style: TextStyle(
                    color: lightGreen,
                    fontFamily: 'UncialAntiqua',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Tipo: ${monster['tipo'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Alinhamento: ${monster['alinhamento'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                // Atributos básicos
                Text(
                  'Classe de Armadura: ${monster['classeArmadura'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Pontos de Vida: ${monster['pontosVida'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Deslocamento: ${monster['deslocamento'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                // Atributos
                Text(
                  'Atributos:',
                  style: TextStyle(
                    color: lightGreen,
                    fontFamily: 'UncialAntiqua',
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Força: ${monster['forca'] ?? 'N/A'} | Destreza: ${monster['destreza'] ?? 'N/A'} | Constituição: ${monster['constituição'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: valueFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Inteligência: ${monster['inteligencia'] ?? 'N/A'} | Sabedoria: ${monster['sabedoria'] ?? 'N/A'} | Carisma: ${monster['carisma'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: valueFontSize,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                // Perícias, Sentidos, Idiomas, ND
                Text(
                  'Perícias: ${monster['pericias'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Sentidos: ${monster['sentidos'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Idiomas: ${monster['idiomas'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Nível de Desafio: ${monster['nivelDesafio'] ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                // Ataques (lista) com formatação especial
                Text(
                  'Ataques:',
                  style: TextStyle(
                    color: lightGreen,
                    fontFamily: 'UncialAntiqua',
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                for (var attack in (monster['ataques'] as List<dynamic>? ?? []))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: buildFormattedText(attack),
                  ),
                SizedBox(height: 16),
                // Ações (lista) com formatação especial
                Text(
                  'Ações:',
                  style: TextStyle(
                    color: lightGreen,
                    fontFamily: 'UncialAntiqua',
                    fontSize: labelFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                for (var action in (monster['ações'] as List<dynamic>? ?? []))
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: buildFormattedText(action),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
