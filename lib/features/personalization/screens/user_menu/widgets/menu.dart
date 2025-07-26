import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../setup/screens/platform_setup.dart';

class Menu extends StatelessWidget {
  const Menu({
    super.key, this.showHeading = true,
  });

  final bool showHeading;

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ListTile(
          onTap: () => Get.to(() => PlatformSelectionScreen()),
          leading: Icon(Icons.store, size: 20),
          title: Text('Setup'),
          subtitle: Text('Connect MonogoDB and n8n'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
      ],
    );
  }
}
