import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_colors.dart';
import '../components/custom_app_bar.dart';
import '../components/custom_bottom_button.dart';
import '../utils/category_dialog_utils.dart'; // O IMPORT DA NOSSA FAXINA AQUI!

class NewProductScreen extends StatefulWidget {
  const NewProductScreen({super.key});

  @override
  State<NewProductScreen> createState() => _NewProductScreenState();
}

class _NewProductScreenState extends State<NewProductScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();

  String?
  _categoriaSelecionada; // Começa vazio para obrigar o usuário a escolher
  bool _isSaving = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  Future<void> _salvarProdutoNoBanco() async {
    // 1. Validação de Categoria
    if (_categoriaSelecionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione uma categoria.')),
      );
      return;
    }

    // 2. Validação de Texto
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
        // 'fotoUrl': null, // O espaço já fica preparado para a foto no futuro
        'criadoEm': FieldValue.serverTimestamp(),
      });

      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
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
              // PASSO 1: CATEGORIA (Lista Horizontal Limpa)
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
                      itemCount:
                          categorias.length + 1, // +1 para o botão de criar
                      itemBuilder: (context, index) {
                        // O Botão de "Nova Categoria" no final da lista
                        if (index == categorias.length) {
                          return GestureDetector(
                            onTap: () {
                              // Chamando a nossa utilidade que criamos!
                              CategoryDialogUtils.mostrarDialogCategoria(
                                context,
                                onSaved: (nomeSalvo) {
                                  // Seleciona automaticamente a categoria nova
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

                        // As Categorias Cadastradas
                        var cat =
                            categorias[index].data() as Map<String, dynamic>;
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
                                  ? Colors.blueAccent.withOpacity(0.1)
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
              // PASSO 2: FOTO DO PRODUTO (Placeholder)
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
              // PASSO 3: DETALHES (NOME E PREÇO)
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
                    const SizedBox(
                      height: 16.0,
                    ), // Aumentei um pouco o respiro aqui
                    TextField(
                      controller: _nomeController,
                      style: const TextStyle(
                        fontSize: 18.0,
                      ), // Aumentei a fonte de digitação
                      decoration: _buildInputDecoration(
                        'Nome (Ex: Hambúrguer Duplo)',
                        Icons.fastfood,
                      ),
                      textCapitalization: TextCapitalization.words,
                    ),

                    const SizedBox(
                      height: 20.0,
                    ), // Respiro maior entre os inputs

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
                        fontSize: 22.0, // Fonte um pouco maior para o preço
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

  // --- O SEGREDO ESTÁ AQUI NO CONTENT PADDING E HINT STYLE ---
  InputDecoration _buildInputDecoration(String hint, IconData icon) =>
      InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.grey.shade400, // Cinza bem suave
          fontSize: 16.0,
        ),
        prefixIcon: Icon(
          icon,
          color: Colors.grey.shade400,
        ), // Deixei o ícone combinando com o cinza suave
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          vertical: 24.0, // <-- AUMENTOU A ALTURA DO CAMPO AQUI
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
