import 'package:flutter/material.dart';

// Importação dos componentes estruturais da interface
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_nav_bar.dart';
import '../theme/app_colors.dart';

// Importação das telas que compõem a navegação principal
import 'home_screen.dart';
import 'menu_stock_screen.dart';

class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;

  // Lista de componentes correspondentes às telas disponíveis na navegação
  final List<Widget> _screens = [
    const HomeScreen(),
    const MenuStockScreen(),
    const Center(child: Text('Tela de Vendas em construção...')),
  ];

  // Lista de títulos dinâmicos vinculados aos índices das telas
  final List<String> _titles = ['MESAS', 'CARDÁPIO', 'VENDAS'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      // Barra superior com atualização dinâmica do título com base no índice atual
      appBar: CustomAppBar(
        title: _titles[_currentIndex],
        showBackButton: false,
      ),

      // Utiliza IndexedStack para preservar o estado interno das telas enquanto não estão visíveis
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      // Gerenciamento de estado da barra de navegação inferior
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
