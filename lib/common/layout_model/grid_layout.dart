import 'package:flutter/cupertino.dart';

import '../../utils/constants/sizes.dart';

class GridLayout extends StatelessWidget {
  const GridLayout({
    super.key,
    required this.itemCount,
    this.crossAxisCount = 1,
    this.crossAxisSpacing = AppSizes.defaultSpaceBWTCard,
    this.mainAxisSpacing = AppSizes.defaultSpaceBWTCard,
    required this.mainAxisExtent,
    required this.itemBuilder,
    this.onDelete,
    this.onEdit,
  });

  final int itemCount, crossAxisCount;
  final double mainAxisExtent, crossAxisSpacing, mainAxisSpacing;
  final Widget Function(BuildContext, int) itemBuilder;
  final void Function(int)? onDelete;
  final void Function(int)? onEdit;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          mainAxisExtent: mainAxisExtent
      ),
      cacheExtent: 50, // Keeps items in memory
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return itemBuilder(context, index);
      },
    );
  }
}