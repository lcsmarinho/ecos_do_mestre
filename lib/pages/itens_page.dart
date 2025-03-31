import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItensPage extends StatefulWidget {
  const ItensPage({Key? key}) : super(key: key);

  @override
  _ItensPageState createState() => _ItensPageState();
}

class _ItensPageState extends State<ItensPage> {
  List<dynamic> _allItems = [];
  List<dynamic> _filteredItems = [];
  String _searchQuery = '';
  String _selectedType = 'Todos';
  String _selectedRarity = 'Todos';

  Future<List<dynamic>> _loadItems() async {
    final jsonString = await rootBundle.loadString('assets/itens.json');
    final List<dynamic> data = json.decode(jsonString);
    return data;
  }

  @override
  void initState() {
    super.initState();
    _loadItems().then((items) {
      setState(() {
        _allItems = items;
        _filteredItems = items;
      });
    });
  }

  void _filterItems() {
    setState(() {
      _filteredItems =
          _allItems.where((item) {
            final name = item['nome']?.toString().toLowerCase() ?? '';
            final query = _searchQuery.toLowerCase();
            bool searchMatches = query.isEmpty || name.contains(query);
            bool typeMatches =
                _selectedType == 'Todos' ||
                item['tipo'].toString() == _selectedType;
            bool rarityMatches =
                _selectedRarity == 'Todos' ||
                item['raridade'].toString().toLowerCase() ==
                    _selectedRarity.toLowerCase();
            return searchMatches && typeMatches && rarityMatches;
          }).toList();
    });
  }

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

  List<String> _getUniqueValues(String key) {
    Set<String> values = {};
    for (var item in _allItems) {
      if (item[key] != null) {
        values.add(item[key].toString());
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) {
          _searchQuery = value;
          _filterItems();
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = const Color(0xFF1B5E20);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36),
          color: accentColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Itens',
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
            _buildSearchField(),
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
                        _filterItems();
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _buildDropdown(
                    'Raridade:',
                    _selectedRarity,
                    _getUniqueValues('raridade'),
                    (value) {
                      setState(() {
                        _selectedRarity = value!;
                        _filterItems();
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  _allItems.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
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
                                  '/itensDetalhe',
                                  arguments: item,
                                );
                              },
                              contentPadding: const EdgeInsets.all(16),
                              leading: Image.asset(
                                item['foto'] ?? 'assets/images/ecos-logo.png',
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                item['nome'] ?? 'Sem nome',
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
                                    'Tipo: ${item['tipo'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Raridade: ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      Text(
                                        item['raridade'] ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: getRarityColor(
                                            item['raridade'] ?? '',
                                          ),
                                        ),
                                      ),
                                    ],
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
