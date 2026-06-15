import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryDialogUtils {
  // --- DIÁLOGO REUTILIZÁVEL (CRIAR E EDITAR) ---
  static void mostrarDialogCategoria(
    BuildContext context, {
    String? docId,
    String? nomeAtual,
    String? emojiAtual,
    Function(String)? onSaved, // Avisa a tela qual foi o nome salvo
  }) {
    TextEditingController nomeController = TextEditingController(
      text: nomeAtual ?? '',
    );
    String emojiSelecionado = emojiAtual ?? '🍔';
    bool isEditando = docId != null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(
                isEditando ? "Editar Categoria" : "Nova Categoria",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Toque no ícone para escolher:",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: () {
                      abrirSeletorExclusivoComida(context, (emojiEscolhido) {
                        setStateDialog(() {
                          emojiSelecionado = emojiEscolhido;
                        });
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.blueAccent.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        emojiSelecionado,
                        style: const TextStyle(fontSize: 40.0),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24.0),
                  TextField(
                    controller: nomeController,
                    decoration: InputDecoration(
                      labelText: "Nome da Categoria",
                      hintText: "Ex: Pizzas",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  onPressed: () async {
                    if (nomeController.text.trim().isNotEmpty) {
                      String nomeFinal = nomeController.text.trim();

                      if (isEditando) {
                        await FirebaseFirestore.instance
                            .collection('categorias')
                            .doc(docId)
                            .update({
                              'nome': nomeFinal,
                              'emoji': emojiSelecionado,
                            });
                      } else {
                        await FirebaseFirestore.instance
                            .collection('categorias')
                            .add({
                              'nome': nomeFinal,
                              'emoji': emojiSelecionado,
                            });
                      }

                      // Dispara a função de aviso se a tela pediu
                      if (onSaved != null) {
                        onSaved(nomeFinal);
                      }

                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    "Salvar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --- SELETOR DE EMOJIS REUTILIZÁVEL ---
  static void abrirSeletorExclusivoComida(
    BuildContext context,
    Function(String) onEmojiSelected,
  ) {
    final List<String> cardapioEmojis = [
      '🍽️',
      '🍔',
      '🍟',
      '🍕',
      '🌭',
      '🥪',
      '🌮',
      '🌯',
      '🫓',
      '🥙',
      '🧆',
      '🥚',
      '🍳',
      '🥘',
      '🍲',
      '🫕',
      '🥣',
      '🥗',
      '🍿',
      '🧈',
      '🧂',
      '🥫',
      '🥟',
      '🥠',
      '🥐',
      '🥯',
      '🍞',
      '🥖',
      '🥨',
      '🧀',
      '🥩',
      '🍗',
      '肉',
      '🥓',
      '🧑‍🍳',
      '🍖',
      '🍤',
      '🦪',
      '🦞',
      '🦀',
      '🦑',
      '🐟',
      '🐠',
      '🍢',
      '🍣',
      '🥮',
      '🦬',
      '🍛',
      '🍜',
      '🍝',
      '🍠',
      '🍢',
      '🍣',
      '🍦',
      '🍧',
      '🍨',
      '🍩',
      '🍪',
      '🎂',
      '🍰',
      '🧁',
      '🥧',
      '🍫',
      '🍬',
      '🍭',
      '🍮',
      '🍯',
      '🍼',
      '🥛',
      '☕',
      '🫖',
      '🍵',
      '🍶',
      '🍾',
      '🍷',
      '🍸',
      '🍹',
      '🍺',
      '🍻',
      '🥂',
      '🥤',
      '🧋',
      '🧃',
      '🧉',
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Selecione o Ícone",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: cardapioEmojis.length,
                  itemBuilder: (ctx, i) {
                    return GestureDetector(
                      onTap: () {
                        onEmojiSelected(cardapioEmojis[i]);
                        Navigator.pop(ctx);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          cardapioEmojis[i],
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
