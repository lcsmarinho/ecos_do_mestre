import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeDialog extends StatefulWidget {
  const WelcomeDialog({Key? key}) : super(key: key);

  @override
  _WelcomeDialogState createState() => _WelcomeDialogState();
}

class _WelcomeDialogState extends State<WelcomeDialog> {
  bool _dontShowAgain = false;

  Future<void> _savePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hideWelcomePopup', _dontShowAgain);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF121212),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Bem-vindo, Mestre!',
        style: TextStyle(
          fontFamily: 'UncialAntiqua',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B5E20),
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Área rolável com as funcionalidades
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureItem(
                    'Campanhas',
                    'Explore campanhas já criadas e inspire suas sessões.',
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    'Bestiário',
                    'Consulte criaturas e monstros para enriquecer seus encontros.',
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    'Itens',
                    'Descubra itens e equipamentos para compor suas aventuras.',
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    'Dados',
                    'Role dados e deixe a sorte definir momentos épicos.',
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    'Encontros',
                    'Planeje encontros desafiadores para surpreender seus jogadores.',
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    'Magias',
                    'Explore magias e encantamentos para transformar o jogo.',
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    'Minhas Aventuras',
                    'Crie e gerencie suas próprias aventuras com facilidade.',
                  ),
                  const SizedBox(height: 8),
                  _buildFeatureItem(
                    'Fichas de Personagens',
                    'Consulte fichas detalhadas para enriquecer seus personagens.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Área fixa para a checkbox
          Row(
            children: [
              Checkbox(
                value: _dontShowAgain,
                activeColor: const Color(0xFF1B5E20),
                onChanged: (value) {
                  setState(() {
                    _dontShowAgain = value ?? false;
                  });
                },
              ),
              const Expanded(
                child: Text(
                  'Não mostrar novamente',
                  style: TextStyle(
                    // Usando fonte padrão para maior legibilidade
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Botão "Fechar" posicionado abaixo da área fixa com checkbox
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: TextButton(
            onPressed: () {
              _savePreference();
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: const Text(
              'Fechar',
              style: TextStyle(
                fontFamily: 'UncialAntiqua',
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String title, String description) {
    return RichText(
      text: TextSpan(
        text: '$title: ',
        style: const TextStyle(
          fontFamily: 'UncialAntiqua',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1B5E20),
        ),
        children: [
          TextSpan(
            text: description,
            style: const TextStyle(
              // Texto em branco com fonte padrão para melhor legibilidade
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
