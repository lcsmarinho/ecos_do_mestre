import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignDetailPage extends StatefulWidget {
  const CampaignDetailPage({super.key});

  @override
  _CampaignDetailPageState createState() => _CampaignDetailPageState();
}

class _CampaignDetailPageState extends State<CampaignDetailPage> {
  bool isDone = false;

  @override
  void initState() {
    super.initState();
    // Carrega o status assim que o contexto estiver disponível.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDoneStatus();
    });
  }

  Future<void> _loadDoneStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final campaign =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    bool done = prefs.getBool("campaign_done_${campaign['id']}") ?? false;
    setState(() {
      isDone = done;
    });
  }

  Future<void> _toggleDoneStatus(Map<String, dynamic> campaign) async {
    final prefs = await SharedPreferences.getInstance();
    bool current = prefs.getBool("campaign_done_${campaign['id']}") ?? false;
    await prefs.setBool("campaign_done_${campaign['id']}", !current);
    setState(() {
      isDone = !current;
    });
  }

  // Função para formatar títulos com sombra verde
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

  @override
  Widget build(BuildContext context) {
    final campaign =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Color backgroundColor = const Color(0xFF121212);
    final Color lightGreen = const Color(0xFF4CAF50);

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
                // Título formatado com sombra verde
                buildFormattedTitle(campaign['titulo'] ?? '', fontSize: 20),
                const SizedBox(height: 16),
                // Corpo do texto
                Text(
                  campaign['corpo'] ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                // NPCs, Monstros, Chefões e Recompensas
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
                const SizedBox(height: 24),
                // Botão para marcar/desmarcar como feita
                Center(
                  child: ElevatedButton(
                    onPressed: () => _toggleDoneStatus(campaign),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDone ? Colors.red : const Color(0xFF1B5E20),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      isDone ? 'Desmarcar como feita' : 'Marcar como feita',
                      style: const TextStyle(
                        fontFamily: 'UncialAntiqua',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
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
