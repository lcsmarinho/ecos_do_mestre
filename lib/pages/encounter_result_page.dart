import 'package:flutter/material.dart';

class EncounterResultPage extends StatelessWidget {
  const EncounterResultPage({super.key});

  // Função genérica para criar cabeçalhos formatados
  Widget buildHeader(
    String text, {
    required Color textColor,
    required Color shadowColor,
    double fontSize = 24,
  }) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'UncialAntiqua',
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: textColor,
        shadows: [
          Shadow(color: shadowColor, offset: const Offset(1, 1), blurRadius: 2),
        ],
      ),
    );
  }

  // Função para extrair parte de dano do primeiro ataque, se possível.
  // Procura a substring após "Dano:".
  String extractDamage(String attack) {
    String lowerAttack = attack.toLowerCase();
    int index = lowerAttack.indexOf("dano:");
    if (index != -1) {
      return attack.substring(index).trim();
    }
    return attack;
  }

  // Widget para exibir informações básicas de um monstro
  Widget buildMonsterCard(Map<String, dynamic> monster) {
    String name = monster['nome'] ?? 'Sem Nome';
    String vida = monster['pontosVida'] ?? 'N/A';
    String ca = monster['classeArmadura'] ?? 'N/A';
    String damage = 'N/A';
    if (monster['ataques'] != null &&
        monster['ataques'] is List &&
        (monster['ataques'] as List).isNotEmpty) {
      // Tenta extrair a parte de dano do primeiro ataque
      damage = extractDamage(monster['ataques'][0]);
    }
    return Card(
      color: const Color(0xFF424242).withOpacity(0.9),
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nome do monstro em destaque com fonte estilizada e sombra verde
            Text(
              name,
              style: TextStyle(
                fontFamily: 'UncialAntiqua',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: const [
                  Shadow(
                    color: Color(0xFF1B5E20),
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Vida: $vida',
              style: const TextStyle(
                fontFamily: 'UncialAntiqua',
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'CA: $ca',
              style: const TextStyle(
                fontFamily: 'UncialAntiqua',
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Dano: $damage',
              style: const TextStyle(
                fontFamily: 'UncialAntiqua',
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> result =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final List<dynamic> monsters = result['monstros'] ?? [];
    final List<dynamic> items = result['itens'] ?? [];
    final String encounterDifficulty = result['dificuldade'] ?? '';
    final int monsterQty = result['qtdMonstros'] ?? 0;
    final String rewardRarity = result['raridade'] ?? '';
    final int itemQty = result['qtdItens'] ?? 0;

    final Color backgroundColor = const Color(0xFF121212);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36),
          color: const Color(0xFF1B5E20),
          onPressed: () => Navigator.pop(context),
        ),
        // Cabeçalho "Encontro Gerado" em vermelho com sombra branca
        title: buildHeader(
          'Encontro Gerado',
          textColor: Colors.red,
          shadowColor: Colors.white,
          fontSize: 24,
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Configuração do encontro
              buildHeader(
                'Configuração do Encontro',
                textColor: const Color(0xFF1B5E20),
                shadowColor: Colors.black,
                fontSize: 20,
              ),
              const SizedBox(height: 8),
              Text(
                'Dificuldade: $encounterDifficulty',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              Text(
                'Quantidade de Monstros: $monsterQty',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              Text(
                'Raridade da Recompensa: $rewardRarity',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              Text(
                'Quantidade de Itens: $itemQty',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),
              const Divider(color: Colors.white38),
              // Seção de Monstros Selecionados (título em verde)
              buildHeader(
                'Monstros Selecionados',
                textColor: const Color(0xFF1B5E20),
                shadowColor: Colors.black,
                fontSize: 20,
              ),
              const SizedBox(height: 8),
              // Para cada monstro, exibe informações básicas
              for (var monster in monsters) buildMonsterCard(monster),
              const Divider(color: Colors.white38),
              // Seção de Itens de Recompensa (título em verde)
              buildHeader(
                'Itens de Recompensa',
                textColor: const Color(0xFF1B5E20),
                shadowColor: Colors.black,
                fontSize: 20,
              ),
              const SizedBox(height: 8),
              for (var item in items)
                Text(
                  item['nome'] ?? 'Sem Nome',
                  style: const TextStyle(
                    fontFamily: 'UncialAntiqua',
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
