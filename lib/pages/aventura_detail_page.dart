import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ecos_do_mestre/pages/campaign_selection_dialog.dart';
import 'package:ecos_do_mestre/pages/monster_selection_dialog.dart';
import 'package:ecos_do_mestre/pages/item_selection_dialog.dart';

class AventuraDetailPage extends StatefulWidget {
  const AventuraDetailPage({Key? key}) : super(key: key);

  @override
  _AventuraDetailPageState createState() => _AventuraDetailPageState();
}

class _AventuraDetailPageState extends State<AventuraDetailPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nomeController = TextEditingController();
  TabController? _tabController;

  // Listas para armazenar os itens importados na aventura
  List<Map<String, dynamic>> _campanhas = [];
  List<Map<String, dynamic>> _monstros = [];
  List<Map<String, dynamic>> _itens = [];

  bool _isInitialized = false; // Para carregar os argumentos apenas uma vez

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final adventure =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (adventure != null) {
        _nomeController.text = adventure['nome'] ?? '';
        // Garante que cada campanha importada tenha um campo 'done'
        _campanhas =
            (adventure['campanhas'] as List<dynamic>? ?? []).map((e) {
              Map<String, dynamic> item = Map<String, dynamic>.from(e);
              if (item['done'] == null) item['done'] = false;
              return item;
            }).toList();
        _monstros =
            (adventure['monstros'] as List<dynamic>? ?? [])
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
        _itens =
            (adventure['itens'] as List<dynamic>? ?? [])
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  void _saveAdventure() {
    Map<String, dynamic> adventure = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'nome': _nomeController.text,
      'campanhas': _campanhas,
      'monstros': _monstros,
      'itens': _itens,
    };
    Navigator.pop(context, adventure);
  }

  // Função que constrói uma ListTile para campanhas importadas
  Widget _buildCampaignTile(Map<String, dynamic> campaign, int index) {
    bool done = campaign['done'] ?? false;
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _campanhas.removeAt(index);
        });
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        title: Text(
          campaign['titulo'] ?? 'Sem Nome',
          style: TextStyle(
            fontFamily: 'UncialAntiqua',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            decoration: done ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dificuldade: ${campaign['dificuldade'] ?? 'N/A'}',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            Text(
              'Grupo Mínimo: ${campaign['grupoMinimo'] ?? 'N/A'} participantes',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            done ? Icons.check_circle : Icons.check_circle_outline,
            color: done ? const Color(0xFF1B5E20) : Colors.white70,
          ),
          onPressed: () {
            setState(() {
              campaign['done'] = !done;
            });
          },
        ),
        onTap: () {
          // Ao tocar no tile, alterna o status "done"
          setState(() {
            campaign['done'] = !done;
          });
        },
      ),
    );
  }

  // Função que constrói uma ListTile para monstros e itens importados (somente exclusão)
  Widget _buildGenericTile(Map<String, dynamic> item, int index, String type) {
    // type pode ser 'monstro' ou 'item'
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          if (type == 'monstro') {
            _monstros.removeAt(index);
          } else if (type == 'item') {
            _itens.removeAt(index);
          }
        });
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
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
        onTap: () {
          // Abre a detail page da categoria correspondente
          String route = '';
          if (type == 'monstro') {
            route = '/bestiaryDetalhe';
          } else if (type == 'item') {
            route = '/itensDetalhe';
          }
          Navigator.pushNamed(context, route, arguments: item);
        },
      ),
    );
  }

  // Função auxiliar para construir a seção de campanhas
  Widget _buildCampaignSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Campanhas',
          style: TextStyle(
            fontFamily: 'UncialAntiqua',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _campanhas.isEmpty
            ? const Text(
              'Nenhuma campanha importada.',
              style: TextStyle(color: Colors.white70),
            )
            : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _campanhas.length,
              itemBuilder: (context, index) {
                return _buildCampaignTile(_campanhas[index], index);
              },
            ),
        ElevatedButton(
          onPressed: () async {
            // Abre o pop-up para seleção de campanha
            final result = await showDialog(
              context: context,
              builder: (context) => const CampaignSelectionDialog(),
            );
            if (result != null) {
              // Certifica-se de que o objeto importado tenha a chave 'done'
              Map<String, dynamic> importedCampaign = Map<String, dynamic>.from(
                result,
              );
              if (importedCampaign['done'] == null) {
                importedCampaign['done'] = false;
              }
              setState(() {
                _campanhas.add(importedCampaign);
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B5E20),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Importar Campanha',
            style: TextStyle(
              fontFamily: 'UncialAntiqua',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // Seção para monstros importados utilizando pop-up para seleção
  Widget _buildMonsterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Monstros',
          style: TextStyle(
            fontFamily: 'UncialAntiqua',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _monstros.isEmpty
            ? const Text(
              'Nenhum monstro importado.',
              style: TextStyle(color: Colors.white70),
            )
            : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _monstros.length,
              itemBuilder: (context, index) {
                return _buildGenericTile(_monstros[index], index, 'monstro');
              },
            ),
        ElevatedButton(
          onPressed: () async {
            // Abre o pop-up para seleção de monstro
            final result = await showDialog(
              context: context,
              builder: (context) => const MonsterSelectionDialog(),
            );
            if (result != null && result is Map<String, dynamic>) {
              setState(() {
                _monstros.add(result);
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B5E20),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Importar Monstro',
            style: TextStyle(
              fontFamily: 'UncialAntiqua',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // Seção para itens importados utilizando pop-up para seleção
  Widget _buildItemSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Itens',
          style: TextStyle(
            fontFamily: 'UncialAntiqua',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        _itens.isEmpty
            ? const Text(
              'Nenhum item importado.',
              style: TextStyle(color: Colors.white70),
            )
            : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _itens.length,
              itemBuilder: (context, index) {
                return _buildGenericTile(_itens[index], index, 'item');
              },
            ),
        ElevatedButton(
          onPressed: () async {
            // Abre o pop-up para seleção de item
            final result = await showDialog(
              context: context,
              builder: (context) => const ItemSelectionDialog(),
            );
            if (result != null && result is Map<String, dynamic>) {
              setState(() {
                _itens.add(result);
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1B5E20),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Importar Item',
            style: TextStyle(
              fontFamily: 'UncialAntiqua',
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = const Color(0xFF121212);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36),
          color: const Color(0xFF1B5E20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Aventura',
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome da Aventura',
                hintText: 'Ex. Mesa com amigo 1 e amigo 2',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF1B5E20),
              tabs: const [
                Tab(text: 'Campanhas'),
                Tab(text: 'Monstros'),
                Tab(text: 'Itens'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(8),
                    child: _buildCampaignSection(),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(8),
                    child: _buildMonsterSection(),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(8),
                    child: _buildItemSection(),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _saveAdventure,
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
                'Salvar Aventura',
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
      ),
    );
  }
}
