import 'package:arnaldo/models/pessoa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LinhaPessoaOperacoes extends StatelessWidget {
  const LinhaPessoaOperacoes({super.key, required this.pessoa});

  final Pessoa pessoa;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shadowColor: Theme.of(context).shadowColor,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).primaryColor, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          Modular.to.pushNamed('/operacoes/pessoa', arguments: pessoa);
        },
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
                    fontSize: 32,
                    decoration: pessoa.ativo ? TextDecoration.none : TextDecoration.lineThrough,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Icon(
              Icons.arrow_right_alt,
              size: 42,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
