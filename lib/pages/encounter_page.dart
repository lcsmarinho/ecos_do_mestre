import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EncounterPage extends StatefulWidget {
  const EncounterPage({super.key});

  @override
  _EncounterPageState createState() => _EncounterPageState();
}

class _EncounterPageState extends State<EncounterPage> {
  final Random _random = Random();
  List<dynamic> _allMonsters = [];
  List<dynamic> _allItems = [];
  List<dynamic> _savedEncounters = [];

  // Configurações do encontro
  String _selectedEncounterDifficulty = 'Fácil'; // Fácil, Médio, Difícil
  String _selectedMonsterQty = 'Aleatório'; // ou número em string
  String _selectedRewardRarity = 'Comum'; // Comum, Incomum, Raro, Mítico
  String _selectedItemQty = 'Aleatório'; // ou número

  @override
  void initState() {
    super.initState();
    _loadMonsters();
    _loadItems();
    _loadSavedEncounters();
  }

  Future<void> _loadMonsters() async {
    final jsonString = await rootBundle.loadString('assets/monstros.json');
    setState(() {
      _allMonsters = json.decode(jsonString);
    });
  }

  Future<void> _loadItems() async {
    final jsonString = await rootBundle.loadString('assets/itens.json');
    setState(() {
      _allItems = json.decode(jsonString);
    });
  }

  Future<void> _loadSavedEncounters() async {
    final prefs = await SharedPreferences.getInstance();
    String? saved = prefs.getString('saved_encounters');
    if (saved != null) {
      setState(() {
        _savedEncounters = json.decode(saved);
      });
    }
  }

  Future<void> _saveEncounters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_encounters', json.encode(_savedEncounters));
  }

  Future<void> _saveEncounter(Map<String, dynamic> encounter) async {
    setState(() {
      _savedEncounters.add(encounter);
    });
    await _saveEncounters();
  }

  Future<void> _deleteEncounter(int index) async {
    setState(() {
      _savedEncounters.removeAt(index);
    });
    await _saveEncounters();
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                backgroundColor: const Color(0xFF121212),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFF1B5E20), width: 2),
                ),
                title: const Text(
                  'Confirmar Exclusão',
                  style: TextStyle(
                    fontFamily: 'UncialAntiqua',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                content: const Text(
                  'Deseja realmente excluir este encontro?',
                  style: TextStyle(
                    fontFamily: 'UncialAntiqua',
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        fontFamily: 'UncialAntiqua',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Excluir',
                      style: TextStyle(
                        fontFamily: 'UncialAntiqua',
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
        ) ??
        false;
  }

  double parseND(String nd) {
    nd = nd.trim();
    if (nd.contains('/')) {
      var parts = nd.split('/');
      if (parts.length == 2) {
        double num = double.tryParse(parts[0]) ?? 0;
        double denom = double.tryParse(parts[1]) ?? 1;
        return num / denom;
      }
    }
    return double.tryParse(nd) ?? 0;
  }

  List<dynamic> _filterMonstersByDifficulty() {
    return _allMonsters.where((monster) {
      double nd = parseND(monster['nivelDesafio'].toString());
      if (_selectedEncounterDifficulty == 'Fácil') {
        return nd <= 1;
      } else if (_selectedEncounterDifficulty == 'Médio') {
        return nd > 1 && nd <= 4;
      } else if (_selectedEncounterDifficulty == 'Difícil') {
        return nd > 4;
      }
      return false;
    }).toList();
  }

  List<dynamic> _filterItemsByRarity() {
    return _allItems.where((item) {
      return item['raridade'].toString().toLowerCase() ==
          _selectedRewardRarity.toLowerCase();
    }).toList();
  }

  int getMaxMonsters() {
    if (_selectedEncounterDifficulty == 'Fácil') return 4;
    if (_selectedEncounterDifficulty == 'Médio') return 3;
    if (_selectedEncounterDifficulty == 'Difícil') return 2;
    return 1;
  }

  int getMaxItems() {
    switch (_selectedRewardRarity.toLowerCase()) {
      case 'comum':
        return 4;
      case 'incomum':
        return 3;
      case 'raro':
        return 2;
      case 'mítico':
        return 1;
      default:
        return 1;
    }
  }

  Widget _buildDropdown(
    String label,
    String currentValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontFamily: 'UncialAntiqua',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButton<String>(
              isExpanded: true,
              dropdownColor: const Color(0xFF424242),
              value: currentValue,
              items:
                  options
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
              onChanged: onChanged,
              style: const TextStyle(
                fontFamily: 'UncialAntiqua',
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _generateEncounter() {
    List<dynamic> filteredMonsters = _filterMonstersByDifficulty();
    int maxMonsters = getMaxMonsters();
    int monsterQty;
    if (_selectedMonsterQty == 'Aleatório') {
      monsterQty = _random.nextInt(maxMonsters) + 1;
    } else {
      monsterQty = int.tryParse(_selectedMonsterQty) ?? 1;
    }
    filteredMonsters.shuffle(_random);
    List<dynamic> selectedMonsters = filteredMonsters.take(monsterQty).toList();

    List<dynamic> filteredItems = _filterItemsByRarity();
    int maxItems = getMaxItems();
    int itemQty;
    if (_selectedItemQty == 'Aleatório') {
      itemQty = _random.nextInt(maxItems) + 1;
    } else {
      itemQty = int.tryParse(_selectedItemQty) ?? 1;
    }
    filteredItems.shuffle(_random);
    List<dynamic> selectedItems = filteredItems.take(itemQty).toList();

    Map<String, dynamic> encounter = {
      'monstros': selectedMonsters,
      'itens': selectedItems,
      'dificuldade': _selectedEncounterDifficulty,
      'qtdMonstros': monsterQty,
      'raridade': _selectedRewardRarity,
      'qtdItens': itemQty,
    };

    _saveEncounter(encounter);
    Navigator.pushNamed(context, '/encontroResultado', arguments: encounter);
  }

  @override
  Widget build(BuildContext context) {
    List<String> encounterDifficulties = ['Fácil', 'Médio', 'Difícil'];
    List<String> monsterQtyOptions =
        ['Aleatório'] +
        List.generate(getMaxMonsters(), (index) => '${index + 1}');
    List<String> rewardRarities = ['Comum', 'Incomum', 'Raro', 'Mítico'];
    List<String> itemQtyOptions =
        ['Aleatório'] + List.generate(getMaxItems(), (index) => '${index + 1}');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36),
          color: const Color(0xFF1B5E20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Encontro Aleatório',
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
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDropdown(
                'Dificuldade do Encontro',
                _selectedEncounterDifficulty,
                encounterDifficulties,
                (value) {
                  setState(() {
                    _selectedEncounterDifficulty = value!;
                    monsterQtyOptions =
                        ['Aleatório'] +
                        List.generate(
                          getMaxMonsters(),
                          (index) => '${index + 1}',
                        );
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                'Quantidade de Monstros',
                _selectedMonsterQty,
                monsterQtyOptions,
                (value) {
                  setState(() {
                    _selectedMonsterQty = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                'Raridade da Recompensa',
                _selectedRewardRarity,
                rewardRarities,
                (value) {
                  setState(() {
                    _selectedRewardRarity = value!;
                    itemQtyOptions =
                        ['Aleatório'] +
                        List.generate(getMaxItems(), (index) => '${index + 1}');
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                'Quantidade de Itens',
                _selectedItemQty,
                itemQtyOptions,
                (value) {
                  setState(() {
                    _selectedItemQty = value!;
                  });
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _generateEncounter,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Gerar Encontro',
                    style: TextStyle(
                      fontFamily: 'UncialAntiqua',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Encontros Salvos:',
                style: TextStyle(
                  fontFamily: 'UncialAntiqua',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              _savedEncounters.isEmpty
                  ? const Text(
                    'Nenhum encontro salvo.',
                    style: TextStyle(
                      fontFamily: 'UncialAntiqua',
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  )
                  : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _savedEncounters.length,
                    itemBuilder: (context, index) {
                      final encounter = _savedEncounters[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          return await _showDeleteConfirmation();
                        },
                        onDismissed: (direction) {
                          _deleteEncounter(index);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
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
                                '/encontroResultado',
                                arguments: encounter,
                              );
                            },
                            contentPadding: const EdgeInsets.all(16),
                            title: Text(
                              'Encontro: ${encounter['dificuldade']} | Monstros: ${encounter['qtdMonstros']}',
                              style: const TextStyle(
                                fontFamily: 'UncialAntiqua',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              'Recompensa: ${encounter['raridade']} | Itens: ${encounter['qtdItens']}',
                              style: const TextStyle(
                                fontFamily: 'UncialAntiqua',
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
