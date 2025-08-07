import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/helpers/url_launcher_helper.dart';

class ClickableTextMessage extends StatelessWidget {
  final String message;

  const ClickableTextMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final RegExp exp = RegExp(
      r'((?:https?|ftp)://[^\s]+|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}|(?:\+?\d{1,3})?[\s.-]?\d{2,5}[\s.-]?\d{3,5}[\s.-]?\d{3,5}|\b(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,})',
      caseSensitive: false,
    );

    final List<InlineSpan> spans = [];
    int start = 0;

    for (final match in exp.allMatches(message)) {
      if (match.start > start) {
        spans.add(TextSpan(text: message.substring(start, match.start)));
      }

      final String matchText = match.group(0)!;
      String url = matchText;

      if (matchText.contains('@')) {
        url = 'mailto:$matchText';
      } else if (matchText.startsWith('+') || RegExp(r'^\d{10,}$').hasMatch(matchText)) {
        url = 'tel:$matchText';
      } else if (!matchText.startsWith('http')) {
        url = 'https://$matchText';
      }

      spans.add(
        TextSpan(
          text: matchText,
          style: TextStyle(color: AppColors.linkColor, decoration: TextDecoration.underline, decorationColor: AppColors.linkColor),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              UrlLauncherHelper.openUrlInChrome(url);
            },
        ),
      );

      start = match.end;
    }

    if (start < message.length) {
      spans.add(TextSpan(text: message.substring(start)));
    }

    // Add spacing at the end (e.g., 60px width) to reserve space for timestamp
    spans.add(
      const WidgetSpan(
        child: SizedBox(width: 55),
      ),
    );

    return SelectableText.rich(
      TextSpan(
        children: spans,
        style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
      ),
    );
  }
}
