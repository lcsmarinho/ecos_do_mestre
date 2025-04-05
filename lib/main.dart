import 'dart:async';
import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'pages/home_screen.dart';
import 'pages/campaigns_page.dart';
import 'pages/campaign_detail_page.dart';
import 'pages/bestiary_page.dart';
import 'pages/bestiary_detail_page.dart';
import 'pages/itens_page.dart';
import 'pages/itens_detail_page.dart';
import 'pages/dice_page.dart';
import 'pages/encounter_page.dart';
import 'pages/encounter_result_page.dart';
import 'pages/magias_page.dart';
import 'pages/magias_detail_page.dart';
import 'pages/about_page.dart';
import 'pages/minhas_aventuras_page.dart';
import 'pages/aventura_detail_page.dart';
import 'pages/anotacoes_page.dart';
import 'pages/fichas_page.dart';
import 'pages/fichas_detail_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const EcosDoMestreApp());
}

class EcosDoMestreApp extends StatefulWidget {
  const EcosDoMestreApp({Key? key}) : super(key: key);

  @override
  _EcosDoMestreAppState createState() => _EcosDoMestreAppState();
}

class _EcosDoMestreAppState extends State<EcosDoMestreApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    // Aguarda 1 segundo antes de mostrar a HomeScreen
    Timer(const Duration(seconds: 1), () {
      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecos do Mestre',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF121212),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      // Enquanto _showSplash for true, exibe o SplashScreen; depois, a HomeScreen.
      home: _showSplash ? const SplashScreen() : const HomeScreen(),
      routes: {
        '/campanhas': (context) => const CampaignsPage(),
        '/campanhaDetalhe': (context) => const CampaignDetailPage(),
        '/bestiary': (context) => const BestiaryPage(),
        '/bestiaryDetalhe': (context) => const BestiaryDetailPage(),
        '/itens': (context) => const ItensPage(),
        '/itensDetalhe': (context) => const ItensDetailPage(),
        '/dados': (context) => const DicePage(),
        '/encontro': (context) => const EncounterPage(),
        '/encontroResultado': (context) => const EncounterResultPage(),
        '/magias': (context) => const MagiasPage(),
        '/magiasDetalhe': (context) => const MagiasDetailPage(),
        '/sobre': (context) => const AboutPage(),
        '/aventuraDetalhe': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>?;
          final id =
              args != null && args.containsKey('id')
                  ? args['id']
                  : DateTime.now().millisecondsSinceEpoch.toString();
          return AventuraDetailPage(adventureId: id);
        },
        '/minhasAventuras': (context) => const MinhasAventurasPage(),
        '/anotacoes': (context) => const AnotacoesPage(),
        '/fichas': (context) => const FichasPage(),
        '/fichasDetalhe': (context) => const FichasDetailPage(),
      },
    );
  }
}
