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

  // Função auxiliar para determinar a cor da dificuldade
  Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
        return const Color(0xFF66BB6A);
      case 'médio':
        return const Color(0xFFFFA000);
      case 'difícil':
      case 'alto':
        return const Color(0xFFEF5350);
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verifica se foi passado o parâmetro de seleção no ModalRoute
    bool selectionMode = false;
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null &&
        args is Map<String, dynamic> &&
        args['selectionMode'] == true) {
      selectionMode = true;
    }

    final Color accentColor = const Color(0xFF1B5E20);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36),
          color: accentColor,
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
            // Aqui você pode incluir os filtros (Dropdowns) se desejar.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Exemplo: Dropdown para dificuldade (se já implementado)
                  Row(
                    children: [
                      Text(
                        'Dificuldade: ',
                        style: const TextStyle(
                          fontFamily: 'UncialAntiqua',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        dropdownColor: const Color(0xFF424242),
                        value: _selectedDifficulty,
                        items:
                            <String>['Todos', 'Fácil', 'Médio', 'Difícil']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDifficulty = value!;
                            _filterCampaigns();
                          });
                        },
                        style: const TextStyle(
                          fontFamily: 'UncialAntiqua',
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Grupo Mínimo: ',
                        style: const TextStyle(
                          fontFamily: 'UncialAntiqua',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        dropdownColor: const Color(0xFF424242),
                        value: _selectedGroupMin,
                        items:
                            <String>['Todos', '1', '2', '3', '4', '5']
                                .map(
                                  (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGroupMin = value!;
                            _filterCampaigns();
                          });
                        },
                        style: const TextStyle(
                          fontFamily: 'UncialAntiqua',
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  _allCampaigns.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _filteredCampaigns.length,
                        itemBuilder: (context, index) {
                          final campaign = _filteredCampaigns[index];
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
                              contentPadding: const EdgeInsets.all(16),
                              leading: Image.asset(
                                campaign['imagem'] ??
                                    'assets/images/ecos-logo.png',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                campaign['titulo'] ?? 'Sem Nome',
                                style: const TextStyle(
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
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white70,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              campaign['dificuldade'] ?? 'N/A',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: getDifficultyColor(
                                              campaign['dificuldade'] ?? '',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'Grupo Mínimo: ${campaign['grupoMinimo'] ?? 'N/A'} participantes',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                if (selectionMode) {
                                  // Em modo seleção, retorna a campanha selecionada para a página de aventura.
                                  Navigator.pop(context, campaign);
                                } else {
                                  // Modo normal: navega para a página de detalhes.
                                  Navigator.pushNamed(
                                    context,
                                    '/campanhaDetalhe',
                                    arguments: campaign,
                                  );
                                }
                              },
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
