import 'package:flutter/material.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a largura do indicador de arrasto como 70% da largura da tela
    final double handleWidth = MediaQuery.of(context).size.width * 0.7;

    return DraggableScrollableSheet(
      // Proporção inicial e mínima da folha (14% da altura da tela), exibindo apenas o cabeçalho
      initialChildSize: 0.14,
      minChildSize: 0.14,
      // Proporção máxima da folha (100% da altura da tela)
      maxChildSize: 1.0,
      // Habilita o comportamento magnético de encaixe ao soltar a folha
      snap: true,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50.0),
              topRight: Radius.circular(50.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20.0,
                offset: const Offset(0, -5), // Projeção da sombra para a área superior
              ),
            ],
          ),
          // O ListView é acoplado ao scrollController para permitir a expansão da folha e rolagem interna
          child: ListView(
            controller: scrollController,
            // Preenchimento inferior inserido para evitar sobreposição da lista com componentes fixos da tela base
            padding: const EdgeInsets.only(top: 16.0, bottom: 100.0),
            children: [
              // Elemento visual indicador de arrasto (Handle)
              Center(
                child: Container(
                  width: handleWidth,
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // Contêiner de resumo de itens selecionados
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: Colors.blueAccent.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Indicador numérico de itens
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Text(
                          '10',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                      // Rótulo descritivo do contêiner
                      const Text(
                        'itens selecionados',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),

              // Geração da lista de itens do carrinho com dados simulados para estruturação visual
              ...List.generate(10, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        // Seção de informações textuais do item
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hambúrguer Artesanal ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'R\$ 25,00',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Controles de manipulação de quantidade do item
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => print("Rotina de decremento acionada"),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.redAccent.withValues(alpha: 0.5),
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.all(6.0),
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.redAccent,
                                  size: 20.0,
                                ),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                '1', // Valor estático correspondente à quantidade atual
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => print("Rotina de incremento acionada"),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.all(6.0),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
