import 'package:flutter/material.dart';

import 'app_theme.dart';

class Toolbar extends StatelessWidget {
  const Toolbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: RawMaterialButton(
              elevation: 4,
              fillColor: AppTheme.primaryColor,
              child: const Icon(Icons.navigate_before, color: Colors.white),
              padding: const EdgeInsets.all(12),
              shape: const CircleBorder(),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ],
    );
  }
}
