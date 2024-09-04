import 'package:arnaldo/core/database_helper.dart';
import 'package:arnaldo/models/pessoa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ClienteController {
  ClienteController({required Pessoa cliente}) : cliente = ValueNotifier<Pessoa>(cliente);
  final ValueNotifier<Pessoa> cliente;

  Future<void> fetchCliente() async {
    final db = Modular.get<DatabaseHelper>();
    cliente.value = await db.getPessoa(cliente.value.id);
  }
}

class LinhaCliente extends StatefulWidget {
  const LinhaCliente({super.key, required this.cliente});

  final Pessoa cliente;

  @override
  State<LinhaCliente> createState() => _LinhaClienteState();
}

class _LinhaClienteState extends State<LinhaCliente> {
  late ClienteController controller;

  @override
  void initState() {
    super.initState();
    controller = ClienteController(cliente: widget.cliente);
    controller.cliente.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.cliente.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Pessoa>(
        valueListenable: controller.cliente,
        builder: (context, cliente, child) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(16),
                  color: cliente.ativo ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).disabledColor,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          cliente.nome,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: cliente.ativo ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor,
                            fontSize: 42,
                            decoration: cliente.ativo ? TextDecoration.none : TextDecoration.lineThrough,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 42,
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async => await _showDialogEditarCliente(context, cliente),
                          ),
                          const SizedBox(width: 24),
                          IconButton(
                            iconSize: 42,
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async => await _showDialogApagarCliente(context, cliente),
                          ),
                          const SizedBox(width: 24),
                          Switch(
                            value: cliente.ativo,
                            onChanged: (value) async => await _onToggle(value),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
        });
  }

  Future<void> _onToggle(bool value) async {
    final db = Modular.get<DatabaseHelper>();
    await db.togglePessoa(widget.cliente.id, value);
    await controller.fetchCliente();
  }

  Future<dynamic> _showDialogApagarCliente(BuildContext context, Pessoa cliente) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Apagar cliente ${cliente.nome}'),
          content: Text('Deseja realmente apagar o cliente ${cliente.nome}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Apagar'),
              onPressed: () async {
                final db = Modular.get<DatabaseHelper>();
                await db.deletePessoa(cliente.id);
                Navigator.of(context).pop();
                Modular.to.pop();
                Modular.to.pushNamed('/clientes/');
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _showDialogEditarCliente(BuildContext context, Pessoa cliente) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController textController = TextEditingController(text: cliente.nome);
        return AlertDialog(
          title: Text('Editar cliente ${cliente.nome}'),
          content: TextField(
            controller: textController,
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
                await db.updatePessoa(cliente.id, textController.text);
                await controller.fetchCliente();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
