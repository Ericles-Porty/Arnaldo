import 'package:arnaldo/core/database/database_helper.dart';
import 'package:arnaldo/core/enums/pessoa_type.dart';
import 'package:arnaldo/features/pessoas/pessoas_controller.dart';
import 'package:arnaldo/features/pessoas/widgets/linha_pessoa.dart';
import 'package:arnaldo/models/pessoa.dart';
import 'package:arnaldo/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PessoasPage extends StatefulWidget {
  final PessoaType pessoaType;

  const PessoasPage({super.key, required this.pessoaType});

  @override
  State<PessoasPage> createState() => _PessoasPageState();
}

class _PessoasPageState extends State<PessoasPage> {
  late PessoasController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Modular.get<PessoasController>();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget.pessoaType.name == PessoaType.cliente.name
        ? 'Clientes'
        : widget.pessoaType.name == PessoaType.fornecedor.name
            ? 'Fornecedores'
            : '';
    return Scaffold(
      appBar: myAppBar(context: context, title: title, hasLeading: true),
      body: FutureBuilder(
        future: _controller.fetchPessoas(widget.pessoaType),
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
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Adicionar ${widget.pessoaType.name}',
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    onPressed: () async {
                      await _showDialogAdicionarPessoa(context);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final Pessoa pessoa = snapshot.data![index];
                        return LinhaPessoa(pessoa: pessoa);
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

  Future<dynamic> _showDialogAdicionarPessoa(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Adicionar ${widget.pessoaType.name}'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Nome'),
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.text,
            autofocus: true,
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
                if (controller.text.isNotEmpty) {
                  final db = Modular.get<DatabaseHelper>();
                  await db.insertPessoa(controller.text, widget.pessoaType.name);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
