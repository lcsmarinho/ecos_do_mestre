import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MagiasPage extends StatefulWidget {
  const MagiasPage({super.key});

  @override
  _MagiasPageState createState() => _MagiasPageState();
}

class _MagiasPageState extends State<MagiasPage> {
  List<dynamic> _allMagias = [];
  List<dynamic> _filteredMagias = [];
  String _searchQuery = '';
  String _selectedClasse = 'Todas';
  String _selectedTipo = 'Todos';

  Future<void> _loadMagias() async {
    final jsonString = await rootBundle.loadString('assets/magias.json');
    setState(() {
      _allMagias = json.decode(jsonString);
      _filteredMagias = _allMagias;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMagias();
  }

  // Função que extrai as classes individuais de uma magia
  List<String> _extractClasses(String classesString) {
    // Usa vírgula, ponto-e-vírgula e " e " como delimitadores
    return classesString
        .split(RegExp(r',|;| e '))
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }

  // Função que extrai os tipos individuais (se necessário, similar a classes)
  List<String> _extractTipos(String tiposString) {
    return tiposString
        .split(RegExp(r',|;| e '))
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();
  }

  // Cria a lista de classes únicas a partir de todas as magias
  List<String> _getUniqueClasses() {
    Set<String> classesSet = {};
    for (var magia in _allMagias) {
      if (magia['classe'] != null) {
        List<String> classes = _extractClasses(magia['classe'].toString());
        classesSet.addAll(classes);
      }
    }
    List<String> classesList = classesSet.toList();
    classesList.sort();
    return ['Todas', ...classesList];
  }

  // Cria a lista de tipos únicos a partir de todas as magias
  List<String> _getUniqueTipos() {
    Set<String> tiposSet = {};
    for (var magia in _allMagias) {
      if (magia['tipo'] != null) {
        List<String> tipos = _extractTipos(magia['tipo'].toString());
        tiposSet.addAll(tipos);
      }
    }
    List<String> tiposList = tiposSet.toList();
    tiposList.sort();
    return ['Todos', ...tiposList];
  }

  // Atualiza a lista filtrada considerando busca, classe e tipo
  void _filterMagias() {
    setState(() {
      _filteredMagias =
          _allMagias.where((magia) {
            final nome = magia['nome']?.toString().toLowerCase() ?? '';
            final buscaOk = nome.contains(_searchQuery.toLowerCase());

            // Para classe, extrai as classes individuais e verifica se o filtro selecionado está presente
            bool classeOk = false;
            if (_selectedClasse == 'Todas') {
              classeOk = true;
            } else if (magia['classe'] != null) {
              List<String> classes = _extractClasses(
                magia['classe'].toString(),
              );
              classeOk = classes.any(
                (classe) =>
                    classe.toLowerCase() == _selectedClasse.toLowerCase(),
              );
            }

            // Para tipo, extraímos também os valores individuais e verificamos
            bool tipoOk = false;
            if (_selectedTipo == 'Todos') {
              tipoOk = true;
            } else if (magia['tipo'] != null) {
              List<String> tipos = _extractTipos(magia['tipo'].toString());
              tipoOk = tipos.any(
                (tipo) => tipo.toLowerCase() == _selectedTipo.toLowerCase(),
              );
            }

            return buscaOk && classeOk && tipoOk;
          }).toList();
    });
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: (value) {
          _searchQuery = value;
          _filterMagias();
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

  // Cria um dropdown expandido para um filtro
  Widget _buildDropdown(
    String label,
    String currentValue,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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

  @override
  Widget build(BuildContext context) {
    final Color accentColor = const Color(0xFF1B5E20);
    List<String> classes = _getUniqueClasses();
    List<String> tipos = _getUniqueTipos();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36),
          color: accentColor,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Magias',
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
            _buildDropdown('Classe', _selectedClasse, classes, (value) {
              setState(() {
                _selectedClasse = value!;
                _filterMagias();
              });
            }),
            _buildDropdown('Tipo', _selectedTipo, tipos, (value) {
              setState(() {
                _selectedTipo = value!;
                _filterMagias();
              });
            }),
            Expanded(
              child:
                  _allMagias.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _filteredMagias.length,
                        itemBuilder: (context, index) {
                          final magia = _filteredMagias[index];
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
                                  '/magiasDetalhe',
                                  arguments: magia,
                                );
                              },
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                magia['nome'] ?? 'Sem Nome',
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
                                  Text(
                                    'Classe: ${magia['classe'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'Tipo: ${magia['tipo'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Text(
                                    'Tempo de Conjuração: ${magia['tempoConjuracao'] ?? 'N/A'}',
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
