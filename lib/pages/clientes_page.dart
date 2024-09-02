import 'package:arnaldo/database_helper.dart';
import 'package:arnaldo/models/Dtos/linha_venda_dto.dart';
import 'package:arnaldo/models/Dtos/produto_dto.dart';
import 'package:arnaldo/models/produto_historico.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key, required this.produtosDto});

  final List<ProdutoDto> produtosDto;

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final db = DatabaseHelper();
  DateTime _selectedDate = DateTime.now();
  List<LinhaVendaDto> _vendas = [];
  Map<String, double> _precosProdutosMap = {};
  Map<String, int> _idsProdutosMap = {};

  @override
  void initState() {
    super.initState();
    _precosProdutosMap = {
      "Pimenta": widget.produtosDto.firstWhere((produto) => produto.nome == "Pimenta").valor,
      "Quiabo": widget.produtosDto.firstWhere((produto) => produto.nome == "Quiabo").valor,
      "Maxixe": widget.produtosDto.firstWhere((produto) => produto.nome == "Maxixe").valor,
      "Jiló": widget.produtosDto.firstWhere((produto) => produto.nome == "Jiló").valor,
    };

    _idsProdutosMap = {
      "Pimenta": widget.produtosDto.firstWhere((produto) => produto.nome == "Pimenta").id,
      "Quiabo": widget.produtosDto.firstWhere((produto) => produto.nome == "Quiabo").id,
      "Maxixe": widget.produtosDto.firstWhere((produto) => produto.nome == "Maxixe").id,
      "Jiló": widget.produtosDto.firstWhere((produto) => produto.nome == "Jiló").id,
    };
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null && picked != _selectedDate) {
      await _loadVendas();
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _loadVendas() async {
    final vendasResponse = await db.getVendasByDate(data: _selectedDate, tipo: 'cliente');

    for (var produto in widget.produtosDto) {
      ProdutoHistorico produtoHistorico = await db.getProdutoHistorico(idProduto: produto.id, data: _selectedDate);
      _precosProdutosMap[produto.nome] = produtoHistorico.valor;
    }

    Map<String, LinhaVendaDto> vendasMap = {};

    for (var venda in vendasResponse) {
      vendasMap[venda.pessoa!.nome] = LinhaVendaDto(
        idPessoa: venda.pessoa!.id,
        nomePessoa: venda.pessoa!.nome,
        idPimenta: _idsProdutosMap["Pimenta"]!,
        quantidadePimenta: vendasMap[venda.pessoa!.nome]?.quantidadePimenta ?? 0,
        idQuiabo: _idsProdutosMap["Quiabo"]!,
        quantidadeQuiabo: vendasMap[venda.pessoa!.nome]?.quantidadeQuiabo ?? 0,
        idMaxixe: _idsProdutosMap["Maxixe"]!,
        quantidadeMaxixe: vendasMap[venda.pessoa!.nome]?.quantidadeMaxixe ?? 0,
        idJilo: _idsProdutosMap["Jiló"]!,
        quantidadeJilo: vendasMap[venda.pessoa!.nome]?.quantidadeJilo ?? 0,
      );

      switch (venda.produto!.nome) {
        case "Pimenta":
          vendasMap[venda.pessoa!.nome] = vendasMap[venda.pessoa!.nome]!.copyWith(
            quantidadePimenta: venda.quantidade,
            idVendaPimenta: venda.id,
          );
          break;
        case "Quiabo":
          vendasMap[venda.pessoa!.nome] = vendasMap[venda.pessoa!.nome]!.copyWith(
            quantidadeQuiabo: venda.quantidade,
            idVendaQuiabo: venda.id,
          );
          break;
        case "Maxixe":
          vendasMap[venda.pessoa!.nome] = vendasMap[venda.pessoa!.nome]!.copyWith(
            quantidadeMaxixe: venda.quantidade,
            idVendaMaxixe: venda.id,
          );
          break;
        case "Jiló":
          vendasMap[venda.pessoa!.nome] = vendasMap[venda.pessoa!.nome]!.copyWith(
            quantidadeJilo: venda.quantidade,
            idVendaJilo: venda.id,
          );
          break;
      }
    }

    _vendas = vendasMap.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    String formattedDate = DateFormat('dd/MM/yyyy').format(_selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: const Text('Escolher Data'),
              ),
            ],
          ),
        ),
        FutureBuilder(
          future: _loadVendas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            } else {
              return Expanded(
                child: Column(
                  children: <Widget>[
                    _buildCabecalho(screenWidth),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: <Widget>[
                            for (var venda in _vendas) _buildLinha(venda, screenWidth),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Container _buildCelula({required String texto, required double width, double? height = 50, String? sufixo, int? idVenda, int? idPessoa, int? idProduto}) {
    final removeZeros = RegExp(r'\.0+$');
    texto = texto.replaceAll(removeZeros, "");
    final conteudo = texto == "0"
        ? "-"
        : sufixo != null
            ? "$texto /$sufixo"
            : texto;

    final TextEditingController controller = TextEditingController(text: texto);
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: idPessoa == null && idProduto == null
          ? Center(child: FittedBox(child: Text(conteudo, textAlign: TextAlign.center)))
          : InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    if (idProduto != null && idPessoa == null){
                      controller.text = conteudo.split("\n")[1].split(" ")[0];
                      return AlertDialog(
                        title: const Text('Editar preço'),
                        content: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Preço'),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancelar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          ElevatedButton(
                            child: const Text('Salvar'),
                            onPressed: () {
                              double novoPreco = double.parse(controller.text);
                              db.insertProdutoHistorico(idProduto, novoPreco, _selectedDate);
                              Navigator.of(context).pop();
                              setState(() {
                                _loadVendas();
                              });
                            },
                          ),
                        ],
                      );
                    }
                    return AlertDialog(
                      title: const Text('Editar quantidade'),
                      content: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Quantidade'),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Salvar'),
                          onPressed: () {
                            double novaQuantidade = double.parse(controller.text);
                            if (idVenda == null) {
                              db.insertVenda(idPessoa!, idProduto!, novaQuantidade, _selectedDate); // Lembrar de tirar o 0
                            } else {
                              db.updateVenda(idVenda, novaQuantidade);
                            }
                            Navigator.of(context).pop();
                            setState(() {
                              _loadVendas();
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Center(child: FittedBox(child: Text(conteudo, textAlign: TextAlign.center))),
            ),
    );
  }

  Row _buildCabecalho(double width) {
    final celulaWidth = width / 6;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildCelula(texto: 'Cliente', width: celulaWidth, height: 60),
        _buildCelula(texto: 'Pimenta\n${_precosProdutosMap['Pimenta']} R\$', width: celulaWidth, height: 60, idProduto: _idsProdutosMap['Pimenta']),
        _buildCelula(texto: 'Quiabo\n${_precosProdutosMap['Quiabo']} R\$', width: celulaWidth, height: 60, idProduto: _idsProdutosMap['Quiabo']),
        _buildCelula(texto: 'Maxixe\n${_precosProdutosMap['Maxixe']} R\$', width: celulaWidth, height: 60, idProduto: _idsProdutosMap['Maxixe']),
        _buildCelula(texto: 'Jiló\n${_precosProdutosMap['Jiló']} R\$', width: celulaWidth, height: 60, idProduto: _idsProdutosMap['Jiló']),
        _buildCelula(texto: 'Total', width: celulaWidth, height: 60),
      ],
    );
  }

  Row _buildLinha(LinhaVendaDto venda, double width) {
    final celulaWidth = width / 6;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildCelula(texto: venda.nomePessoa, width: celulaWidth),
        _buildCelula(
            texto: venda.quantidadePimenta.toString(),
            width: celulaWidth,
            sufixo: "kg",
            idVenda: venda.idVendaPimenta,
            idPessoa: venda.idPessoa,
            idProduto: venda.idPimenta),
        _buildCelula(
            texto: venda.quantidadeQuiabo.toString(),
            width: celulaWidth,
            sufixo: "sc",
            idVenda: venda.idVendaQuiabo,
            idPessoa: venda.idPessoa,
            idProduto: venda.idQuiabo),
        _buildCelula(
            texto: venda.quantidadeMaxixe.toString(),
            width: celulaWidth,
            sufixo: "sc",
            idVenda: venda.idVendaMaxixe,
            idPessoa: venda.idPessoa,
            idProduto: venda.idMaxixe),
        _buildCelula(
            texto: venda.quantidadeJilo.toString(),
            width: celulaWidth,
            sufixo: "sc",
            idVenda: venda.idVendaJilo,
            idPessoa: venda.idPessoa,
            idProduto: venda.idJilo),
        _buildCelula(
            texto:
                "${venda.quantidadePimenta * _precosProdutosMap['Pimenta']! + venda.quantidadeQuiabo * _precosProdutosMap['Quiabo']! + venda.quantidadeMaxixe * _precosProdutosMap['Maxixe']! + venda.quantidadeJilo * _precosProdutosMap['Jiló']!} R\$",
            width: celulaWidth),
      ],
    );
  }
}
