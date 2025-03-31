import 'package:flutter/material.dart';
import 'pages/home_screen.dart';
import 'pages/campaigns_page.dart';
import 'pages/campaign_detail_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecos do Mestre',
      theme: ThemeData(primaryColor: Color(0xFF121212)),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/campanhas': (context) => CampaignsPage(),
        '/campanhaDetalhe': (context) => CampaignDetailPage(),
      },
    );
  }
}
