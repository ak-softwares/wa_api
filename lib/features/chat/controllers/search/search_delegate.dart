import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../utils/constants/sizes.dart';
import '../../screens/search/search.dart';


class AppSearchDelegate extends SearchDelegate {

  RxList<String> recentlySearches = <String>[].obs;
  RxList<String> suggestionList = RxList<String>(); // Observable for suggestion list

  final localStorage = GetStorage();

  @override
  String? get searchFieldLabel => 'Search';


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        }
    );
  }


  @override
  Widget buildResults(BuildContext context) {
    return SearchScreen();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SearchScreen();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        // iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        // titleTextStyle: TextStyle(color: Colors.blue),
        // toolbarTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        // toolbarHeight: 90,
      ),
      // primaryColor: TColors.primaryColor,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Theme.of(context).colorScheme.onSurface,
        selectionColor: Colors.blue.shade200,
        selectionHandleColor: Colors.blue.shade200,
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 15, // Customize font size
          fontWeight: FontWeight.w500, // Customize font weight
          color: Theme.of(context).colorScheme.onSurface, // Customize font color
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        // hintStyle: searchFieldStyle ?? theme.inputDecorationTheme.hintStyle,
        // border: InputBorder.none,
        isDense: true, // Ensures the padding takes effect
        contentPadding: const EdgeInsets.symmetric(vertical: AppSizes.sm, horizontal: AppSizes.md), // Define input field height
        fillColor: Theme.of(context).colorScheme.surface, // Customize the background color
        filled: true, // Ensure the fill color is applied
        hintStyle: TextStyle(
          fontSize: 15, // Customize hint text font size
          color: Theme.of(context).colorScheme.onSurfaceVariant, // Customize hint text color
        ),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            // borderSide: BorderSide(
            //   color: Theme.of(context).colorScheme.surface,
            //   width: 2.0, // Customize the border width
            // ),
            borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius) // Optional: Customize the border radius
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          // borderSide: BorderSide(
          //   color: Theme.of(context).colorScheme.surface,
          //   width: 2.0, // Customize the border width
          // ),
          borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        ),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            // borderSide: BorderSide(
            //   color: Theme.of(context).colorScheme.surface,
            //   width: 1.0, // Customize the default border width
            // ),
            borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius)
        ),
      ),
    );
  }

}