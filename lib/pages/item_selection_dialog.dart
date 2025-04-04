import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemSelectionDialog extends StatefulWidget {
  const ItemSelectionDialog({Key? key}) : super(key: key);

  @override
  _ItemSelectionDialogState createState() => _ItemSelectionDialogState();
}

class _ItemSelectionDialogState extends State<ItemSelectionDialog> {
  List<dynamic> _allItems = [];
  List<dynamic> _filteredItems = [];
  String _searchQuery = '';
  String _selectedType = 'Todos';
  List<String> _typeOptions = ['Todos'];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final jsonString = await rootBundle.loadString('assets/itens.json');
    final List<dynamic> items = json.decode(jsonString);
    // Extrai os tipos existentes no arquivo
    final types =
        items
            .map((item) => item['tipo']?.toString() ?? '')
            .where((tipo) => tipo.isNotEmpty)
            .toSet()
            .toList();
    types.sort();
    setState(() {
      _allItems = items;
      _filteredItems = items;
      _typeOptions = ['Todos', ...types];
    });
  }

  void _filterItems() {
    setState(() {
      _filteredItems =
          _allItems.where((item) {
            final nome = item['nome']?.toString().toLowerCase() ?? '';
            final searchOk = nome.contains(_searchQuery.toLowerCase());
            final tipo = item['tipo']?.toString() ?? '';
            final typeOk = _selectedType == 'Todos' || tipo == _selectedType;
            return searchOk && typeOk;
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
              'Selecionar Item',
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
                _filterItems();
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
            // Dropdown para filtrar por tipo
            Row(
              children: [
                const Text(
                  'Tipo: ',
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
                  value: _selectedType,
                  items:
                      _typeOptions
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedType = value!;
                      _filterItems();
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
                  _allItems.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = _filteredItems[index];
                          return Card(
                            color: const Color(0xFF424242).withOpacity(0.9),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                item['nome'] ?? 'Sem Nome',
                                style: const TextStyle(
                                  fontFamily: 'UncialAntiqua',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                'Tipo: ${item['tipo'] ?? 'N/A'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context, item);
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
