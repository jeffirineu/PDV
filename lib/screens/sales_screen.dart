import 'package:flutter/material.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // --- APP BAR PADRÃO ---
      appBar: AppBar(
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

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          'VENDAS',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => print("Perfil clicado!"),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueAccent, width: 2.0),
                ),
                child: const CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage('https://picsum.photos/200'),
                ),
              ),
            ),
          ),
        ],
      ),

      // --- CORPO DA PÁGINA (EM CONSTRUÇÃO) ---
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.insert_chart_outlined,
              size: 80.0,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16.0),
            Text(
              'TELA DE VENDAS',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'O histórico e faturamento aparecerão aqui.',
              style: TextStyle(fontSize: 14.0, color: Colors.grey[500]),
            ),
          ],
        ),
      ),

      // --- RODAPÉ PADRÃO ---
      bottomNavigationBar: Container(
        height: 80.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Color.fromARGB(255, 206, 206, 206),
              width: 0.5,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => print("Botão Mesas clicado"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 30),
              ),
              child: const Text(
                'MESAS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => print("Botão Cardápio clicado"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 30),
              ),
              child: const Text(
                'CARDÁPIO',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => print("Botão Vendas clicado"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 30),
              ),
              child: const Text(
                'VENDAS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
