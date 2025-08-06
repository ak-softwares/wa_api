import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/navigation_bar/appbar.dart';
import '../../../common/styles/spacing_style.dart';
import '../../../services/notification/firebase_notification.dart';
import '../../../utils/constants/sizes.dart';

class N8NSetup extends StatelessWidget {
  const N8NSetup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppBar(title: 'N8N Setup'),
        body: Padding(
          padding: AppSpacingStyle.defaultPagePadding,
          child: Column(
              spacing: AppSizes.defaultSpace,
              children: [
                // FCM Token
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: AppSizes.inputFieldPadding, horizontal: AppSizes.inputFieldPadding),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(AppSizes.inputFieldRadius)),
                      border: Border.all(color: Theme.of(context).colorScheme.outline, width: AppSizes.inputFieldBorderWidth),
                    ),
                    child: Text(FirebaseNotification.fCMToken.toString()),
                  ),
                ),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    child: Row(
                      spacing: AppSizes.defaultSpace,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.copy),
                        const Text('Copy'),
                      ],
                    ),
                    onPressed: () {
                        Clipboard.setData(ClipboardData(text: FirebaseNotification.fCMToken.toString()));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
                      },
                  ),
                ),
              ]
          ),
        )
    );
  }
}
