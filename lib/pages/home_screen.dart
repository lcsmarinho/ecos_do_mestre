import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_dialog.dart'; // Certifique-se de que o caminho esteja correto

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Color primaryColor = const Color(0xFF0D3B26);
  final Color accentColor = const Color(0xFF1B5E20);
  final Color backgroundColor = const Color(0xFF121212);

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Exibe o WelcomeDialog após o primeiro frame, se ainda não foi desativado
    WidgetsBinding.instance.addPostFrameCallback((_) => _showWelcomeDialog());
  }

  Future<void> _showWelcomeDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hideWelcomePopup = prefs.getBool('hideWelcomePopup') ?? false;
    if (!hideWelcomePopup) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const WelcomeDialog(),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToCampanhas() {
    Navigator.pushNamed(context, '/campanhas');
  }

  void _navigateToMinhasAventuras() {
    Navigator.pushNamed(context, '/minhasAventuras');
  }

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
              // (Itens do menu permanecem inalterados)
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
              const Divider(color: Colors.white24),
              ListTile(
                tileColor: const Color(0xFF2E2E2E),
                leading: const Icon(Icons.explore, color: Colors.white),
                title: const Text(
                  'Minhas Aventuras',
                  style: TextStyle(
                    fontFamily: 'UncialAntiqua',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/minhasAventuras');
                },
              ),
              const Divider(color: Colors.white24),
              ListTile(
                tileColor: const Color(0xFF2E2E2E),
                leading: const Icon(Icons.person, color: Colors.white),
                title: const Text(
                  'Fichas de Personagens',
                  style: TextStyle(
                    fontFamily: 'UncialAntiqua',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/fichas');
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: IconButton(
                icon: const Icon(Icons.menu, size: 36),
                color: accentColor,
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
              ),
            );
          },
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
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [backgroundColor, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 32.0,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bem-vindo, Mestre!',
                      style: TextStyle(
                        fontFamily: 'UncialAntiqua',
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Color(0xFF1B5E20),
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Este app foi criado para ajudar mestres de RPG a organizar e conduzir campanhas de forma prática e inspiradora. Descubra as funcionalidades que tornarão suas sessões inesquecíveis!',
                      style: TextStyle(
                        fontFamily: 'UncialAntiqua',
                        fontSize: 18,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Botões empilhados verticalmente
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: _navigateToCampanhas,
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
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _navigateToMinhasAventuras,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
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
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
