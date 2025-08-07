import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static void openUrl(String url) async {
    final Uri uri = Uri.parse(url);

    // Open with external browser, ignoring app's intent filters
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      print('Could not launch $url');
    }
  }

  static void openUrlInChrome(String url) async {
    final Uri uri = Uri.parse(url);
    final Uri intentUri = Uri.parse("googlechrome://navigate?url=$url");

    if (await canLaunchUrl(intentUri)) {
      await launchUrl(intentUri);
    } else {
      // Open in default external browser
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }


}