import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MinhasAventurasPage extends StatefulWidget {
  const MinhasAventurasPage({Key? key}) : super(key: key);

  @override
  _MinhasAventurasPageState createState() => _MinhasAventurasPageState();
}

class _MinhasAventurasPageState extends State<MinhasAventurasPage> {
  List<dynamic> _aventuras = [];

  @override
  void initState() {
    super.initState();
    _loadAventuras();
  }

  Future<void> _loadAventuras() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString("aventuras");
    if (jsonString != null) {
      setState(() {
        _aventuras = json.decode(jsonString);
      });
    }
  }

  Future<void> _saveAventuras() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("aventuras", json.encode(_aventuras));
  }

  Future<void> _deleteAventura(int index) async {
    setState(() {
      _aventuras.removeAt(index);
    });
    await _saveAventuras();
  }

  void _navigateToAventuraDetail({Map<String, dynamic>? aventura}) async {
    final result = await Navigator.pushNamed(
      context,
      '/aventuraDetalhe',
      arguments: aventura,
    );
    if (result != null) {
      if (aventura == null) {
        setState(() {
          _aventuras.add(result);
        });
      } else {
        int index = _aventuras.indexWhere((a) => a['id'] == aventura['id']);
        if (index != -1) {
          setState(() {
            _aventuras[index] = result;
          });
        }
      }
      await _saveAventuras();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = const Color(0xFF1B5E20);
    final Color backgroundColor = const Color(0xFF121212);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: accentColor, // botão de voltar em verde
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Minhas Aventuras',
          style: TextStyle(
            fontFamily: 'UncialAntiqua',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body:
          _aventuras.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Nenhuma aventura encontrada.',
                      style: TextStyle(
                        fontFamily: 'UncialAntiqua',
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _navigateToAventuraDetail();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Criar Aventura',
                        style: TextStyle(
                          fontFamily: 'UncialAntiqua',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                itemCount: _aventuras.length,
                itemBuilder: (context, index) {
                  final aventura = _aventuras[index];
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteAventura(index);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      title: Text(
                        aventura['nome'] ?? 'Sem Nome',
                        style: const TextStyle(
                          fontFamily: 'UncialAntiqua',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        _navigateToAventuraDetail(aventura: aventura);
                      },
                    ),
                  );
                },
              ),
      bottomNavigationBar:
          _aventuras.isNotEmpty
              ? Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 32,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    _navigateToAventuraDetail();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Criar Aventura',
                    style: TextStyle(
                      fontFamily: 'UncialAntiqua',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
              : null,
      backgroundColor: backgroundColor,
    );
  }
}
