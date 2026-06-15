import 'package:flutter/material.dart';

// Importando os componentes fixos da moldura
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_nav_bar.dart';
import '../theme/app_colors.dart';

// Importando os miolos (as fotos do porta-retrato)
import 'home_screen.dart';
import 'menu_stock_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;

  // 1. A lista com os miolos das telas
  final List<Widget> _screens = [
    const HomeScreen(),
    const MenuStockScreen(),
    const Center(child: Text('Tela de Vendas em construção...')),
  ];

  // 2. A lista de títulos que vão mudar dinamicamente na AppBar
  final List<String> _titles = ['MESAS', 'CARDÁPIO', 'VENDAS'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // A AppBar fica fixa aqui, mudando apenas o texto conforme o índice
      appBar: CustomAppBar(
        title: _titles[_currentIndex],
        showBackButton: false,
      ),

      // O IndexedStack segura todas as telas e só mostra a do índice atual
      body: IndexedStack(index: _currentIndex, children: _screens),

      // O Rodapé centralizado. A lógica agora é apenas dar um setState no índice!
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
