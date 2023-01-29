import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  static void scanText(String rawText) {
    final text = rawText.toLowerCase();

    if (text.contains('write email')) {
      final body = _getTextAfterCommand(text: text, command: 'write email');

      openEmail(body: body);
    } else if (text.contains('go to')) {
      final url = _getTextAfterCommand(text: text, command: 'go to');

      openLink(url: url);
    }
  }

  static String _getTextAfterCommand({
    required String text,
    required String command,
  }) {
    final indexCommand = text.indexOf(command);
    final indexAfter = indexCommand + command.length;

    if (indexCommand == -1) {
      return '';
    } else {
      return text.substring(indexAfter).trim();
    }
  }

  static Future openLink({
    required String url,
  }) async {
    await _launchUrl('https://$url');
  }

  static Future openEmail({
    required String body,
  }) async {
    final url = 'mailto: ?body=${Uri.encodeFull(body)}';
    await _launchUrl(url);
  }

  static Future _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    }
  }
}
