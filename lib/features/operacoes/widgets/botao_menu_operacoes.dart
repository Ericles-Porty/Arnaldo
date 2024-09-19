import 'package:arnaldo/core/enums/pessoa_type.dart';
import 'package:arnaldo/core/enums/rota.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BotaoMenuOperacoes extends StatelessWidget {
  const BotaoMenuOperacoes({
    super.key,
    required this.texto,
    required this.icone,
    required this.tipoPessoa,
  });

  final String texto;
  final IconData icone;
  final PessoaType tipoPessoa;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shadowColor: Colors.lightGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: SizedBox(
        width: 150,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 24),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                texto,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
      onPressed: () => Modular.to.pushNamed('/operacoes/pessoas', arguments: tipoPessoa),
    );
  }
}
