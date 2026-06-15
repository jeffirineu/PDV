import 'package:flutter/material.dart';

class CartBottomSheet extends StatelessWidget {
  const CartBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Pegamos exatamente 70% da largura da tela do celular para a alça
    final double handleWidth = MediaQuery.of(context).size.width * 0.7;

    return DraggableScrollableSheet(
      // 0.14 = 14% da altura da tela. É o tamanho exato para mostrar só a alça e a pílula de resumo
      initialChildSize: 0.14,
      minChildSize: 0.14,
      // 1.0 = Pode subir até o teto (Logo abaixo da AppBar)
      maxChildSize: 1.0,
      snap:
          true, // Adiciona um "ímã" que ajuda a aba a abrir ou fechar de vez ao soltar

      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(
                50.0,
              ), // O arredondamento de 50 que você definiu no Figma
              topRight: Radius.circular(50.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20.0,
                offset: const Offset(0, -5), // Sombra projetada para cima
              ),
            ],
          ),

          // O ListView garante que arrastar a tela pra cima puxa a aba,
          // e quando a aba chegar no topo, ele rola os itens da lista.
          child: ListView(
            controller: scrollController,
            // Esse fundo de 100px garante que o último item da lista não fique
            // escondido atrás dos botões verdes e vermelhos da outra tela
            padding: const EdgeInsets.only(top: 16.0, bottom: 100.0),
            children: [
              // 1. A linha horizontal (Alça de puxar com 70% da tela)
              Center(
                child: Container(
                  width: handleWidth,
                  height: 5.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),

              // 2. O Retângulo com a pílula de quantidade e título
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(
                      0.08,
                    ), // Fundo azul bem clarinho
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: Colors.blueAccent.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      // A pílula interna com o número "10"
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
                      // O Título
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

              // 3. A Lista de Itens do Carrinho (Só aparece quando a aba é puxada para cima)
              // Aqui estamos simulando 10 itens já adicionados para você ver o design
              ...List.generate(10, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 8.0,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[50], // Cinza quase branco
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        // Nome do item da comanda
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

                        // Botões de Adicionar/Retirar do carrinho (+ e -)
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => print("Remover 1 do carrinho"),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                    color: Colors.redAccent.withOpacity(0.5),
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
                                '1', // Quantidade daquele item específico
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => print("Adicionar +1 no carrinho"),
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
