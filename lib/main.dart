import 'package:flutter/material.dart';
import 'pages/home_screen.dart';
import 'pages/campaigns_page.dart';

void main() {
  runApp(EcosDoMestreApp());
}

class EcosDoMestreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ecos do Mestre',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/campanhas': (context) => CampaignsPage(),
      },
    );
  }
}
