import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Importe o Firebase

// TIREI AS BARRAS DESTA LINHA ABAIXO:
import 'firebase_options.dart';

import 'screens/base_screen.dart';

void main() async {
  // 1. Manda o Flutter preparar a ponte com o Android/iOS
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Acorda o Firebase ANTES de carregar qualquer tela
  await Firebase.initializeApp(
    // TIREI AS BARRAS DA LINHA ABAIXO TAMBÉM:
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Só agora roda o aplicativo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meu Restaurante',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: const BaseScreen(), // Sua tela de moldura
    );
  }
}
