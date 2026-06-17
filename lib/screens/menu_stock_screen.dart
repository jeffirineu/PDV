import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/custom_category_bar.dart';
import '../components/custom_action_button.dart';
import '../components/unified_item_card.dart';
import 'new_product_screen.dart';

class MenuStockScreen extends StatefulWidget {
  const MenuStockScreen({super.key});

  @override
  State<MenuStockScreen> createState() => _MenuStockScreenState();
}

class _MenuStockScreenState extends State<MenuStockScreen> {
  String categoriaSelecionada = 'Todos';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCategoryBar(
          categoriaSelecionada: categoriaSelecionada,
          onCategorySelected: (novaCat) {
            setState(() => categoriaSelecionada = novaCat);
          },
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            categoriaSelecionada,
            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: categoriaSelecionada == 'Todos'
                ? FirebaseFirestore.instance.collection('produtos').snapshots()
                : FirebaseFirestore.instance
                    .collection('produtos')
                    .where('categoria', isEqualTo: categoriaSelecionada)
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final produtos = snapshot.data!.docs;

              if (produtos.isEmpty) {
                return const Center(
                  child: Text("Nenhum produto nesta categoria."),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: produtos.length,
                itemBuilder: (context, index) {
                  final data = produtos[index].data() as Map<String, dynamic>;

                  // Renderização do componente de exibição de dados com ações de manipulação de registro
                  return UnifiedItemCard(
                    title: data['nome'] ?? 'Sem nome',
                    price:
                        'R\$ ${data['preco'].toString().replaceAll('.', ',')}',
                    category: data['categoria'] ?? 'Sem categoria',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NewProductScreen(),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => produtos[index].reference.delete(),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: CustomActionButton(
            label: 'CRIAR PRODUTO',
            icon: Icons.add_circle_outline,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewProductScreen()),
            ),
          ),
        ),
      ],
    );
  }
}
