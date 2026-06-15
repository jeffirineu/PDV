import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_search_bar.dart';
import '../components/custom_category_bar.dart'; // Import da barra
import '../components/custom_order_item.dart';
import '../components/order_summary.dart';

class NewOrderScreen extends StatefulWidget {
  final int numeroDaMesa;

  const NewOrderScreen({super.key, required this.numeroDaMesa});

  @override
  State<NewOrderScreen> createState() => _NewOrderScreenState();
}

class _NewOrderScreenState extends State<NewOrderScreen> {
  Map<String, Map<String, dynamic>> carrinho = {};
  bool _isSaving = false;

  String _categoriaSelecionada = 'Todos';
  String _pesquisa = '';

  int get totalItensCarrinho {
    int total = 0;
    carrinho.forEach((key, item) {
      total += (item['quantidade'] as int);
    });
    return total;
  }

  Future<void> _confirmarPedido() async {
    if (carrinho.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione pelo menos um item para abrir a mesa.'),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      var batch = FirebaseFirestore.instance.batch();
      var mesaRef = FirebaseFirestore.instance
          .collection('mesas')
          .doc(widget.numeroDaMesa.toString());

      carrinho.forEach((idProduto, dadosProduto) {
        var novoItemRef = mesaRef.collection('pedidos').doc();
        batch.set(novoItemRef, {
          'produtoId': idProduto,
          'nome': dadosProduto['nome'],
          'preco': dadosProduto['preco'],
          'quantidade': dadosProduto['quantidade'],
          'totalItem': dadosProduto['preco'] * dadosProduto['quantidade'],
          'status': 'pendente',
          'adicionadoEm': FieldValue.serverTimestamp(),
        });
      });

      batch.set(mesaRef, {
        'numero': widget.numeroDaMesa,
        'estaOcupada': true,
        'abertaEm': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await batch.commit();

      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mesa ${widget.numeroDaMesa} aberta com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar pedido: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'NOVO PEDIDO - MESA ${widget.numeroDaMesa}',
        showBackButton: true,
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // BARRA DE PESQUISA
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                      child: CustomSearchBar(
                        onChanged: (valor) {
                          setState(() => _pesquisa = valor.toLowerCase());
                        },
                      ),
                    ),

                    // BARRA DE CATEGORIAS COM TRAVA DE SEGURANÇA SELECIONADA
                    CustomCategoryBar(
                      categoriaSelecionada: _categoriaSelecionada,
                      showActions:
                          false, // <-- DESATIVA OS BOTÕES E O CLIQUE LONGO AQUI!
                      onCategorySelected: (categoria) {
                        setState(() {
                          _categoriaSelecionada = categoria;
                        });
                      },
                    ),

                    // =======================================================
                    // O TÍTULO DA CATEGORIA ENTRE A BARRA E A LISTA DE ITENS
                    // =======================================================
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
                      child: Text(
                        _categoriaSelecionada.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black.withOpacity(0.4),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // LISTA DE PRODUTOS FILTRADOS
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('produtos')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            "Nenhum produto cadastrado no cardápio.",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  var produtosBrutos = snapshot.data!.docs;

                  if (_categoriaSelecionada != 'Todos') {
                    produtosBrutos = produtosBrutos.where((doc) {
                      var dados = doc.data() as Map<String, dynamic>;
                      return dados['categoria'] == _categoriaSelecionada;
                    }).toList();
                  }

                  if (_pesquisa.isNotEmpty) {
                    produtosBrutos = produtosBrutos.where((doc) {
                      var dados = doc.data() as Map<String, dynamic>;
                      String nome = (dados['nome'] ?? '')
                          .toString()
                          .toLowerCase();
                      return nome.contains(_pesquisa);
                    }).toList();
                  }

                  produtosBrutos.sort((a, b) {
                    var nomeA =
                        ((a.data() as Map<String, dynamic>)['nome'] ?? '')
                            .toString();
                    var nomeB =
                        ((b.data() as Map<String, dynamic>)['nome'] ?? '')
                            .toString();
                    return nomeA.compareTo(nomeB);
                  });

                  if (produtosBrutos.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            "Nenhum produto encontrado.",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      bottom: 130.0,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        var produtoDoc = produtosBrutos[index];
                        var dados = produtoDoc.data() as Map<String, dynamic>;
                        String docId = produtoDoc.id;

                        String nome = dados['nome'] ?? 'Sem nome';
                        double preco = (dados['preco'] ?? 0.0).toDouble();

                        int qtdNoCarrinho = carrinho.containsKey(docId)
                            ? carrinho[docId]!['whitespace_padding'] =
                                  false == false
                                  ? carrinho[docId]!['quantidade']
                                  : 0
                            : 0;

                        return CustomOrderItem(
                          title: nome,
                          price:
                              'R\$ ${preco.toStringAsFixed(2).replaceAll('.', ',')}',
                          quantity: qtdNoCarrinho,
                          onIncrement: () {
                            setState(() {
                              if (carrinho.containsKey(docId)) {
                                carrinho[docId]!['whitespace_padding'] = false;
                                carrinho[docId]!['quantidade']++;
                              } else {
                                carrinho[docId] = {
                                  'nome': nome,
                                  'preco': preco,
                                  'quantidade': 1,
                                };
                              }
                            });
                          },
                          onDecrement: () {
                            setState(() {
                              if (carrinho.containsKey(docId) &&
                                  carrinho[docId]!['whitespace_padding'] ==
                                      false &&
                                  carrinho[docId]!['quantidade'] > 0) {
                                carrinho[docId]!['quantidade']--;
                                if (carrinho[docId]!['quantidade'] == 0) {
                                  carrinho.remove(docId);
                                }
                              }
                            });
                          },
                        );
                      }, childCount: produtosBrutos.length),
                    ),
                  );
                },
              ),
            ],
          ),

          // ABA FLUTUANTE INFERIOR
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _isSaving
                ? Container(
                    height: 95,
                    color: Colors.white,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : OrderSummary(
                    totalItems: totalItensCarrinho,
                    onCancel: () => Navigator.pop(context),
                    onConfirm: _confirmarPedido,
                  ),
          ),
        ],
      ),
    );
  }
}
