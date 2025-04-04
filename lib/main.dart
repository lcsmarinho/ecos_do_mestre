import 'package:flutter/material.dart';
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
  runApp(const EcosDoMestreApp());
}

class EcosDoMestreApp extends StatelessWidget {
  const EcosDoMestreApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecos do Mestre',
      theme: ThemeData(
        primaryColor: const Color(0xFF121212),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
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
          if (args != null && args.containsKey('id')) {
            return AventuraDetailPage(adventureId: args['id']);
          }
          return AventuraDetailPage(
            adventureId: DateTime.now().millisecondsSinceEpoch.toString(),
          );
        },
        '/minhasAventuras': (context) => const MinhasAventurasPage(),
        '/anotacoes': (context) => const AnotacoesPage(),
        '/fichas': (context) => const FichasPage(),
        '/fichasDetalhe':
            (context) =>
                const FichasDetailPage(), // Rota para Fichas Detalhadas
      },
    );
  }
}
