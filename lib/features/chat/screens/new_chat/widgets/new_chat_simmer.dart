import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';


import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../../common/widgets/shimmers/shimmer_effect.dart';
import '../../../../../utils/constants/sizes.dart';

class NewChatSimmer extends StatelessWidget {
  const NewChatSimmer({super.key});

  @override
  Widget build(BuildContext context) {
    const double chatTileHeight = AppSizes.chatTileHeight;
    const double chatImageHeight = AppSizes.chatImageHeight;
    const double chatTileRadius = AppSizes.chatTileRadius;

    return Padding(
      padding: AppSpacingStyle.defaultPageHorizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
              spacing: 3,
              children: [
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerEffect(width: 100, height: 17),
                    ShimmerEffect(width: 50, height: 12),
                  ],
                ),
                ShimmerEffect(width: 150, height: 14)
              ],
            ),
          ),
          // const Spacer(),
          // const Icon(Icons.arrow_forward_ios, size: 20,),
        ],
      ),
    );
  }


}