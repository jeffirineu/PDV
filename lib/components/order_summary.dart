import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'custom_bottom_button.dart';

class OrderSummary extends StatefulWidget {
  final int totalItems;
  // Callbacks para delegação de eventos de ciclo de vida do pedido
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const OrderSummary({
    super.key,
    required this.totalItems,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  // Controle de estado de layout (Recolhido/Expandido)
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Cálculo de dimensões reativas baseadas na altura segura da tela (Viewport)
    final screenHeight = MediaQuery.of(context).size.height;
    final double expandedHeight = screenHeight * 0.80;
    const double collapsedHeight = 180.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _isExpanded ? expandedHeight : collapsedHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(50.0)),
        boxShadow: [
          BoxShadow(
            // Definição de sombra estrutural com transparência alfa padronizada
            color: Colors.black.withValues(alpha: 0.08), 
            blurRadius: 20.0,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Área de captura de gestos (Hitbox) para manipulação de estado do contêiner
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: [_buildDragHandle(context), _buildHeader()],
                ),
              ),
            ),

            // Região de renderização de conteúdo condicional (Lista de artefatos)
            _buildItemList(),

            // Painel inferior de ancoragem de controles de navegação e conversão
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // Componente visual indicativo de arrasto (Drag handle) para affordance da interface
  Widget _buildDragHandle(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Container(
        width: screenWidth * 0.60,
        height: 4.0,
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  // Construção do cabeçalho descritivo com sumarização de métricas
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade100, width: 2.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'RESUMO DO PEDIDO',
            style: TextStyle(
              fontWeight: FontWeight.w800, 
              fontSize: 18.0, 
              color: Colors.grey[800],
              letterSpacing: 0.5,
            ),
          ),

          // Indicador de contagem encapsulado
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[50], 
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2.0,
              ), 
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.grey[600],
                  size: 16.0,
                ),
                const SizedBox(width: 6.0),
                Text(
                  '${widget.totalItems} Itens',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, 
                    fontSize: 16.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Composição animada da lista de detalhamento do pedido
  Widget _buildItemList() {
    return Expanded(
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _isExpanded ? 1.0 : 0.0,
        child: _isExpanded
            ? ListView.builder(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 16.0),
                itemCount: widget.totalItems > 0 ? 3 : 0,
                itemBuilder: (context, index) => _buildSummaryItem(),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  // Nó individual de renderização da listagem de artefatos
  Widget _buildSummaryItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          // Placeholder para imagem do artefato
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade200, width: 2.0),
            ),
            child: const Icon(Icons.fastfood, color: Colors.grey, size: 24.0),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              'Hambúrguer Clássico',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          
          // Controles de mutação de quantidade do artefato
          Row(
            children: [
              _buildCounterButton(
                Icons.remove,
                AppColors.danger,
                () => print("Menos"),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '1',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
              _buildCounterButton(
                Icons.add,
                AppColors.primary,
                () => print("Mais"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Fábrica de botões de interação quantitativa
  Widget _buildCounterButton(IconData icon, Color color, VoidCallback onTap) {
    final isRemove = icon == Icons.remove;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: isRemove ? Colors.white : color,
          border: isRemove
              ? Border.all(color: color.withValues(alpha: 0.5), width: 2.0)
              : null,
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Icon(icon, color: isRemove ? color : Colors.white, size: 16.0),
      ),
    );
  }

  // Painel estático de botões estruturais (Conversão/Descarte)
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
      child: Row(
        children: [
          Expanded(
            child: CustomBottomButton(
              label: 'CANCELAR',
              icon: Icons.close,
              color: AppColors.danger,
              textColor: Colors.white,
              onPressed: widget.onCancel,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: CustomBottomButton(
              // Transição de rótulo contextual baseada no estado visual
              label: _isExpanded ? 'CONFIRMAR' : 'REVISAR',
              icon: Icons.check,
              color: AppColors.success,
              textColor: Colors.black,
              onPressed: () {
                if (!_isExpanded) {
                  setState(() => _isExpanded = true);
                } else {
                  widget.onConfirm();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}