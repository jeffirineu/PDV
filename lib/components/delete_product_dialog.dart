import 'package:flutter/material.dart';

class DeleteProductDialog extends StatelessWidget {
  const DeleteProductDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // A utilização do widget Dialog base permite a customização irrestrita das proporções do modal
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      elevation: 0,
      // Fundo transparente necessário para a aplicação de estilização customizada no container interno
      backgroundColor: Colors.transparent, 
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
        // Restringe a dimensão do eixo principal para ajustar-se dinamicamente ao conteúdo filho
        mainAxisSize: MainAxisSize.min, 
        children: [
          // 1. Composição visual indicativa de ação destrutiva (Alerta)
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
                  Icons.help, // Indicador secundário de confirmação de estado
                  color: Colors.amber,
                  size: 36.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),

          // 2. Cabeçalho tipográfico de confirmação da operação
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

          // 3. Container de sumarização da entidade alvo da exclusão
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                // Placeholder estrutural para a imagem representativa da entidade
                Container(
                  width: 56.0,
                  height: 56.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12.0),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://picsum.photos/100', // Mock de imagem para prototipação
                      ), 
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                
                // Rótulo textual de identificação da entidade
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

          // 4. Painel de ações binárias (Confirmação/Cancelamento)
          Row(
            children: [
              // Ação de cancelamento e fechamento (Dismiss) do modal
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
                    onPressed: () => Navigator.pop(context), // Desempilha a rota atual do navegador
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

              // Ação de confirmação (Commit) da operação destrutiva
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
                      Navigator.pop(context); // Remove o modal da pilha após execução do processamento
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
