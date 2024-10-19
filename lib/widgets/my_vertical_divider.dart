import 'package:flutter/material.dart';

SizedBox myVerticalDivider({required Size size}) => SizedBox(
      width: size.width * 0.025,
      height: 35,
      child: const VerticalDivider(
        thickness: 1, // Espessura da linha
        width: 2, // Espaço horizontal ao redor da linha
        color: Colors.grey, // Cor da linha
      ),
    );
