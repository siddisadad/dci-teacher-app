import '/components/button/button_widget.dart';
import '/components/text_field/text_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'login_widget.dart' show LoginWidget;
import 'package:flutter/material.dart';

class LoginModel extends FlutterFlowModel<LoginWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();

  // Model for TextField.
  late TextFieldModel textFieldModel1;
  // Model for TextField.
  late TextFieldModel textFieldModel2;
  // Model for Button.
  late ButtonModel buttonModel1;
  // Model for Button.
  late ButtonModel buttonModel2;

  @override
  void initState(BuildContext context) {
    textFieldModel1 = createModel(context, () => TextFieldModel());
    textFieldModel1.inputTextControllerValidator = (
      BuildContext context,
      String? value,
    ) {
      if (value == null || value.trim().isEmpty) {
        return 'Email is required.';
      }
      final emailExp = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+\$');
      if (!emailExp.hasMatch(value.trim())) {
        return 'Enter a valid email address.';
      }
      return null;
    };

    textFieldModel2 = createModel(context, () => TextFieldModel());
    textFieldModel2.inputTextControllerValidator = (
      BuildContext context,
      String? value,
    ) {
      if (value == null || value.isEmpty) {
        return 'Password is required.';
      }
      if (value.length < 6) {
        return 'Password must be at least 6 characters.';
      }
      return null;
    };
    buttonModel1 = createModel(context, () => ButtonModel());
    buttonModel2 = createModel(context, () => ButtonModel());
  }

  @override
  void dispose() {
    textFieldModel1.dispose();
    textFieldModel2.dispose();
    buttonModel1.dispose();
    buttonModel2.dispose();
  }
}
