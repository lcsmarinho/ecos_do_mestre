import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CampaignSelectionDialog extends StatefulWidget {
  const CampaignSelectionDialog({Key? key}) : super(key: key);

  @override
  _CampaignSelectionDialogState createState() =>
      _CampaignSelectionDialogState();
}

class _CampaignSelectionDialogState extends State<CampaignSelectionDialog> {
  List<dynamic> _allCampaigns = [];
  List<dynamic> _filteredCampaigns = [];
  String _searchQuery = '';
  String _selectedDifficulty = 'Todos';
  final List<String> _difficultyOptions = [
    'Todos',
    'Fácil',
    'Médio',
    'Difícil',
  ];

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  Future<void> _loadCampaigns() async {
    final jsonString = await rootBundle.loadString('assets/campanhas.json');
    final List<dynamic> campaigns = json.decode(jsonString);
    setState(() {
      _allCampaigns = campaigns;
      _filteredCampaigns = campaigns;
    });
  }

  void _filterCampaigns() {
    setState(() {
      _filteredCampaigns =
          _allCampaigns.where((campaign) {
            final title = campaign['titulo']?.toString().toLowerCase() ?? '';
            final searchOk = title.contains(_searchQuery.toLowerCase());
            final difficulty = campaign['dificuldade']?.toString() ?? '';
            final difficultyOk =
                _selectedDifficulty == 'Todos' ||
                difficulty == _selectedDifficulty;
            return searchOk && difficultyOk;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF121212),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Selecionar Campanha',
              style: TextStyle(
                fontFamily: 'UncialAntiqua',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Campo de busca
            TextField(
              onChanged: (value) {
                _searchQuery = value;
                _filterCampaigns();
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Filtrar por título...',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF424242),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Dropdown para filtrar por dificuldade
            Row(
              children: [
                const Text(
                  'Dificuldade: ',
                  style: TextStyle(
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
                      _difficultyOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
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
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                campaign['titulo'] ?? 'Sem Nome',
                                style: const TextStyle(
                                  fontFamily: 'UncialAntiqua',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dificuldade: ${campaign['dificuldade'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'Grupo Mínimo: ${campaign['grupoMinimo'] ?? 'N/A'} participantes',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Retorna a campanha selecionada
                                Navigator.pop(context, campaign);
                              },
                            ),
                          );
                        },
                      ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E20),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  fontFamily: 'UncialAntiqua',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
