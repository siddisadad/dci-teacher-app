import '/components/bottom_nav/bottom_nav_widget.dart';
import '/components/button/button_widget.dart';
import '/components/date_picker_field/date_picker_field_widget.dart';
import '/components/form_section/form_section_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'homework_assignment_widget.dart' show HomeworkAssignmentWidget;
import 'package:flutter/material.dart';

class HomeworkAssignmentModel
    extends FlutterFlowModel<HomeworkAssignmentWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for DatePickerField.
  late DatePickerFieldModel datePickerFieldModel1;
  // Model for DatePickerField.
  late DatePickerFieldModel datePickerFieldModel2;
  // Model for FormSection.
  late FormSectionModel formSectionModel1;
  // Model for FormSection.
  late FormSectionModel formSectionModel2;
  // Model for FormSection.
  late FormSectionModel formSectionModel3;
  // Model for Button.
  late ButtonModel buttonModel1;
  // Model for Button.
  late ButtonModel buttonModel2;
  // Model for BottomNav.
  late BottomNavModel bottomNavModel;

  @override
  void initState(BuildContext context) {
    datePickerFieldModel1 = createModel(context, () => DatePickerFieldModel());
    datePickerFieldModel2 = createModel(context, () => DatePickerFieldModel());
    formSectionModel1 = createModel(context, () => FormSectionModel());
    formSectionModel2 = createModel(context, () => FormSectionModel());
    formSectionModel3 = createModel(context, () => FormSectionModel());
    buttonModel1 = createModel(context, () => ButtonModel());
    buttonModel2 = createModel(context, () => ButtonModel());
    bottomNavModel = createModel(context, () => BottomNavModel());
  }

  @override
  void dispose() {
    datePickerFieldModel1.dispose();
    datePickerFieldModel2.dispose();
    formSectionModel1.dispose();
    formSectionModel2.dispose();
    formSectionModel3.dispose();
    buttonModel1.dispose();
    buttonModel2.dispose();
    bottomNavModel.dispose();
  }
}
