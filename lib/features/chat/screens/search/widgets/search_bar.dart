import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/search/search_delegate.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, this.searchText = "Search"});

  final String? searchText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showSearch(context: context, delegate: AppSearchDelegate()),
      child: Container(
        height: 45,
        padding: const EdgeInsets.all(AppSizes.sm),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            Icon(Icons.search, size: 22,),
            const SizedBox(width: 7),
            Text(searchText!)
          ],
        ),
      ),
    );
  }
}