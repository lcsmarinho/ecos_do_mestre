import 'package:flutter/material.dart';

class MagiasDetailPage extends StatelessWidget {
  const MagiasDetailPage({super.key});

  // Widget para título formatado com sombra verde
  Widget buildFormattedTitle(String text, {double fontSize = 24}) {
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

  // Widget para exibir uma linha de detalhe
  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontFamily: 'UncialAntiqua',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final magia =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Color backgroundColor = const Color(0xFF121212);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36),
          color: const Color(0xFF1B5E20),
          onPressed: () => Navigator.pop(context),
        ),
        title: buildFormattedTitle(
          magia['nome'] ?? 'Detalhes da Magia',
          fontSize: 24,
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
                Center(
                  child: Image.asset(
                    'assets/images/ecos-logo.png',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                buildDetailRow('Nome', magia['nome'] ?? 'N/A'),
                buildDetailRow('Classe', magia['classe'] ?? 'N/A'),
                buildDetailRow('Tipo', magia['tipo'] ?? 'N/A'),
                buildDetailRow(
                  'Tempo de Conjuração',
                  magia['tempoConjuracao'] ?? 'N/A',
                ),
                buildDetailRow('Alcance', magia['alcance'] ?? 'N/A'),
                buildDetailRow('Componentes', magia['componentes'] ?? 'N/A'),
                buildDetailRow('Duração', magia['duracao'] ?? 'N/A'),
                const SizedBox(height: 16),
                const Text(
                  'Descrição:',
                  style: TextStyle(
                    fontFamily: 'UncialAntiqua',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  magia['descricao'] ?? 'N/A',
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
