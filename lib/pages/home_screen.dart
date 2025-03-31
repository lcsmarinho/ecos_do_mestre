import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // Definindo as cores utilizadas na tela
  final Color primaryColor = const Color(0xFF0D3B26); // Verde Lovecraft escuro
  final Color accentColor = const Color(0xFF1B5E20); // Verde de destaque
  final Color backgroundColor = const Color(0xFF121212); // Fundo da aplicação

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // Menu lateral (Drawer)
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, Colors.black],
              stops: const [0.0, 0.25],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Cabeçalho do menu
              Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, Colors.black],
                    stops: const [0.0, 0.25],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'UncialAntiqua',
                  ),
                ),
              ),
              // Item para Campanhas
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor,
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.book, color: Colors.white),
                    title: Text(
                      'Campanhas',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'UncialAntiqua',
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/campanhas');
                    },
                  ),
                ),
              ),
              // Item para Bestiário
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: accentColor,
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.pets, color: Colors.white),
                    title: Text(
                      'Bestiário',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'UncialAntiqua',
                        fontSize: 18,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/bestiary');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // AppBar com o logo e o título
      appBar: AppBar(
        iconTheme: IconThemeData(color: accentColor, size: 36),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/ecos-nome.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(
              'Ecos do Mestre',
              style: TextStyle(
                fontFamily: 'UncialAntiqua',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      // Corpo da tela
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo central
                Image.asset(
                  'assets/images/ecos-nome.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                // Card de boas-vindas
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  color: const Color(0xFF424242).withOpacity(0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Bem-vindo ao Ecos do Mestre!\n\n'
                      'Organize suas campanhas de RPG de forma prática e criativa. '
                      'Este app é a ferramenta perfeita para mestres planejarem suas aventuras, '
                      'gerenciar NPCs e controlar todos os detalhes do seu universo. '
                      'Fique atento, pois em breve teremos um aplicativo especial para jogadores.',
                      style: TextStyle(fontSize: 18, color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Botão para explorar campanhas
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/campanhas');
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
                  child: Text(
                    'Explorar Campanhas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'UncialAntiqua',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
