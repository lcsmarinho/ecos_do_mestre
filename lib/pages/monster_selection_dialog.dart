import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MonsterSelectionDialog extends StatefulWidget {
  const MonsterSelectionDialog({Key? key}) : super(key: key);

  @override
  _MonsterSelectionDialogState createState() => _MonsterSelectionDialogState();
}

class _MonsterSelectionDialogState extends State<MonsterSelectionDialog> {
  List<dynamic> _allMonsters = [];
  List<dynamic> _filteredMonsters = [];
  String _searchQuery = '';
  String _selectedChallengeLevel = 'Todos';
  List<String> _challengeLevelOptions = ['Todos'];

  @override
  void initState() {
    super.initState();
    _loadMonsters();
  }

  Future<void> _loadMonsters() async {
    final jsonString = await rootBundle.loadString('assets/monstros.json');
    final List<dynamic> monsters = json.decode(jsonString);
    // Extrai os níveis de desafio existentes
    final levels =
        monsters
            .map((monster) => monster['nivelDesafio']?.toString() ?? '')
            .where((nivel) => nivel.isNotEmpty)
            .toSet()
            .toList();
    levels.sort();
    setState(() {
      _allMonsters = monsters;
      _filteredMonsters = monsters;
      _challengeLevelOptions = ['Todos', ...levels];
    });
  }

  void _filterMonsters() {
    setState(() {
      _filteredMonsters =
          _allMonsters.where((monster) {
            final nome = monster['nome']?.toString().toLowerCase() ?? '';
            final searchOk = nome.contains(_searchQuery.toLowerCase());
            final nivel = monster['nivelDesafio']?.toString() ?? '';
            final levelOk =
                _selectedChallengeLevel == 'Todos' ||
                nivel == _selectedChallengeLevel;
            return searchOk && levelOk;
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
              'Selecionar Monstro',
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
                _filterMonsters();
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Filtrar por nome...',
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
            // Dropdown para filtrar por nível de desafio
            Row(
              children: [
                const Text(
                  'Nível de Desafio: ',
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
                  value: _selectedChallengeLevel,
                  items:
                      _challengeLevelOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedChallengeLevel = value!;
                      _filterMonsters();
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
                  _allMonsters.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _filteredMonsters.length,
                        itemBuilder: (context, index) {
                          final monster = _filteredMonsters[index];
                          return Card(
                            color: const Color(0xFF424242).withOpacity(0.9),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                monster['nome'] ?? 'Sem Nome',
                                style: const TextStyle(
                                  fontFamily: 'UncialAntiqua',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                'Nível de Desafio: ${monster['nivelDesafio'] ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context, monster);
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
