import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  // Definindo as cores com valores hexadecimais
  final Color primaryColor = Color(0xFF0D3B26); // Verde Lovecraft escuro
  final Color accentColor = Color(0xFF1B5E20); // Verde de destaque, tom escuro
  final Color backgroundColor = Color(0xFF121212); // Fundo para a aplicação
  final Color cardBackgroundColor = Color(0xFF424242); // Fundo do card
  final Color drawerBoxColor = Color(0xFF2C2C2C); // Fundo da "caixa" do menu
  final Color drawerBoxShadowColor = Color(
    0xFF1B5E20,
  ); // Sombra verde para as caixas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // Drawer (menu lateral) com fundo em gradiente de verde escuro para preto
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, Colors.black],
              stops: [0.0, 0.25],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Cabeçalho do menu com altura reduzida e gradiente similar
              Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, Colors.black],
                    stops: [0.0, 0.25],
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
              // Item do menu em caixa estilizada
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: drawerBoxColor,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: drawerBoxShadowColor,
                        blurRadius: 4,
                        offset: Offset(2, 2),
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
            ],
          ),
        ),
      ),
      // AppBar com o logo e título usando a fonte dark fantasy
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: accentColor,
          size: 36, // Ícone do menu aumentado
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/ecos-nome.png',
              height: 40,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8),
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
      // Corpo com fundo em gradiente escuro
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Exibe o logo em destaque na tela inicial
                  Image.asset(
                    'assets/images/ecos-nome.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 24),
                  // Card de boas-vindas com fundo semi-transparente
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: cardBackgroundColor.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Bem-vindo ao Ecos do Mestre!\n\n'
                        'Organize suas campanhas de RPG de forma prática e criativa. '
                        'Este app é a ferramenta perfeita para mestres planejarem suas aventuras, '
                        'gerenciar NPCs e controlar todos os detalhes do seu universo. '
                        'Fique atento, pois em breve teremos um aplicativo especial para jogadores.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white70,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  // Botão de call-to-action para explorar campanhas, com fonte dark fantasy
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/campanhas');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      padding: EdgeInsets.symmetric(
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
      ),
    );
  }
}
