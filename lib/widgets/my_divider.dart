import 'package:flutter/material.dart';

Divider myDivider({required BuildContext context, double? indent}) => Divider(
      height: 0,
      indent: indent ?? 4,
      endIndent: indent ?? 4,
      color: Theme.of(context).primaryColor,
      thickness: 2,
    );
