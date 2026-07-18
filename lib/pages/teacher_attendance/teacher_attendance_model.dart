import '/components/attendance_option/attendance_option_widget.dart';
import '/components/bottom_nav/bottom_nav_widget.dart';
import '/components/button/button_widget.dart';
import '/components/text_field/text_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'teacher_attendance_widget.dart' show TeacherAttendanceWidget;
import 'package:flutter/material.dart';

class TeacherAttendanceModel extends FlutterFlowModel<TeacherAttendanceWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for AttendanceOption.
  late AttendanceOptionModel attendanceOptionModel1;
  // Model for AttendanceOption.
  late AttendanceOptionModel attendanceOptionModel2;
  // Model for AttendanceOption.
  late AttendanceOptionModel attendanceOptionModel3;
  // Model for TextField.
  late TextFieldModel textFieldModel;
  // Model for Button.
  late ButtonModel buttonModel1;
  // Model for Button.
  late ButtonModel buttonModel2;
  // Model for BottomNav.
  late BottomNavModel bottomNavModel;

  @override
  void initState(BuildContext context) {
    attendanceOptionModel1 =
        createModel(context, () => AttendanceOptionModel());
    attendanceOptionModel2 =
        createModel(context, () => AttendanceOptionModel());
    attendanceOptionModel3 =
        createModel(context, () => AttendanceOptionModel());
    textFieldModel = createModel(context, () => TextFieldModel());
    buttonModel1 = createModel(context, () => ButtonModel());
    buttonModel2 = createModel(context, () => ButtonModel());
    bottomNavModel = createModel(context, () => BottomNavModel());
  }

  @override
  void dispose() {
    attendanceOptionModel1.dispose();
    attendanceOptionModel2.dispose();
    attendanceOptionModel3.dispose();
    textFieldModel.dispose();
    buttonModel1.dispose();
    buttonModel2.dispose();
    bottomNavModel.dispose();
  }
}
