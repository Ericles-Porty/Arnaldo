import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class BotaoMenu extends StatefulWidget {
  BotaoMenu({
    super.key,
    required this.texto,
    required this.icone,
    required this.rota,
    required this.size,
    this.argumento,
  });

  final String texto;
  final IconData icone;
  final String rota;
  final double size;
  late Object? argumento;

  @override
  State<BotaoMenu> createState() => _BotaoMenuState();
}

class _BotaoMenuState extends State<BotaoMenu> {
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
        width: widget.size * 1.5,
        height: widget.size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icone, size: 36),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.texto,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ],
        ),
      ),
      onPressed: () {
        Modular.to.pushNamed(widget.rota, arguments: widget.argumento);
      },
    );
  }
}
