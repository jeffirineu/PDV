import 'package:flutter/material.dart';

class DeleteProductDialog extends StatelessWidget {
  const DeleteProductDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // O Dialog puro permite que a gente desenhe exatamente o retângulo vertical que você pediu
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      elevation: 0,
      backgroundColor: Colors
          .transparent, // Deixa o fundo transparente para desenharmos nosso próprio container
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 5.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize
            .min, // Faz o container abraçar o conteúdo (Retângulo vertical)
        children: [
          // 1. Composição de Ícones (Lixeira vermelha + Interrogação Amarela)
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              const Icon(
                Icons.delete_outline,
                color: Colors.redAccent,
                size: 80.0,
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.help, // Ícone de interrogação
                  color: Colors.amber,
                  size: 36.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // 2. Título Vermelho Chamativo
          const Text(
            'EXCLUIR PRODUTO?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'Tem certeza que deseja remover este item do cardápio?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          const SizedBox(height: 24.0),

          // 3. Resumo do Item (Foto + Nome do Produto)
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                // Foto Simulada do Item
                Container(
                  width: 56.0,
                  height: 56.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12.0),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://picsum.photos/100',
                      ), // Placeholder de imagem
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                // Nome Simulada do Item
                const Expanded(
                  child: Text(
                    'Hambúrguer Artesanal',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),

          // 4. Botões NÃO (Vermelho) e SIM (Verde)
          Row(
            children: [
              // Botão NÃO (X Vermelho)
              Expanded(
                child: SizedBox(
                  height: 50.0,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.redAccent,
                        width: 2.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.pop(context), // Apenas fecha o pop-up
                    icon: const Icon(
                      Icons.close,
                      color: Colors.redAccent,
                      size: 20.0,
                    ),
                    label: const Text(
                      'NÃO',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16.0),

              // Botão SIM (V Verde)
              Expanded(
                child: SizedBox(
                  height: 50.0,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00E676),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      print("Produto Excluído com sucesso!");
                      Navigator.pop(context); // Fecha o pop-up após a ação
                    },
                    icon: const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 20.0,
                    ),
                    label: const Text(
                      'SIM',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
