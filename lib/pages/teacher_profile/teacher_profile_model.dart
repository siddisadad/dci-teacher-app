import '/components/bottom_nav/bottom_nav_widget.dart';
import '/components/button/button_widget.dart';
import '/components/profile_field/profile_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'teacher_profile_widget.dart' show TeacherProfileWidget;
import 'package:flutter/material.dart';

class TeacherProfileModel extends FlutterFlowModel<TeacherProfileWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for ProfileField.
  late ProfileFieldModel profileFieldModel1;
  // Model for ProfileField.
  late ProfileFieldModel profileFieldModel2;
  // Model for ProfileField.
  late ProfileFieldModel profileFieldModel3;
  // Model for ProfileField.
  late ProfileFieldModel profileFieldModel4;
  // Model for ProfileField.
  late ProfileFieldModel profileFieldModel5;
  // Model for ProfileField.
  late ProfileFieldModel profileFieldModel6;
  // Model for ProfileField.
  late ProfileFieldModel profileFieldModel7;
  // Model for Button.
  late ButtonModel buttonModel1;
  // Model for Button.
  late ButtonModel buttonModel2;
  // Model for BottomNav.
  late BottomNavModel bottomNavModel;

  @override
  void initState(BuildContext context) {
    profileFieldModel1 = createModel(context, () => ProfileFieldModel());
    profileFieldModel2 = createModel(context, () => ProfileFieldModel());
    profileFieldModel3 = createModel(context, () => ProfileFieldModel());
    profileFieldModel4 = createModel(context, () => ProfileFieldModel());
    profileFieldModel5 = createModel(context, () => ProfileFieldModel());
    profileFieldModel6 = createModel(context, () => ProfileFieldModel());
    profileFieldModel7 = createModel(context, () => ProfileFieldModel());
    buttonModel1 = createModel(context, () => ButtonModel());
    buttonModel2 = createModel(context, () => ButtonModel());
    bottomNavModel = createModel(context, () => BottomNavModel());
  }

  @override
  void dispose() {
    profileFieldModel1.dispose();
    profileFieldModel2.dispose();
    profileFieldModel3.dispose();
    profileFieldModel4.dispose();
    profileFieldModel5.dispose();
    profileFieldModel6.dispose();
    profileFieldModel7.dispose();
    buttonModel1.dispose();
    buttonModel2.dispose();
    bottomNavModel.dispose();
  }
}
