import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BotaoMenu extends StatelessWidget {
  const BotaoMenu({
    super.key,
    required this.size,
    required this.texto,
    required this.rota,
    required this.icone,
  });

  final String texto;
  final IconData icone;
  final String rota;
  final double size;

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
        width: size,
        height: size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 36),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                texto,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ],
        ),
      ),
      onPressed: () {
        Modular.to.pushNamed(rota);
      },
    );
  }
}
