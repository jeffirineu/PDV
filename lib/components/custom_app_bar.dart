import 'package:flutter/material.dart';

// A interface PreferredSizeWidget é requerida estruturalmente para a implementação de componentes AppBar customizados
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int? tableNumber; // Identificador numérico da mesa (anulável para contextos de navegação global)
  final bool showBackButton; // Flag de controle para exibição do componente de navegação reversa

  const CustomAppBar({
    super.key,
    required this.title,
    this.tableNumber,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64.0,
      shape: const Border(
        bottom: BorderSide(
          color: Color.fromARGB(255, 206, 206, 206),
          width: 0.5,
        ),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),

      // Controle de roteamento reverso acionado pelo parâmetro showBackButton
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
          : null,

      // Renderização do título dinâmico da tela de contexto
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,

      // Renderização condicional do painel de ações superior (Action Panel)
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            // Avaliação de estado para exibição do badge numérico da mesa
            child: tableNumber != null
                ? Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withValues(alpha: 0.4),
                          blurRadius: 8.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$tableNumber',
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                // Fallback para exibição do avatar do usuário em telas de escopo global
                : GestureDetector(
                    onTap: () => print("Chamada à rotina de perfil acionada"),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 2.0,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 18.0, 
                        backgroundImage: NetworkImage(
                          'https://picsum.photos/200',
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64.0);
}