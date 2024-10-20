import 'package:arnaldo/core/database/database_helper.dart';
import 'package:arnaldo/core/enums/pessoa_type.dart';
import 'package:arnaldo/core/enums/rota.dart';
import 'package:arnaldo/models/pessoa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PessoaController {
  PessoaController({required Pessoa pessoa}) : pessoa = ValueNotifier<Pessoa>(pessoa);
  final ValueNotifier<Pessoa> pessoa;

  Future<void> fetchPessoa() async {
    final db = Modular.get<DatabaseHelper>();
    pessoa.value = await db.getPessoa(pessoa.value.id);
  }
}

class LinhaPessoa extends StatefulWidget {
  const LinhaPessoa({super.key, required this.pessoa});

  final Pessoa pessoa;

  @override
  State<LinhaPessoa> createState() => _LinhaPessoaState();
}

class _LinhaPessoaState extends State<LinhaPessoa> {
  late PessoaController controller;

  @override
  void initState() {
    super.initState();
    controller = PessoaController(pessoa: widget.pessoa);
    controller.pessoa.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.pessoa.removeListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Pessoa>(
        valueListenable: controller.pessoa,
        builder: (context, pessoa, child) {
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor,
                      blurRadius: 0.1,
                      offset: const Offset(3, 1),
                    ),
                  ],
                  border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).scaffoldBackgroundColor,
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
                          pessoa.nome,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: pessoa.ativo ? Theme.of(context).colorScheme.primary : Theme.of(context).disabledColor,
                            fontSize: 42,
                            decoration: pessoa.ativo ? TextDecoration.none : TextDecoration.lineThrough,
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
                            onPressed: () async => await _showDialogEditarPessoa(context, pessoa),
                          ),
                          const SizedBox(width: 24),
                          IconButton(
                            iconSize: 42,
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async => await _showDialogApagarPessoa(context, pessoa),
                          ),
                          const SizedBox(width: 24),
                          Switch(
                            value: pessoa.ativo,
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
    await db.togglePessoa(widget.pessoa.id, value);
    await controller.fetchPessoa();
  }

  Future<dynamic> _showDialogApagarPessoa(BuildContext context, Pessoa pessoa) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Apagar ${pessoa.tipo} ${pessoa.nome}', style: const TextStyle(fontSize: 36)),
          content: Text('Deseja realmente apagar o ${pessoa.tipo} ${pessoa.nome}?', style: const TextStyle(fontSize: 24)),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  child: const Text('Cancelar', style: TextStyle(color: Colors.red, fontSize: 24)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Apagar', style: TextStyle(fontSize: 32)),
                  onPressed: () async {
                    final db = Modular.get<DatabaseHelper>();
                    await db.deletePessoa(pessoa.id);
                    Navigator.of(context).pop();
                    Rota rota = pessoa.tipo == PessoaType.cliente.name
                        ? Rota.clientes
                        : pessoa.tipo == PessoaType.fornecedor.name
                            ? Rota.fornecedores
                            : Rota.home;
                    Modular.to.pop();
                    Modular.to.pushNamed('/pessoas/${rota.name}');
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Future<dynamic> _showDialogEditarPessoa(BuildContext context, Pessoa pessoa) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController textController = TextEditingController(text: pessoa.nome);
        return AlertDialog(
          title: Text('Editar ${pessoa.tipo} ${pessoa.nome}', style: const TextStyle(fontSize: 36)),
          content: TextField(
            style: const TextStyle(fontSize: 24),
            controller: textController,
            decoration: const InputDecoration(labelText: 'Nome'),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  child: const Text('Cancelar', style: TextStyle(color: Colors.red, fontSize: 24)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text('Salvar', style: TextStyle(fontSize: 32)),
                  onPressed: () async {
                    final db = Modular.get<DatabaseHelper>();
                    await db.updatePessoa(pessoa.id, textController.text);
                    await controller.fetchPessoa();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
