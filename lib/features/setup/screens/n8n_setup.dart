import 'package:flutter/material.dart';

import '../../../common/navigation_bar/appbar.dart';

class N8NSetup extends StatelessWidget {
  const N8NSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'N8N Setup'),
      body: Center(child: Text('MongoDB Setup Screen'))
    );
  }
}
