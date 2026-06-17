import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/custom_search_bar.dart';
import '../components/custom_table_card.dart';

import 'table_details_screen.dart';
import 'new_order_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  // Rotina de inicialização em lote para popular a coleção "mesas" no Firestore
  Future<void> _forcarCriacaoDasMesas() async {
    setState(() => _isLoading = true);

    try {
      var batch = FirebaseFirestore.instance.batch();

      for (int i = 1; i <= 60; i++) {
        var docRef = FirebaseFirestore.instance
            .collection('mesas')
            .doc(i.toString());
        batch.set(docRef, {'numero': i, 'estaOcupada': false});
      }

      await batch.commit();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ 60 Mesas criadas com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Tratamento e exibição de exceções de integridade ou permissão do banco de dados
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🚨 ERRO NO FIREBASE: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 10),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomSearchBar(
            onChanged: (valorDigitado) {
              // Registro de depuração da entrada de pesquisa
              print("Pesquisando mesa: $valorDigitado");
            },
          ),
          const SizedBox(height: 24.0),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('mesas')
                  .orderBy('numero')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro na conexão: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                // Renderização condicional para base de dados vazia (Estado de Inicialização)
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.table_restaurant,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'O salão está vazio.',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.build,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'GERAR 60 MESAS AGORA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onPressed: _forcarCriacaoDasMesas,
                              ),
                      ],
                    ),
                  );
                }

                // Renderização da grade de mesas com base no estado recuperado
                var mesasDoBanco = snapshot.data!.docs;

                return GridView.builder(
                  itemCount: mesasDoBanco.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (context, index) {
                    var mesaDados =
                        mesasDoBanco[index].data() as Map<String, dynamic>;
                    int numeroDaMesa = mesaDados['numero'] ?? (index + 1);
                    bool isOcupada = mesaDados['estaOcupada'] ?? false;

                    return CustomTableCard(
                      tableNumber: numeroDaMesa,
                      isOccupied: isOcupada,
                      onTap: () {
                        // Direcionamento do fluxo de navegação baseado no estado de ocupação
                        if (isOcupada) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TableDetailsScreen(
                                numeroDaMesa: numeroDaMesa,
                              ),
                            ),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewOrderScreen(numeroDaMesa: numeroDaMesa),
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
