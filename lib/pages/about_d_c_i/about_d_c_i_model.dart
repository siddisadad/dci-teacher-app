import '/components/bottom_nav/bottom_nav_widget.dart';
import '/components/info_row/info_row_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'about_d_c_i_widget.dart' show AboutDCIWidget;
import 'package:flutter/material.dart';

class AboutDCIModel extends FlutterFlowModel<AboutDCIWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for InfoRow.
  late InfoRowModel infoRowModel1;
  // Model for InfoRow.
  late InfoRowModel infoRowModel2;
  // Model for InfoRow.
  late InfoRowModel infoRowModel3;
  // Model for InfoRow.
  late InfoRowModel infoRowModel4;
  // Model for BottomNav.
  late BottomNavModel bottomNavModel;

  @override
  void initState(BuildContext context) {
    infoRowModel1 = createModel(context, () => InfoRowModel());
    infoRowModel2 = createModel(context, () => InfoRowModel());
    infoRowModel3 = createModel(context, () => InfoRowModel());
    infoRowModel4 = createModel(context, () => InfoRowModel());
    bottomNavModel = createModel(context, () => BottomNavModel());
  }

  @override
  void dispose() {
    infoRowModel1.dispose();
    infoRowModel2.dispose();
    infoRowModel3.dispose();
    infoRowModel4.dispose();
    bottomNavModel.dispose();
  }
}
