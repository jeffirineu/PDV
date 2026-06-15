import 'package:flutter/material.dart';

// 1. O Molde do Item
class ItemConsumido {
  String nome;
  double preco;
  int quantidade;
  String status; // 'pendente', 'pago', 'cancelado'

  ItemConsumido({
    required this.nome,
    required this.preco,
    required this.quantidade,
    this.status = 'pendente',
  });

  // Calcula o total do item
  double get total => preco * quantidade;
}

// 2. O Molde da Mesa
class Mesa {
  final int numero;
  List<ItemConsumido> itens;

  Mesa({required this.numero, required this.itens});

  // A mesa está ocupada se tiver algum item na lista
  bool get estaOcupada => itens.isNotEmpty;

  // Calcula o valor total apenas dos itens pendentes
  double get valorTotalPendente {
    double total = 0.0;
    for (var item in itens) {
      if (item.status == 'pendente') {
        total += item.total;
      }
    }
    return total;
  }
}

// 3. O Motor do App (Controller)
class RestauranteController extends ChangeNotifier {
  // Padrão Singleton: Garante que o app inteiro use a mesma memória
  static final RestauranteController _instancia =
      RestauranteController._interno();
  factory RestauranteController() => _instancia;

  RestauranteController._interno() {
    // Quando o app abre, ele cria 60 mesas vazias automaticamente!
    mesas = List.generate(60, (index) => Mesa(numero: index + 1, itens: []));
  }

  late List<Mesa> mesas;

  // --- FUNÇÕES PRÁTICAS PARA AS TELAS USAREM ---

  // Puxa uma mesa específica
  Mesa getMesa(int numero) {
    return mesas.firstWhere((m) => m.numero == numero);
  }

  // Lança um pedido na mesa
  void adicionarItem(int numeroMesa, ItemConsumido novoItem) {
    getMesa(numeroMesa).itens.add(novoItem);
    notifyListeners(); // Avisa as telas para se atualizarem!
  }

  // Altera a quantidade (quando o garçom usa o pop-up)
  void atualizarQuantidade(int numeroMesa, ItemConsumido item, int novaQtd) {
    if (novaQtd > 0) {
      item.quantidade = novaQtd;
      notifyListeners();
    }
  }

  // Muda para Pago ou Cancelado
  void alterarStatusItem(
    int numeroMesa,
    ItemConsumido item,
    String novoStatus,
  ) {
    item.status = novoStatus;
    notifyListeners();
  }

  // Limpa a mesa (Quando finaliza o pagamento)
  void fecharConta(int numeroMesa) {
    getMesa(numeroMesa).itens.clear();
    notifyListeners();
  }
}

// Criamos uma variável global para você chamar em qualquer tela facilmente!
final restauranteController = RestauranteController();
