import '/components/text_field/text_field_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'form_section_child2_model.dart';
export 'form_section_child2_model.dart';

class FormSectionChild2Widget extends StatefulWidget {
  const FormSectionChild2Widget({super.key});

  @override
  State<FormSectionChild2Widget> createState() =>
      _FormSectionChild2WidgetState();
}

class _FormSectionChild2WidgetState extends State<FormSectionChild2Widget> {
  late FormSectionChild2Model _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FormSectionChild2Model());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        wrapWithModel(
          model: _model.textFieldModel1,
          updateCallback: () => safeSetState(() {}),
          child: TextFieldWidget(
            label: 'Topic Title',
            labelPresent: true,
            helper: '',
            helperPresent: false,
            leadingIconPresent: false,
            trailingIconPresent: false,
            hint: 'e.g. Quadratic Equations Practice',
            value: '',
            onChange: '',
            onSubmit: '',
            variant: 'outlined',
            error: false,
          ),
        ),
        wrapWithModel(
          model: _model.textFieldModel2,
          updateCallback: () => safeSetState(() {}),
          child: TextFieldWidget(
            label: 'Detailed Instructions',
            labelPresent: true,
            helper: '',
            helperPresent: false,
            leadingIconPresent: false,
            trailingIconPresent: false,
            hint: 'Enter questions or page numbers...',
            value: '',
            onChange: '',
            onSubmit: '',
            variant: 'outlined',
            error: false,
          ),
        ),
      ],
    );
  }
}
