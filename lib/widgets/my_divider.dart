import 'package:flutter/material.dart';

Divider myDivider({required BuildContext context}) => Divider(
      height: 0,
      indent: 4,
      endIndent: 4,
      color: Theme.of(context).primaryColor,
      thickness: 2,
    );
