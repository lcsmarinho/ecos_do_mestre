import 'package:flutter/material.dart';

class ItensDetailPage extends StatelessWidget {
  const ItensDetailPage({super.key});

  // Função para determinar a cor da raridade
  Color getRarityColor(String rarity) {
    switch (rarity.toLowerCase()) {
      case 'comum':
        return Colors.grey;
      case 'incomum':
        return Colors.lightBlueAccent;
      case 'raro':
        return Colors.purple;
      case 'mítico':
        return Colors.amber;
      default:
        return Colors.white;
    }
  }

  // Widget para título formatado com sombra verde (estilo dark fantasy)
  Widget buildFormattedTitle(String text, {double fontSize = 24}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'UncialAntiqua',
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Colors.white,
        shadows: [
          const Shadow(
            color: Color(0xFF1B5E20),
            offset: Offset(1, 1),
            blurRadius: 2,
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para exibir uma linha de detalhe (rótulo e valor)
  // Permite customizar a cor do valor (por exemplo, para a raridade)
  Widget buildDetailRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontFamily: 'UncialAntiqua',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4CAF50),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: valueColor ?? Colors.white,
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
    final item =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Color backgroundColor = const Color(0xFF121212);

    // Recupera a raridade para aplicar a cor definida
    final rarity = item['raridade']?.toString() ?? 'N/A';
    final rarityColor = getRarityColor(rarity);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: const Color(0xFF1B5E20), size: 36),
        // Exibe o nome do item com a formatação de título (branco, sombra verde, UncialAntiqua)
        title: buildFormattedTitle(item['nome'] ?? 'Detalhes do Item'),
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
                    item['foto'] ?? 'assets/images/ecos-logo.png',
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                buildDetailRow('Nome', item['nome'] ?? 'N/A'),
                buildDetailRow('Tipo', item['tipo'] ?? 'N/A'),
                // Aqui, o valor de raridade é colorido conforme a regra
                buildDetailRow('Raridade', rarity, valueColor: rarityColor),
                buildDetailRow('Descrição', item['descricao'] ?? 'N/A'),
                buildDetailRow('Efeito', item['efeito'] ?? 'N/A'),
                buildDetailRow('Dano', item['dano'] ?? 'N/A'),
                buildDetailRow('Cura', item['cura'] ?? 'N/A'),
                if (item['buffDebuff'] != null)
                  buildDetailRow('Buff/Debuff', item['buffDebuff'].toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
