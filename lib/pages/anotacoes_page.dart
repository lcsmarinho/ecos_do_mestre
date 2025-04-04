import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'anotacao_dialog.dart';
import 'anotacao_view_dialog.dart';

class AnotacoesPage extends StatefulWidget {
  const AnotacoesPage({Key? key}) : super(key: key);

  @override
  _AnotacoesPageState createState() => _AnotacoesPageState();
}

class _AnotacoesPageState extends State<AnotacoesPage> {
  List<Map<String, dynamic>> _anotacoes = [];
  String? _adventureId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    _adventureId = args?['adventureId'];
    _loadAnotacoes();
  }

  Future<void> _loadAnotacoes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? anotacoesString = prefs.getString('anotacoes');
    if (anotacoesString != null) {
      List<dynamic> anotacoesJson = json.decode(anotacoesString);
      setState(() {
        _anotacoes =
            anotacoesJson
                .map((e) => Map<String, dynamic>.from(e))
                .where((nota) => nota['adventureId'] == _adventureId)
                .toList();
      });
    }
  }

  Future<void> _saveAnotacoes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? allAnotacoesString = prefs.getString('anotacoes');
    List<dynamic> allAnotacoes =
        allAnotacoesString != null ? json.decode(allAnotacoesString) : [];
    allAnotacoes.removeWhere((nota) => nota['adventureId'] == _adventureId);
    allAnotacoes.addAll(_anotacoes);
    await prefs.setString('anotacoes', json.encode(allAnotacoes));
  }

  Future<void> _addAnotacao() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AnotacaoDialog(),
    );
    if (result != null) {
      result['adventureId'] = _adventureId;
      setState(() {
        _anotacoes.add(result);
      });
      _saveAnotacoes();
    }
  }

  Future<void> _editAnotacao(int index) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AnotacaoDialog(anotacao: _anotacoes[index]),
    );
    if (result != null) {
      result['adventureId'] = _adventureId;
      setState(() {
        _anotacoes[index] = result;
      });
      _saveAnotacoes();
    }
  }

  Future<void> _deleteAnotacao(int index) async {
    setState(() {
      _anotacoes.removeAt(index);
    });
    _saveAnotacoes();
  }

  Future<void> _viewAnotacao(int index) async {
    await showDialog(
      context: context,
      builder: (context) => AnotacaoViewDialog(anotacao: _anotacoes[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = const Color(0xFF1B5E20);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: accentColor, // botão de voltar em verde
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Anotações',
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
      backgroundColor: const Color(0xFF121212),
      body:
          _anotacoes.isEmpty
              ? const Center(
                child: Text(
                  'Nenhuma anotação encontrada.',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              )
              : ListView.builder(
                itemCount: _anotacoes.length,
                itemBuilder: (context, index) {
                  final anotacao = _anotacoes[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteAnotacao(index);
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
                        vertical: 4,
                        horizontal: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(
                          anotacao['titulo'] ?? 'Sem título',
                          style: const TextStyle(
                            fontFamily: 'UncialAntiqua',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          anotacao['corpo'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        onTap: () {
                          _viewAnotacao(index);
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          onPressed: () {
                            _editAnotacao(index);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        child: const Icon(Icons.note_add, color: Colors.white),
        onPressed: _addAnotacao,
      ),
    );
  }
}
