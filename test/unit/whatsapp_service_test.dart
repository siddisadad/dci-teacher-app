import 'package:flutter_test/flutter_test.dart';
import 'package:d_c_i_teacher_app/backend/services/whatsapp_service.dart';

void main() {
  test('Cloud API sends fail closed when the callable is unavailable',
      () async {
    final service = WhatsappService(
      invoke: (name, data) => throw Exception('not configured'),
    );
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

  test('Cloud API sends go through the sendWhatsAppMessage callable', () async {
    String? calledName;
    Map<String, dynamic>? calledData;
    final service = WhatsappService(
      invoke: (name, data) async {
        calledName = name;
        calledData = data;
        return {'ok': true};
      },
    );

    expect(
      await service.sendTextMessage(to: '919999999999', message: 'hi'),
      isTrue,
    );
    expect(calledName, 'sendWhatsAppMessage');
    expect(calledData, {
      'to': '919999999999',
      'type': 'text',
      'message': 'hi',
    });
  });
}
