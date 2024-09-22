import 'package:arnaldo/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';

class OperacoesPage extends StatelessWidget {
  const OperacoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: 'appBarTitle', hasLeading: true),
      body: const Center(
        child: Text('OperacoesPage'),
      ),
    );
  }
}
