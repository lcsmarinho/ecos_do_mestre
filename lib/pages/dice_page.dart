import 'dart:math';
import 'package:flutter/material.dart';

class DicePage extends StatefulWidget {
  const DicePage({Key? key}) : super(key: key);

  @override
  _DicePageState createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  final Random _random = Random();
  int _currentResult = 0;
  bool _isSumming = false;
  int _currentSum = 0;
  String _operation = "";
  int? _lastDiceSides;
  int _secretClicks = 0;
  bool _secretActive = false;

  // Rola o dado com o número de lados informado.
  int _rollDice(int sides) {
    // Se o modo secreto estiver ativo, retorna o valor máximo
    if (_secretActive) {
      _secretActive = false; // Reseta o modo secreto após uso
      return sides;
    }
    return _random.nextInt(sides) + 1;
  }

  void _onDicePressed(int sides) {
    int roll = _rollDice(sides);
    setState(() {
      _lastDiceSides = sides;
      if (_isSumming) {
        _currentSum += roll;
        _operation =
            _operation.isEmpty ? roll.toString() : "$_operation + $roll";
        _currentResult = _currentSum;
      } else {
        _currentResult = roll;
      }
    });
  }

  // Método para registrar cliques secretos no quadrado
  void _onResultSquareTapped() {
    setState(() {
      _secretClicks++;
      if (_secretClicks >= 7) {
        _secretActive = true;
        _secretClicks = 0;
        // Opcional: exibe um feedback visual com um SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Modo secreto ativado: Próximo dado mostra o valor máximo!',
              style: TextStyle(fontFamily: 'UncialAntiqua'),
            ),
            backgroundColor: Color(0xFF1B5E20),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _toggleSum() {
    if (_isSumming) {
      _showSumResult();
    } else {
      setState(() {
        _isSumming = true;
        _currentSum = 0;
        _operation = "";
        _currentResult = 0;
      });
    }
  }

  void _showSumResult() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF121212),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFF1B5E20), width: 2),
          ),
          title: Text(
            'Resultado da Soma',
            style: TextStyle(
              fontFamily: 'UncialAntiqua',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: const Color(0xFF1B5E20),
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          content: Text(
            'Operação: $_operation\nTotal: $_currentSum',
            style: const TextStyle(
              fontFamily: 'UncialAntiqua',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _isSumming = false;
                  _currentSum = 0;
                  _operation = "";
                  _currentResult = 0;
                  _lastDiceSides = null;
                });
                Navigator.of(context).pop();
              },
              child: Text(
                'Fechar',
                style: TextStyle(
                  fontFamily: 'UncialAntiqua',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: const Color(0xFF1B5E20),
                      offset: const Offset(1, 1),
                      blurRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDiceButton(String label, int sides) {
    return GestureDetector(
      onTap: () => _onDicePressed(sides),
      child: Container(
        width: 80,
        height: 80,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF424242),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: 'UncialAntiqua',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSumButton() {
    return ElevatedButton(
      onPressed: _toggleSum,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B5E20),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        _isSumming ? 'Finalizar' : 'Somar',
        style: TextStyle(
          fontFamily: 'UncialAntiqua',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              color: const Color(0xFF1B5E20),
              offset: const Offset(1, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Condição para valor máximo: se o dado for de 6 lados ou mais e o resultado for o máximo.
    bool isMax =
        !_isSumming &&
        _lastDiceSides != null &&
        _lastDiceSides! >= 6 &&
        _currentResult == _lastDiceSides;
    // Para dados de d20 ou mais, se o resultado for o máximo, exibe "Brutal!!" acima do quadrado.
    bool showBrutal =
        _lastDiceSides != null &&
        _lastDiceSides! >= 20 &&
        _currentResult == _lastDiceSides;

    // Se o valor rolado for 1, o número é exibido na cor verde.
    Color resultColor =
        (_currentResult == 1) ? const Color(0xFF1B5E20) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 36),
          color: const Color(0xFF1B5E20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Dados',
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showBrutal)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Brutal!!',
                    style: TextStyle(
                      fontFamily: 'UncialAntiqua',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: const Color(0xFF1B5E20),
                          offset: const Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              // O quadrado agora é um botão secreto: ao ser clicado 7 vezes, ativa o modo secreto.
              GestureDetector(
                onTap: _onResultSquareTapped,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: isMax ? Colors.red : const Color(0xFF424242),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      _currentResult.toString(),
                      style: TextStyle(
                        fontFamily: 'UncialAntiqua',
                        fontSize:
                            (_currentResult == 1) ? 64 : (isMax ? 64 : 56),
                        fontWeight: FontWeight.bold,
                        color: resultColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _isSumming
                  ? Text(
                    _operation,
                    style: const TextStyle(
                      fontFamily: 'UncialAntiqua',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                  : const SizedBox.shrink(),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  _buildDiceButton('d2', 2),
                  _buildDiceButton('d4', 4),
                  _buildDiceButton('d6', 6),
                  _buildDiceButton('d8', 8),
                  _buildDiceButton('d10', 10),
                  _buildDiceButton('d12', 12),
                  _buildDiceButton('d20', 20),
                  _buildDiceButton('d100', 100),
                ],
              ),
              const SizedBox(height: 16),
              _buildSumButton(),
            ],
          ),
        ),
      ),
    );
  }
}
