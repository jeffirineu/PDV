import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomCategoryBar extends StatefulWidget {
  final String categoriaSelecionada;
  final Function(String) onCategorySelected;
  final bool showActions; // <-- NOVA PROPRIEDADE PARA CONTROLAR OS BOTÕES

  const CustomCategoryBar({
    super.key,
    required this.categoriaSelecionada,
    required this.onCategorySelected,
    this.showActions = true, // Por padrão, os botões aparecem
  });

  @override
  State<CustomCategoryBar> createState() => _CustomCategoryBarState();
}

class _CustomCategoryBarState extends State<CustomCategoryBar> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _verificarECriarCategoriasPadrao();
  }

  Future<void> _verificarECriarCategoriasPadrao() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('categorias')
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      List<Map<String, String>> categoriasDeFabrica = [
        {'nome': 'Refeições & Pratos', 'emoji': '🍽️'},
        {'nome': 'Lanches', 'emoji': '🍔'},
        {'nome': 'Petiscos', 'emoji': '🥟'},
        {'nome': 'Doces', 'emoji': '🍰'},
        {'nome': 'Sobremesas', 'emoji': '🍨'},
        {'nome': 'Bebidas', 'emoji': '🥤'},
      ];

      var batch = FirebaseFirestore.instance.batch();
      for (var cat in categoriasDeFabrica) {
        var docRef = FirebaseFirestore.instance.collection('categorias').doc();
        batch.set(docRef, cat);
      }
      await batch.commit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CABEÇALHO
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CATEGORIAS',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                  letterSpacing: 1.0,
                ),
              ),
              IconButton(
                icon: Icon(
                  _isExpanded ? Icons.unfold_less : Icons.unfold_more,
                  color: Colors.blueAccent,
                ),
                onPressed: () {
                  setState(() => _isExpanded = !_isExpanded);
                },
              ),
            ],
          ),
        ),

        // STREAM DA LISTA
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('categorias')
              .orderBy('nome')
              .snapshots(),
          builder: (context, snapshot) {
            List<Map<String, dynamic>> categorias = [
              {'id': 'todos', 'nome': 'Todos', 'emoji': '📋'},
            ];

            if (snapshot.hasData) {
              for (var doc in snapshot.data!.docs) {
                var data = doc.data() as Map<String, dynamic>;
                categorias.add({
                  'id': doc.id,
                  'nome': data['nome'].toString(),
                  'emoji': data.containsKey('emoji')
                      ? data['emoji'].toString()
                      : '🏷️',
                });
              }
            }

            String? idSelecionado;
            if (widget.categoriaSelecionada != 'Todos') {
              try {
                idSelecionado = categorias.firstWhere(
                  (cat) => cat['nome'] == widget.categoriaSelecionada,
                )['id'];
              } catch (_) {}
            }

            bool podeExcluir = idSelecionado != null;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isExpanded ? 240.0 : 85.0,
                  child: _isExpanded
                      ? _buildGridView(categorias)
                      : _buildListView(categorias),
                ),

                // SÓ MOSTRA OS BOTÕES SE SHOWACTIONS FOR TRUE
                if (widget.showActions)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.green.shade700,
                              side: BorderSide(color: Colors.green.shade300),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            icon: const Icon(Icons.add_circle_outline),
                            label: const Text(
                              'Adicionar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => _mostrarDialogCategoria(context),
                          ),
                        ),
                        const SizedBox(width: 12.0),
                        Expanded(
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: podeExcluir
                                  ? Colors.red.shade700
                                  : Colors.grey,
                              side: BorderSide(
                                color: podeExcluir
                                    ? Colors.red.shade300
                                    : Colors.grey.shade300,
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            icon: const Icon(Icons.delete_outline),
                            label: const Text(
                              'Excluir',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: podeExcluir
                                ? () => _excluirCategoria(
                                    context,
                                    idSelecionado!,
                                    widget.categoriaSelecionada,
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildListView(List<Map<String, dynamic>> categorias) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemCount: categorias.length,
      itemBuilder: (context, index) => _buildCategoriaItem(categorias[index]),
    );
  }

  Widget _buildGridView(List<Map<String, dynamic>> categorias) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.8,
      ),
      itemCount: categorias.length,
      itemBuilder: (context, index) => _buildCategoriaItem(categorias[index]),
    );
  }

  Widget _buildCategoriaItem(Map<String, dynamic> catData) {
    String id = catData['id'];
    String nome = catData['nome'];
    String emoji = catData['emoji'];
    bool isSelected = nome == widget.categoriaSelecionada;

    return GestureDetector(
      onTap: () => widget.onCategorySelected(nome),
      onLongPress: () {
        // SÓ PERMITE EDITAR NO CLIQUE LONGO SE SHOWACTIONS FOR TRUE
        if (widget.showActions && id != 'todos') {
          _mostrarDialogCategoria(
            context,
            docId: id,
            nomeAtual: nome,
            emojiAtual: emoji,
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        width: 75.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blueAccent.withOpacity(0.1)
                    : Colors.grey.shade100,
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: Colors.blueAccent, width: 2)
                    : null,
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 24.0)),
            ),
            const SizedBox(height: 6.0),
            Text(
              nome,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.blueAccent : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogCategoria(
    BuildContext context, {
    String? docId,
    String? nomeAtual,
    String? emojiAtual,
  }) {
    // Mantém a mesma lógica interna do diálogo...
  }

  void _abrirSeletorExclusivoComida(
    BuildContext context,
    Function(String) onEmojiSelected,
  ) {
    // Mantém a mesma lógica interna do seletor...
  }

  void _excluirCategoria(
    BuildContext context,
    String idDoDocumento,
    String nomeDaCategoria,
  ) {
    // Mantém a mesma lógica interna de exclusão...
  }
}
