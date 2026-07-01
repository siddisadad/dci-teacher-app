import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'form_field_label_model.dart';
export 'form_field_label_model.dart';

class FormFieldLabelWidget extends StatefulWidget {
  const FormFieldLabelWidget({
    super.key,
    String? label,
  }) : this.label = label ?? 'Class';

  final String label;

  @override
  State<FormFieldLabelWidget> createState() => _FormFieldLabelWidgetState();
}

class _FormFieldLabelWidgetState extends State<FormFieldLabelWidget> {
  late FormFieldLabelModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FormFieldLabelModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      valueOrDefault<String>(
        widget.label,
        'Class',
      ),
      style: FlutterFlowTheme.of(context).labelLarge.override(
            font: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
            ),
            color: FlutterFlowTheme.of(context).primaryText,
            letterSpacing: 0.0,
            fontWeight: FontWeight.w600,
            fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
            lineHeight: 1.33,
          ),
    );
  }
}
