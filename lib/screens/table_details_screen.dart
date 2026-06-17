import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_category_bar.dart';
import '../components/custom_search_bar.dart';
import '../components/unified_item_card.dart';

// Oculta a referência para evitar ambiguidade de nomenclatura no escopo de importação
import '../components/manage_item_dialog.dart' hide UnifiedItemCard;

import 'new_order_screen.dart';
import 'payment_screen.dart';

class TableDetailsScreen extends StatefulWidget {
  final int numeroDaMesa;

  const TableDetailsScreen({super.key, required this.numeroDaMesa});

  @override
  State<TableDetailsScreen> createState() => _TableDetailsScreenState();
}

class _TableDetailsScreenState extends State<TableDetailsScreen> {
  String _categoriaSelecionada = 'Todos';
  String _pesquisa = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'MESA ${widget.numeroDaMesa}',
        showBackButton: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCategoryBar(
            categoriaSelecionada: _categoriaSelecionada,
            showActions: false,
            onCategorySelected: (categoria) {
              setState(() => _categoriaSelecionada = categoria);
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 12.0),
            child: Text(
              'ITENS CONSUMIDOS',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black.withValues(alpha: 0.3),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomSearchBar(
              hintText: 'Buscar por nome...',
              keyboardType: TextInputType.text,
              onChanged: (valor) =>
                  setState(() => _pesquisa = valor.toLowerCase()),
            ),
          ),
          const SizedBox(height: 16.0),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('mesas')
                  .doc(widget.numeroDaMesa.toString())
                  .collection('pedidos')
                  .orderBy('adicionadoEm')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      "A conta está vazia.",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[400],
                      ),
                    ),
                  );
                }

                var todosPedidos = snapshot.data!.docs;
                var pedidosFiltrados = todosPedidos.where((doc) {
                  var dados = doc.data() as Map<String, dynamic>;
                  String nome = (dados['nome'] ?? '').toString().toLowerCase();
                  return nome.contains(_pesquisa);
                }).toList();

                if (pedidosFiltrados.isEmpty) {
                  return const Center(child: Text("Nenhum item encontrado."));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: pedidosFiltrados.length,
                  itemBuilder: (context, index) {
                    var itemDoc = pedidosFiltrados[index];
                    var dados = itemDoc.data() as Map<String, dynamic>;

                    String nome = dados['nome'] ?? 'Produto';
                    int quantidade = dados['quantidade'] ?? 1;

                    // Tratamento de consistência visual para categorias ausentes
                    String categoriaRaw = dados['categoria'] ?? '';
                    String categoriaDisplay = (categoriaRaw.isEmpty)
                        ? '-----'
                        : categoriaRaw;

                    double precoTotalDoItem = (dados['totalItem'] ?? 0)
                        .toDouble();

                    return UnifiedItemCard(
                      title: nome,
                      price:
                          'R\$ ${precoTotalDoItem.toStringAsFixed(2).replaceAll('.', ',')}',
                      category: '$categoriaDisplay | Qtd: $quantidade',
                      status: dados['status'],
                      trailing: IconButton(
                        icon: const Icon(Icons.edit, color: AppColors.primary),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ManageItemDialog(
                              itemName: nome,
                              initialQuantity: quantidade,
                              onDelete: () async {
                                await itemDoc.reference.update({
                                  'status': 'cancelado',
                                });
                                if (context.mounted) Navigator.pop(context);
                              },
                              onPay: () async {
                                await itemDoc.reference.update({
                                  'status': 'pago',
                                });
                                if (context.mounted) Navigator.pop(context);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('mesas')
            .doc(widget.numeroDaMesa.toString())
            .collection('pedidos')
            .snapshots(),
        builder: (context, snapshot) {
          double totalDaConta = 0;
          if (snapshot.hasData) {
            for (var doc in snapshot.data!.docs) {
              totalDaConta +=
                  ((doc.data() as Map<String, dynamic>)['totalItem'] ?? 0)
                      .toDouble();
            }
          }
          return _buildBottomActionGrid(context, totalDaConta);
        },
      ),
    );
  }

  Widget _buildBottomActionGrid(BuildContext context, double totalDaConta) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade300, width: 2.0),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NewOrderScreen(numeroDaMesa: widget.numeroDaMesa),
                ),
              ),
              child: const Text(
                'NOVO PEDIDO',
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentScreen(
                    totalConta: totalDaConta,
                    numeroDaMesa: widget.numeroDaMesa,
                  ),
                ),
              ),
              child: Text(
                'PAGAR R\$ ${totalDaConta.toStringAsFixed(2).replaceAll('.', ',')}',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}