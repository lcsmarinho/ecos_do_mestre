import 'package:flutter/material.dart';

class CampaignDetailPage extends StatelessWidget {
  const CampaignDetailPage({Key? key}) : super(key: key);

  // Widget para formatar títulos com sombra verde (estilo dark fantasy)
  Widget buildFormattedTitle(String text, {double fontSize = 20}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'UncialAntiqua',
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: const [
          Shadow(color: Color(0xFF1B5E20), offset: Offset(1, 1), blurRadius: 2),
        ],
      ),
    );
  }

  // Função para processar o corpo do texto e criar TextSpan com formatação
  List<TextSpan> _parseBodyText(String text) {
    final RegExp regExp = RegExp(r'~(.*?)~');
    List<TextSpan> spans = [];
    int start = 0;

    for (final match in regExp.allMatches(text)) {
      // Adiciona o texto que está antes dos delimitadores "~"
      if (match.start > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, match.start),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }
      // Adiciona o texto entre "~" formatado (itálico, negrito, cor verde e sem sombras)
      spans.add(
        TextSpan(
          text: match.group(1),
          style: const TextStyle(
            fontSize: 18,
            color: Color(0xFF1B5E20),
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
      start = match.end;
    }
    // Adiciona o restante do texto, se houver
    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    // Alteração importante: trata argumentos nulos para evitar o erro de cast
    final campaign =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
        {};

    final Color backgroundColor = const Color(0xFF121212);
    final Color lightGreen = const Color(0xFF4CAF50);
    final String corpo = campaign['corpo'] ?? '';
    final List<TextSpan> bodySpans = _parseBodyText(corpo);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Color(0xFF1B5E20), size: 36),
        title: Text(
          campaign['titulo'] ?? 'Detalhes da Campanha',
          style: const TextStyle(
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
                // Título formatado
                buildFormattedTitle(campaign['titulo'] ?? '', fontSize: 20),
                const SizedBox(height: 16),
                // Corpo do texto utilizando RichText
                RichText(text: TextSpan(children: bodySpans)),
                const SizedBox(height: 16),
                // Localidade
                Text(
                  'Localidade:',
                  style: TextStyle(
                    color: lightGreen,
                    fontFamily: 'UncialAntiqua',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  campaign['localidade'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  campaign['dificuldade'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 16,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${campaign['grupoMinimo'] ?? 'N/A'} participantes',
                  style: const TextStyle(
                    fontSize: 16,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  (campaign['npcs'] as List<dynamic>? ?? []).join(', '),
                  style: const TextStyle(
                    fontSize: 16,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  (campaign['monstros'] as List<dynamic>? ?? []).join(', '),
                  style: const TextStyle(
                    fontSize: 16,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  (campaign['chefões'] as List<dynamic>? ?? []).join(', '),
                  style: const TextStyle(
                    fontSize: 16,
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
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  (campaign['recompensas'] as List<dynamic>? ?? []).join(', '),
                  style: const TextStyle(
                    fontSize: 16,
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
