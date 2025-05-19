import 'package:url_launcher/url_launcher.dart';

void sendInvite(String listId) async {
  final message = "Join my Grocery List on our app! List ID: $listId";
  final uri = Uri.parse("https://wa.me/?text=${Uri.encodeFull(message)}");
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw "Could not launch WhatsApp";
  }
}
