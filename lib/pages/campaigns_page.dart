import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampaignsPage extends StatefulWidget {
  const CampaignsPage({Key? key}) : super(key: key);

  @override
  _CampaignsPageState createState() => _CampaignsPageState();
}

class _CampaignsPageState extends State<CampaignsPage> {
  List<dynamic> _allCampaigns = [];
  List<dynamic> _filteredCampaigns = [];
  String _selectedDifficulty = 'Todos';
  String _selectedGroupMin = 'Todos';

  Future<List<dynamic>> _loadCampaigns() async {
    final jsonString = await rootBundle.loadString('assets/campanhas.json');
    final List<dynamic> data = json.decode(jsonString);
    return data;
  }

  @override
  void initState() {
    super.initState();
    _loadCampaigns().then((campaigns) {
      setState(() {
        _allCampaigns = campaigns;
        _filteredCampaigns = campaigns;
      });
    });
  }

  void _filterCampaigns() {
    setState(() {
      _filteredCampaigns =
          _allCampaigns.where((campaign) {
            bool difficultyMatches =
                _selectedDifficulty == 'Todos' ||
                campaign['dificuldade'].toString() == _selectedDifficulty;
            bool groupMatches =
                _selectedGroupMin == 'Todos' ||
                campaign['grupoMinimo'].toString() == _selectedGroupMin;
            return difficultyMatches && groupMatches;
          }).toList();
    });
  }

  // Função para determinar a cor da dificuldade para o valor
  Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
        return Color(0xFF66BB6A); // Verde claro
      case 'médio':
        return Color(0xFFFFA000); // Amarelo/laranja
      case 'difícil':
      case 'alto':
        return Color(0xFFEF5350); // Vermelho
      default:
        return Colors.white;
    }
  }

  List<String> _getUniqueValues(String key) {
    Set<String> values = {};
    for (var campaign in _allCampaigns) {
      if (campaign[key] != null) {
        values.add(campaign[key].toString());
      }
    }
    return values.toList();
  }

  Widget _buildDropdown(
    String label,
    String selectedValue,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    List<DropdownMenuItem<String>> menuItems = [];
    menuItems.add(const DropdownMenuItem(value: 'Todos', child: Text('Todos')));
    for (var item in items) {
      menuItems.add(DropdownMenuItem(value: item, child: Text(item)));
    }
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<String>(
          dropdownColor: const Color(0xFF424242),
          value: selectedValue,
          items: menuItems,
          onChanged: onChanged,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = const Color(
      0xFF1B5E20,
    ); // Verde usado na estética

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36),
          color: accentColor, // Botão de voltar em verde
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Campanhas',
          style: TextStyle(
            fontFamily: 'UncialAntiqua',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Seção de filtros
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildDropdown(
                    'Dificuldade:',
                    _selectedDifficulty,
                    _getUniqueValues('dificuldade'),
                    (value) {
                      setState(() {
                        _selectedDifficulty = value!;
                        _filterCampaigns();
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    'Grupo Mínimo:',
                    _selectedGroupMin,
                    _getUniqueValues('grupoMinimo'),
                    (value) {
                      setState(() {
                        _selectedGroupMin = value!;
                        _filterCampaigns();
                      });
                    },
                  ),
                ],
              ),
            ),
            // Lista de campanhas filtradas
            Expanded(
              child:
                  _allCampaigns.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _filteredCampaigns.length,
                        itemBuilder: (context, index) {
                          final campaign = _filteredCampaigns[index];
                          final String diff =
                              campaign['dificuldade'].toString();
                          final Color diffColor = getDifficultyColor(diff);

                          return Card(
                            color: const Color(0xFF424242).withOpacity(0.9),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/campanhaDetalhe',
                                  arguments: campaign,
                                );
                              },
                              contentPadding: const EdgeInsets.all(16),
                              leading: Image.asset(
                                campaign['imagem'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                campaign['titulo'],
                                style: TextStyle(
                                  fontFamily: 'UncialAntiqua',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Dificuldade: ',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: diff,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: diffColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Grupo Mínimo: ${campaign['grupoMinimo']} participantes',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
