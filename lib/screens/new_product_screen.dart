import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_button.dart';
import '../utils/category_dialog_utils.dart'; // Importação do utilitário de diálogo para categorias

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({super.key});

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();

  // Inicializado como nulo para forçar a validação e seleção explícita pelo usuário
  String? _categoriaSelecionada; 
  bool _isSaving = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  Future<void> _salvarProdutoNoBanco() async {
    // 1. Validação de estado da categoria
    if (_categoriaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma categoria.')),
      );
      return;
    }

    // 2. Validação dos campos de entrada de texto
    if (_nomeController.text.isEmpty || _precoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha o nome e o preço do produto.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      double preco = double.parse(_precoController.text.replaceAll(',', '.'));

      await FirebaseFirestore.instance.collection('produtos').add({
        'nome': _nomeController.text.trim(),
        'preco': preco,
        'categoria': _categoriaSelecionada,
        // Atributo reservado para futura implementação de armazenamento de imagem
        // 'fotoUrl': null, 
        'criadoEm': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'NOVO PRODUTO', showBackButton: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // SEÇÃO 1: SELEÇÃO DE CATEGORIA
              // ==========================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  '1. Categoria',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    fontSize: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              SizedBox(
                height: 100.0,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('categorias')
                      .orderBy('nome')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var categorias = snapshot.data!.docs;

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      // Incremento de 1 no tamanho da lista para alocar o botão de criação
                      itemCount: categorias.length + 1, 
                      itemBuilder: (context, index) {
                        
                        // Renderização do botão de adição de nova categoria na última posição
                        if (index == categorias.length) {
                          return GestureDetector(
                            onTap: () {
                              CategoryDialogUtils.mostrarDialogCategoria(
                                context,
                                onSaved: (nomeSalvo) {
                                  // Atualiza o estado com a categoria recém-criada
                                  setState(
                                    () => _categoriaSelecionada = nomeSalvo,
                                  );
                                },
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 8.0),
                              width: 80.0,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(16.0),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Colors.green.shade600,
                                    size: 32.0,
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    "Nova",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.green.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        // Renderização das categorias recuperadas do banco de dados
                        var cat = categorias[index].data() as Map<String, dynamic>;
                        String nome = cat['nome'];
                        String emoji = cat['emoji'] ?? '🏷️';
                        bool isSelected = _categoriaSelecionada == nome;

                        return GestureDetector(
                          onTap: () =>
                              setState(() => _categoriaSelecionada = nome),
                          child: Container(
                            margin: const EdgeInsets.only(right: 12.0),
                            width: 80.0,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.blueAccent.withValues(alpha: 0.1)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.blueAccent
                                    : Colors.grey.shade300,
                                width: isSelected ? 2.0 : 1.0,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 28.0),
                                ),
                                const SizedBox(height: 8.0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  child: Text(
                                    nome,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? Colors.blueAccent
                                          : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 32.0),

              // ==========================================
              // SEÇÃO 2: IMAGEM DO PRODUTO (Placeholder)
              // ==========================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  '2. Foto do Produto',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[600],
                    fontSize: 16.0,
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Abertura da galeria será configurada em breve!',
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 150.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo,
                          size: 48.0,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          "Toque para adicionar foto",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32.0),

              // ==========================================
              // SEÇÃO 3: INSERÇÃO DE DADOS (NOME E PREÇO)
              // ==========================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3. Detalhes',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    TextField(
                      controller: _nomeController,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ), 
                      decoration: _buildInputDecoration(
                        'Nome (Ex: Hambúrguer Duplo)',
                        Icons.fastfood,
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),
                    const SizedBox(height: 20.0),
                    TextField(
                      controller: _precoController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\,?\d*'),
                        ),
                      ],
                      style: const TextStyle(
                        fontSize: 22.0, 
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                      decoration: _buildInputDecoration(
                        'Preço (Ex: 25,00)',
                        Icons.attach_money,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isSaving
              ? const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : CustomBottomButton(
                  label: 'SALVAR PRODUTO',
                  icon: Icons.save,
                  color: AppColors.primary,
                  textColor: Colors.white,
                  onPressed: _salvarProdutoNoBanco,
                ),
        ),
      ),
    );
  }

  // Método utilitário para padronização da estilização dos campos de texto
  InputDecoration _buildInputDecoration(String hint, IconData icon) =>
      InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400, 
          fontSize: 16.0,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey.shade400,
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 24.0, 
          horizontal: 20.0,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
      );
}
