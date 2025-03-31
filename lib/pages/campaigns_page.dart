import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CampaignsPage extends StatefulWidget {
  const CampaignsPage({Key? key}) : super(key: key);

  @override
  _CampaignsPageState createState() => _CampaignsPageState();
}

class _CampaignsPageState extends State<CampaignsPage> {
  bool _dontShowGuide = false;

  Future<List<dynamic>> _loadCampaigns() async {
    final jsonString = await rootBundle.loadString('assets/campanhas.json');
    final List<dynamic> data = json.decode(jsonString);
    return data;
  }

  @override
  void initState() {
    super.initState();
    _checkDontShowGuide();
  }

  void _checkDontShowGuide() async {
    final prefs = await SharedPreferences.getInstance();
    bool dontShow = prefs.getBool('dontShowGuide') ?? false;
    setState(() {
      _dontShowGuide = dontShow;
    });
    if (!_dontShowGuide) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showGuideDialog();
      });
    }
  }

  void _showGuideDialog() {
    bool dontShowAgain = false;
    showDialog(
      context: context,
      barrierDismissible: false, // Obriga o usuário a interagir
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              // Adiciona um contorno e sombra suave em tom de verde
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0xFF4CAF50), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.grey[900],
              title: Text(
                'Guia do Mestre',
                style: TextStyle(
                  color: Color(0xFF4CAF50),
                  fontFamily: 'UncialAntiqua',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Saudações, nobre mestre! Este app é o seu grimório de inspiração – um ponto de partida para forjar aventuras épicas. As campanhas aqui apresentadas oferecem uma problemática e alguns detalhes para enriquecer suas narrativas, mas a verdadeira magia está na sua imaginação. Use estas informações como base e construa a aventura que desejar!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Color(0xFF4CAF50),
                          value: dontShowAgain,
                          onChanged: (value) {
                            setStateDialog(() {
                              dontShowAgain = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            'Estou ciente. Não exibir esta mensagem novamente.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    if (dontShowAgain) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('dontShowGuide', true);
                      setState(() {
                        _dontShowGuide = true;
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Color(0xFF4CAF50),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Função para determinar a cor da dificuldade (apenas o valor será colorido)
  Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'fácil':
        return Color(0xFF66BB6A); // Verde claro
      case 'médio':
        return Color(0xFFFFA000); // Amarelo/laranja
      case 'difícil':
      case 'alto':
        return Color(0xFFEF5350); // Vermelho
      default:
        return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = Color(
      0xFF1B5E20,
    ); // Tom de verde usado na estética

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 36),
          color: accentColor, // Botão de voltar em verde
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Campanhas',
          style: TextStyle(
            fontFamily: 'UncialAntiqua',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF121212),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF121212), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: _loadCampaigns(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro ao carregar campanhas',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              final campaigns = snapshot.data!;
              return ListView.builder(
                itemCount: campaigns.length,
                itemBuilder: (context, index) {
                  final campaign = campaigns[index];
                  final String diff =
                      (campaign['dificuldade'] ?? '').toString();
                  final Color diffColor = getDifficultyColor(diff);

                  return Card(
                    color: Color(0xFF424242).withOpacity(0.9),
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
                          '/campanhaDetalhe',
                          arguments: campaign,
                        );
                      },
                      contentPadding: const EdgeInsets.all(16),
                      leading: Image.asset(
                        campaign['imagem'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        campaign['titulo'],
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
                          SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              text: 'Dificuldade: ',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                              ),
                              children: [
                                TextSpan(
                                  text: diff,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: diffColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Grupo Mínimo: ${campaign['grupoMinimo']} participantes',
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
              );
            }
          },
        ),
      ),
    );
  }
}
