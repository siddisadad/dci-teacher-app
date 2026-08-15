import 'package:cloud_functions/cloud_functions.dart';
import 'package:url_launcher/url_launcher.dart';

typedef WhatsAppCallable = Future<dynamic> Function(
  String name,
  Map<String, dynamic> data,
);

class WhatsappService {
  WhatsappService({WhatsAppCallable? invoke}) : _invoke = invoke;

  final WhatsAppCallable? _invoke;

  Future<dynamic> _call(String name, Map<String, dynamic> data) {
    if (_invoke != null) return _invoke!(name, data);
    return FirebaseFunctions.instance.httpsCallable(name).call(data);
  }

  /// Opens the WhatsApp app on the device with a pre-filled message.
  /// If [phone] is provided, it opens a direct chat with that number.
  /// If [phone] is null, it opens the WhatsApp contact/group picker.
  Future<bool> launchWhatsapp({String? phone, required String message}) async {
    String url;
    if (phone != null && phone.isNotEmpty) {
      // Format phone number: remove non-digits
      final cleanPhone = phone.replaceAll(RegExp(r'\D'), '');
      url = "https://wa.me/$cleanPhone/?text=${Uri.encodeComponent(message)}";
    } else {
      // This protocol often triggers the contact picker in the app
      url = "whatsapp://send?text=${Uri.encodeComponent(message)}";
    }

    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // Fallback to wa.me if whatsapp:// protocol is not supported
        final webUrl =
            Uri.parse("https://wa.me/?text=${Uri.encodeComponent(message)}");
        return await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendTemplateMessage({
    required String to,
    required String templateName,
    List<String> parameters = const [],
    String languageCode = 'en_US',
  }) async {
    try {
      await _call('sendWhatsAppMessage', {
        'to': to,
        'type': 'template',
        'templateName': templateName,
        'parameters': parameters,
        'languageCode': languageCode,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendTextMessage({
    required String to,
    required String message,
  }) async {
    try {
      await _call('sendWhatsAppMessage', {
        'to': to,
        'type': 'text',
        'message': message,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
