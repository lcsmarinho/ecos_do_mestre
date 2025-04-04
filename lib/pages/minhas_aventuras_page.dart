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
    // Navega para a página de criação/edição de aventura.
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
      body: ListView.builder(
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        child: const Icon(Icons.add),
        onPressed: () {
          _navigateToAventuraDetail();
        },
      ),
    );
  }
}
