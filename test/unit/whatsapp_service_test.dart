import 'package:flutter_test/flutter_test.dart';
import 'package:d_c_i_teacher_app/backend/services/whatsapp_service.dart';

void main() {
  test('Cloud API sends are no-ops without compile-time secrets', () async {
    final service = WhatsappService();
    expect(service.isConfigured, isFalse);
    expect(
      await service.sendTextMessage(to: '919999999999', message: 'hi'),
      isFalse,
    );
    expect(
      await service.sendTemplateMessage(
          to: '919999999999', templateName: 'hello'),
      isFalse,
    );
  });
}
