import 'package:arnaldo/core/database_helper.dart';
import 'package:arnaldo/features/fornecedores/fornecedores_controller.dart';
import 'package:arnaldo/models/pessoa.dart';
import 'package:arnaldo/widgets/linha_pessoa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class FornecedoresPage extends StatefulWidget {
  const FornecedoresPage({super.key});

  @override
  State<FornecedoresPage> createState() => _FornecedoresPageState();
}

class _FornecedoresPageState extends State<FornecedoresPage> {
  late FornecedoresController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<FornecedoresController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Fornecedores', style: TextStyle(color: Colors.white, fontSize: 32)),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder(
        future: _controller.fetchFornecedores(),
        builder: (context, AsyncSnapshot<List<Pessoa>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
              child: Column(
                children: [
                  ElevatedButton(
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Adicionar Fornecedor',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    onPressed: () async {
                      await _showDialogAdicionarFornecedor(context);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final Pessoa fornecedor = snapshot.data![index];
                        return LinhaPessoa(pessoa: fornecedor);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<dynamic> _showDialogAdicionarFornecedor(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Adicionar Fornecedor'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Nome'),
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
              onPressed: () async {
                final db = Modular.get<DatabaseHelper>();
                db.insertPessoa(controller.text, 'fornecedor');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
