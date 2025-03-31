import 'package:flutter/material.dart';
import 'pages/home_screen.dart';
import 'pages/campaigns_page.dart';
import 'pages/campaign_detail_page.dart';
import 'pages/bestiary_page.dart';
import 'pages/bestiary_detail_page.dart';
import 'pages/itens_page.dart';
import 'pages/itens_detail_page.dart';
import 'pages/dice_page.dart';

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
      },
    );
  }
}
