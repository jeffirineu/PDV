import 'package:flutter/material.dart';

// O "implements PreferredSizeWidget" é uma regra obrigatória do Flutter
// sempre que você cria uma AppBar personalizada do zero.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int?
  tableNumber; // O "?" significa que pode ser nulo (ou seja, não ter mesa)
  final bool showBackButton; // Para a Home não ter a seta de voltar

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

      // Lógica da Seta de Voltar: Se for true, mostra a seta. Se false, não mostra nada.
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            )
          : null,

      // O Título Dinâmico (CARDÁPIO, MESAS, VENDAS...)
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      centerTitle: true,

      // Lógica da Direita (Mesa vs Perfil)
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Center(
            // Se tableNumber for diferente de nulo, mostra o Círculo da Mesa
            child: tableNumber != null
                ? Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.4),
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
                // Se tableNumber for nulo, mostra a Foto de Perfil
                : GestureDetector(
                    onTap: () => print("Perfil clicado!"),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 2.0,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 18, // Ajustado ligeiramente para caber melhor
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
