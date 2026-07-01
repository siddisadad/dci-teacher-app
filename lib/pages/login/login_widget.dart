import '/auth/firebase_auth/auth_util.dart';
import '/components/button/button_widget.dart';
import '/components/text_field/text_field_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_model.dart';
export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'Login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;
  bool isLoading = false;
  bool isCreateAccount = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Form(
          key: _model.formKey,
          child: Padding(
            padding: EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                      child: Container(
                        child: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      FlutterFlowTheme.of(context).primary,
                                      FlutterFlowTheme.of(context).primary.withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                  shape: BoxShape.rectangle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: FlutterFlowTheme.of(context).primary.withOpacity(0.3),
                                      blurRadius: 12.0,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Icon(
                                  Icons.school_rounded,
                                  color: Colors.white,
                                  size: 60.0,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'DCI Teacher App',
                                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                                      font: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context).primary,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context).headlineMedium.fontStyle,
                                      lineHeight: 1.25,
                                    ),
                                  ),
                                  Text(
                                    'Deshmukh Coaching Institute',
                                    style: FlutterFlowTheme.of(context).labelLarge.override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context).secondaryText,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context).labelLarge.fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context).labelLarge.fontStyle,
                                      lineHeight: 1.33,
                                    ),
                                  ),
                                ].divide(SizedBox(height: 4.0)),
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome Back',
                          style: FlutterFlowTheme.of(context).headlineSmall.override(
                            font: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).primaryText,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                            lineHeight: 1.3,
                          ),
                        ),
                        Text(
                          'Sign in to manage your classes',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                            lineHeight: 1.47,
                          ),
                        ),
                      ].divide(SizedBox(height: 4.0)),
                    ),
                  ].divide(SizedBox(height: 32.0)),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        wrapWithModel(
                          model: _model.textFieldModel1,
                          updateCallback: () => safeSetState(() {}),
                          child: TextFieldWidget(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            label: 'Email',
                            labelPresent: true,
                            helper: '',
                            helperPresent: false,
                            leadingIcon: Icon(
                              Icons.email_outlined,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            leadingIconPresent: true,
                            trailingIconPresent: false,
                            hint: 'Enter your email',
                            value: '',
                            onChange: '',
                            onSubmit: '',
                            variant: 'outlined',
                            error: false,
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        wrapWithModel(
                          model: _model.textFieldModel2,
                          updateCallback: () => safeSetState(() {}),
                          child: TextFieldWidget(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            label: 'Password',
                            labelPresent: true,
                            helper: '',
                            helperPresent: false,
                            leadingIcon: Icon(
                              Icons.lock_outline_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            leadingIconPresent: true,
                            trailingIcon: Icon(
                              Icons.visibility_off_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24.0,
                            ),
                            trailingIconPresent: true,
                            hint: '••••••••',
                            value: '',
                            onChange: '',
                            onSubmit: '',
                            variant: 'outlined',
                            error: false,
                            obscureText: true,
                          ),
                        ),
                      ].divide(SizedBox(height: 16.0)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: isLoading
                              ? null
                              : () async {
                                  if (!_model.formKey.currentState!.validate()) {
                                    return;
                                  }

                                  final email = _model.textFieldModel1.inputTextController?.text.trim() ?? '';
                                  final password = _model.textFieldModel2.inputTextController?.text ?? '';

                                  setState(() => isLoading = true);
                                  BaseAuthUser? user;

try {
  user = isCreateAccount
      ? await authManager.createAccountWithEmail(
          context,
          email,
          password,
        )
      : await authManager.signInWithEmail(
          context,
          email,
          password,
        );
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(e.toString())),
  );
}
                                  setState(() => isLoading = false);

                                  if (user == null) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Google Sign-In cancelled'),
    ),
  );
  return;
}

context.goNamed(HomeDashboardWidget.routeName);
                                },
                          child: wrapWithModel(
                            model: _model.buttonModel1,
                            updateCallback: () => safeSetState(() {}),
                            child: ButtonWidget(
                              iconPresent: false,
                              iconEndPresent: false,
                              content: isCreateAccount ? 'Create Account' : 'Login',
                              variant: 'primary',
                              size: 'large',
                              fullWidth: true,
                              loading: isLoading,
                              disabled: isLoading,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: isLoading
                                ? null
                                : () async {
                                    setState(() => isLoading = true);
                                    final user = await authManager.signInWithGoogle(context);
                                    setState(() => isLoading = false);
                                    if (user != null) {
                                      context.goNamed(HomeDashboardWidget.routeName);
                                    }
                                  },
                            child: wrapWithModel(
                              model: _model.buttonModel2,
                              updateCallback: () => safeSetState(() {}),
                              child: ButtonWidget(
                                icon: Icon(
                                  Icons.g_mobiledata,
                                  color: FlutterFlowTheme.of(context).primary,
                                  size: 24.0,
                                ),
                                iconPresent: true,
                                iconEndPresent: false,
                                content: 'Sign in with Google',
                                variant: 'outline',
                                size: 'large',
                                fullWidth: true,
                                loading: isLoading,
                                disabled: isLoading,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    setState(() => isCreateAccount = !isCreateAccount);
                                  },
                            child: Text(
                              isCreateAccount ? 'Already have an account? Login' : 'Create a new account',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                lineHeight: 1.47,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: TextButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    final email = _model.textFieldModel1.inputTextController?.text.trim() ?? '';
                                    if (email.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Please enter your email to reset password.')),
                                      );
                                      return;
                                    }
                                    await authManager.resetPassword(
                                      context: context,
                                      email: email,
                                    );
                                  },
                            child: Text(
                              'Forgot Password?',
                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primary,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                lineHeight: 1.47,
                              ),
                            ),
                          ),
                        ),
                      ].divide(SizedBox(height: 8.0)),
                    ),
                  ].divide(SizedBox(height: 24.0)),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                  child: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Version 1.0.0',
                          style: FlutterFlowTheme.of(context).labelSmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                              fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).onBackground,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                            fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                            lineHeight: 1.27,
                          ),
                        ),
                        Text(
                          '© ${DateTime.now().year} Deshmukh Coaching Institute',
                          style: FlutterFlowTheme.of(context).labelSmall.override(
                            font: GoogleFonts.inter(
                              fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                              fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).onBackground,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context).labelSmall.fontWeight,
                            fontStyle: FlutterFlowTheme.of(context).labelSmall.fontStyle,
                            lineHeight: 1.27,
                          ),
                        ),
                      ].divide(SizedBox(height: 4.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
