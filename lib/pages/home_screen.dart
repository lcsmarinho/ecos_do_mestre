import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Color primaryColor = const Color(0xFF0D3B26); // Verde Lovecraft escuro
  final Color accentColor = const Color(0xFF1B5E20); // Verde de destaque
  final Color backgroundColor = const Color(0xFF121212); // Fundo da aplicação

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,
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
                    fontFamily: 'UncialAntiqua',
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Item: Campanhas
              ListTile(
                tileColor: const Color(0xFF2E2E2E),
                leading: const Icon(Icons.book, color: Colors.white),
                title: const Text(
                  'Campanhas',
                  style: TextStyle(
                    fontFamily: 'UncialAntiqua',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/campanhas');
                },
              ),
              const Divider(color: Colors.white24),
              // Item: Bestiário
              ListTile(
                tileColor: const Color(0xFF2E2E2E),
                leading: const Icon(Icons.pets, color: Colors.white),
                title: const Text(
                  'Bestiário',
                  style: TextStyle(
                    fontFamily: 'UncialAntiqua',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/bestiary');
                },
              ),
              const Divider(color: Colors.white24),
              // Item: Itens
              ListTile(
                tileColor: const Color(0xFF2E2E2E),
                leading: const Icon(Icons.inventory, color: Colors.white),
                title: const Text(
                  'Itens',
                  style: TextStyle(
                    fontFamily: 'UncialAntiqua',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/itens');
                },
              ),
              const Divider(color: Colors.white24),
              // Item: Dados
              ListTile(
                tileColor: const Color(0xFF2E2E2E),
                leading: const Icon(Icons.casino, color: Colors.white),
                title: const Text(
                  'Dados',
                  style: TextStyle(
                    fontFamily: 'UncialAntiqua',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/dados');
                },
              ),
              const Divider(color: Colors.white24),
              // Item: Encontros
              ListTile(
                tileColor: const Color(0xFF2E2E2E),
                leading: const Icon(Icons.flash_on, color: Colors.white),
                title: const Text(
                  'Encontros',
                  style: TextStyle(
                    fontFamily: 'UncialAntiqua',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/encontro');
                },
              ),
              const Divider(color: Colors.white24),
              // Item: Magias
              ListTile(
                tileColor: const Color(0xFF2E2E2E),
                leading: const Icon(Icons.auto_stories, color: Colors.white),
                title: const Text(
                  'Magias',
                  style: TextStyle(
                    fontFamily: 'UncialAntiqua',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/magias');
                },
              ),
              const Divider(color: Colors.white24),
              // Item: Sobre
              ListTile(
                tileColor: const Color(0xFF2E2E2E),
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text(
                  'Sobre',
                  style: TextStyle(
                    fontFamily: 'UncialAntiqua',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/sobre');
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 36),
          color: accentColor,
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: Row(
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
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 200) {
            _scaffoldKey.currentState?.openDrawer();
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/ecos-nome.png',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Bem-vindo ao Ecos do Mestre!',
                      style: TextStyle(
                        fontFamily: 'UncialAntiqua',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Color(0xFF1B5E20),
                            offset: Offset(1, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Use este app para criar, organizar e gerenciar suas campanhas de D&D 5e com estilo. Monte encontros, gerencie bestiários, itens e dados – tudo para transformar suas sessões em aventuras épicas. Em breve, versão exclusiva para jogadores!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
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
                          fontFamily: 'UncialAntiqua',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Se por acaso o app quebrar, baixe ele novamente*',
                  style: const TextStyle(
                    fontSize: 8,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
