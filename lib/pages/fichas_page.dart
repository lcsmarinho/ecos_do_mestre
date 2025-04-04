import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FichasPage extends StatefulWidget {
  const FichasPage({Key? key}) : super(key: key);

  @override
  _FichasPageState createState() => _FichasPageState();
}

class _FichasPageState extends State<FichasPage> {
  List<dynamic> _allFichas = [];
  List<dynamic> _filteredFichas = [];
  List<String> _classeOptions = ['Todos'];
  List<String> _racaOptions = ['Todos'];
  String _selectedClasse = 'Todos';
  String _selectedRaca = 'Todos';

  @override
  void initState() {
    super.initState();
    _loadFichas();
  }

  Future<void> _loadFichas() async {
    String jsonString = await rootBundle.loadString('assets/fichas.json');
    final List<dynamic> fichas = jsonDecode(jsonString);
    // Usa as chaves "classe" e "raça" conforme o JSON
    final classesSet =
        fichas
            .map((ficha) => ficha['classe']?.toString() ?? '')
            .where((classe) => classe.isNotEmpty)
            .toSet();
    final racaSet =
        fichas
            .map((ficha) => ficha['raça']?.toString() ?? '')
            .where((raca) => raca.isNotEmpty)
            .toSet();
    setState(() {
      _allFichas = fichas;
      _filteredFichas = fichas;
      _classeOptions = ['Todos', ...classesSet.toList()..sort()];
      _racaOptions = ['Todos', ...racaSet.toList()..sort()];
    });
  }

  void _filterFichas() {
    setState(() {
      _filteredFichas =
          _allFichas.where((ficha) {
            final classe = ficha['classe']?.toString() ?? '';
            final raca = ficha['raça']?.toString() ?? '';
            final classeOk =
                _selectedClasse == 'Todos' ||
                classe.toLowerCase() == _selectedClasse.toLowerCase();
            final racaOk =
                _selectedRaca == 'Todos' ||
                raca.toLowerCase() == _selectedRaca.toLowerCase();
            return classeOk && racaOk;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFF121212);
    const Color accentColor = Color(0xFF1B5E20);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fichas de Personagens',
          style: TextStyle(
            fontFamily: 'UncialAntiqua',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: accentColor,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Filtros com rótulos
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filtrar por Classe:',
                        style: TextStyle(
                          fontFamily: 'UncialAntiqua',
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      DropdownButton<String>(
                        dropdownColor: const Color(0xFF424242),
                        value: _selectedClasse,
                        isExpanded: true,
                        items:
                            _classeOptions
                                .map(
                                  (classe) => DropdownMenuItem(
                                    value: classe,
                                    child: Text(
                                      classe,
                                      style: const TextStyle(
                                        fontFamily: 'UncialAntiqua',
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedClasse = value!;
                            _filterFichas();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filtrar por Raça:',
                        style: TextStyle(
                          fontFamily: 'UncialAntiqua',
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      DropdownButton<String>(
                        dropdownColor: const Color(0xFF424242),
                        value: _selectedRaca,
                        isExpanded: true,
                        items:
                            _racaOptions
                                .map(
                                  (raca) => DropdownMenuItem(
                                    value: raca,
                                    child: Text(
                                      raca,
                                      style: const TextStyle(
                                        fontFamily: 'UncialAntiqua',
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRaca = value!;
                            _filterFichas();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child:
                  _filteredFichas.isEmpty
                      ? const Center(
                        child: Text(
                          'Nenhuma ficha encontrada com os filtros selecionados.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      )
                      : ListView.builder(
                        itemCount: _filteredFichas.length,
                        itemBuilder: (context, index) {
                          final ficha = _filteredFichas[index];
                          // Recupera a imagem da ficha usando a chave "image"
                          final String imagePath =
                              ficha['image'] != null &&
                                      ficha['image']
                                          .toString()
                                          .trim()
                                          .isNotEmpty
                                  ? ficha['image'].toString()
                                  : 'assets/images/ecos-logo.png';
                          return Card(
                            color: const Color(0xFF424242).withOpacity(0.9),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: AssetImage(imagePath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(
                                ficha['nome'] ?? 'Sem Nome',
                                style: const TextStyle(
                                  fontFamily: 'UncialAntiqua',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                '${ficha['classe'] ?? 'Sem Classe'} • ${ficha['raça'] ?? 'Sem Raça'}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                              ),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/fichasDetalhe',
                                  arguments: ficha,
                                );
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
