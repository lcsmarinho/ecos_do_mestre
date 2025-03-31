import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EncounterPage extends StatefulWidget {
  const EncounterPage({Key? key}) : super(key: key);

  @override
  _EncounterPageState createState() => _EncounterPageState();
}

class _EncounterPageState extends State<EncounterPage> {
  final Random _random = Random();
  List<dynamic> _allMonsters = [];
  List<dynamic> _allItems = [];

  // Configurações do encontro
  String _selectedEncounterDifficulty =
      'Fácil'; // opções: Fácil, Médio, Difícil
  String _selectedMonsterQty = 'Aleatório'; // ou um número em string
  String _selectedRewardRarity = 'Comum'; // Comum, Incomum, Raro, Mítico
  String _selectedItemQty = 'Aleatório'; // ou número

  @override
  void initState() {
    super.initState();
    _loadMonsters();
    _loadItems();
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

  // Converte o nível de desafio (ND) do monstro para double
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

  // Filtra os monstros conforme a dificuldade do encontro
  // Mapeamento:
  // - Encontro Fácil: selecionar monstros com ND <= 1
  // - Encontro Médio: ND > 1 e <= 4
  // - Encontro Difícil: ND > 4
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

  // Filtra os itens pela raridade
  List<dynamic> _filterItemsByRarity() {
    return _allItems.where((item) {
      return item['raridade'].toString().toLowerCase() ==
          _selectedRewardRarity.toLowerCase();
    }).toList();
  }

  // Retorna o número máximo de monstros com base na dificuldade selecionada
  int getMaxMonsters() {
    if (_selectedEncounterDifficulty == 'Fácil') return 4;
    if (_selectedEncounterDifficulty == 'Médio') return 3;
    if (_selectedEncounterDifficulty == 'Difícil') return 2;
    return 1;
  }

  // Retorna o número máximo de itens para a raridade selecionada
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

  // Widget para criar um Dropdown com opções fornecidas
  Widget _buildDropdown(
    String label,
    String currentValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Row(
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
        DropdownButton<String>(
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
      ],
    );
  }

  // Botão para gerar o encontro
  void _generateEncounter() {
    // Filtra os monstros de acordo com a dificuldade escolhida
    List<dynamic> filteredMonsters = _filterMonstersByDifficulty();
    int maxMonsters = getMaxMonsters();
    int monsterQty;
    if (_selectedMonsterQty == 'Aleatório') {
      monsterQty = _random.nextInt(maxMonsters) + 1; // de 1 até maxMonsters
    } else {
      monsterQty = int.tryParse(_selectedMonsterQty) ?? 1;
    }
    // Seleciona aleatoriamente os monstros (sem repetição, se possível)
    filteredMonsters.shuffle(_random);
    List<dynamic> selectedMonsters = filteredMonsters.take(monsterQty).toList();

    // Filtra os itens por raridade
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

    // Navega para a página de resultado, passando os dados gerados
    Navigator.pushNamed(
      context,
      '/encontroResultado',
      arguments: {
        'monstros': selectedMonsters,
        'itens': selectedItems,
        'dificuldade': _selectedEncounterDifficulty,
        'qtdMonstros': monsterQty,
        'raridade': _selectedRewardRarity,
        'qtdItens': itemQty,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Define as opções para os dropdowns
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
                    // Atualiza as opções de quantidade de monstros conforme a dificuldade selecionada
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
                    // Atualiza as opções de quantidade de itens conforme a raridade
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
            ],
          ),
        ),
      ),
    );
  }
}
