import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/formatters/formatters.dart';
import '../../../models/chat_model.dart';
import '../../../models/contact_model.dart';

class NewChatTile extends StatelessWidget {
  const NewChatTile({super.key, required this.contact, this.onTap});

  final ContactModel contact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const double chatTileHeight = AppSizes.chatTileHeight;
    const double chatImageHeight = AppSizes.chatImageHeight;
    const double chatTileRadius = AppSizes.chatTileRadius;

    return InkWell(
      onTap : onTap,
      child: Padding(
        padding: AppSpacingStyle.defaultPageHorizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (contact.photo != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(40), // circular image
                child: Image.memory(
                  contact.photo!,
                  width: chatImageHeight,
                  height: chatImageHeight,
                  fit: BoxFit.cover,
                ),
              )
            else
              RoundedContainer(
                height: chatImageHeight,
                width: chatImageHeight,
                radius: chatTileRadius,
                backgroundColor: Theme.of(context).colorScheme.surface.darken(2),
                child: Icon(Icons.person, size: 27,),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const SizedBox(height: 3),
                  Text(contact.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w600
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    contact.phoneNumbers.join(', '),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface,),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // const Spacer(),
            // const Icon(Icons.arrow_forward_ios, size: 20,),
          ],
        ),
      ),
    );
  }


}