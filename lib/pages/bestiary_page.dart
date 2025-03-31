import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BestiaryPage extends StatefulWidget {
  const BestiaryPage({Key? key}) : super(key: key);

  @override
  _BestiaryPageState createState() => _BestiaryPageState();
}

class _BestiaryPageState extends State<BestiaryPage> {
  List<dynamic> _allMonsters = [];
  List<dynamic> _filteredMonsters = [];
  String _selectedType = 'Todos';
  String _selectedND = 'Todos'; // ND: Nível de Desafio
  String _searchQuery = '';

  Future<List<dynamic>> _loadMonsters() async {
    final jsonString = await rootBundle.loadString('assets/monstros.json');
    final List<dynamic> data = json.decode(jsonString);
    return data;
  }

  @override
  void initState() {
    super.initState();
    _loadMonsters().then((monsters) {
      setState(() {
        _allMonsters = monsters;
        _filteredMonsters = monsters;
      });
    });
  }

  void _filterMonsters() {
    setState(() {
      _filteredMonsters =
          _allMonsters.where((monster) {
            final String name = monster['nome'].toString().toLowerCase();
            final String query = _searchQuery.toLowerCase();
            bool searchMatches = query.isEmpty || name.contains(query);
            bool typeMatches =
                _selectedType == 'Todos' ||
                monster['tipo'].toString() == _selectedType;
            bool ndMatches =
                _selectedND == 'Todos' ||
                monster['nivelDesafio'].toString() == _selectedND;
            return searchMatches && typeMatches && ndMatches;
          }).toList();
    });
  }

  List<String> _getUniqueValues(String key) {
    Set<String> values = {};
    for (var monster in _allMonsters) {
      if (monster[key] != null) {
        values.add(monster[key].toString());
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

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _searchQuery = value;
          _filterMonsters();
        });
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Buscar por nome...',
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: const Icon(Icons.search, color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF424242),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
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
          color: accentColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Bestiário',
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
            // Campo de busca
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildSearchField(),
            ),
            // Seção de filtros
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildDropdown(
                    'Tipo:',
                    _selectedType,
                    _getUniqueValues('tipo'),
                    (value) {
                      setState(() {
                        _selectedType = value!;
                        _filterMonsters();
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    'ND:',
                    _selectedND,
                    _getUniqueValues('nivelDesafio'),
                    (value) {
                      setState(() {
                        _selectedND = value!;
                        _filterMonsters();
                      });
                    },
                  ),
                ],
              ),
            ),
            // Lista de monstros filtrados
            Expanded(
              child:
                  _allMonsters.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _filteredMonsters.length,
                        itemBuilder: (context, index) {
                          final monster = _filteredMonsters[index];
                          return Card(
                            color: const Color(0xFF424242),
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
                                  '/bestiaryDetalhe',
                                  arguments: monster,
                                );
                              },
                              contentPadding: const EdgeInsets.all(16),
                              leading: Image.asset(
                                monster['foto'],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                monster['nome'],
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
                                  Text(
                                    monster['tipo'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'ND: ${monster['nivelDesafio']}',
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
