import 'package:arnaldo/core/database_helper.dart';
import 'package:arnaldo/core/enums/pessoa_type.dart';
import 'package:arnaldo/features/clientes/widgets/linha_cliente.dart';
import 'package:arnaldo/models/pessoa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

Future<List<Pessoa>> _fetchClientes() async {
  final DatabaseHelper db = Modular.get<DatabaseHelper>();
  final List<Pessoa> clientes = await db.getPessoas(PessoaType.cliente.name);
  return clientes;
}

class _ClientesPageState extends State<ClientesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Clientes', style: TextStyle(color: Colors.white, fontSize: 32)),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder(
        future: _fetchClientes(),
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
                        'Adicionar Cliente',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    onPressed: () async {
                      await _showDialogAdicionarCliente(context);
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final Pessoa cliente = snapshot.data![index];
                        return LinhaCliente(
                          cliente: cliente,
                        );
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

  Future<dynamic> _showDialogAdicionarCliente(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Adicionar Cliente'),
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
                db.insertPessoa(controller.text, 'cliente');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
