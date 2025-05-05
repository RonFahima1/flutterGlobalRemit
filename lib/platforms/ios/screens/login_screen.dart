import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../base_login_screen.dart';
import '../../../utils/platform_utils.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/colors.dart';

class IOSLoginScreen extends StatefulWidget {
  const IOSLoginScreen({super.key});

  @override
  State<IOSLoginScreen> createState() => _IOSLoginScreenState();
}

class _IOSLoginScreenState extends State<IOSLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Sign In',
          style: GlobalRemitTypography.title3(context)
              .copyWith(color: GlobalRemitColors.gray1(context)),
        ),
        backgroundColor: GlobalRemitColors.primaryBackground(context),
        border: const Border(),
      ),
      backgroundColor: GlobalRemitColors.primaryBackground(context),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome Back',
                  style: GlobalRemitTypography.title1(context),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: GlobalRemitTypography.body(context)
                      .copyWith(color: GlobalRemitColors.gray2(context)),
                ),
                const SizedBox(height: 32),
                CupertinoTextField(
                  controller: _emailController,
                  placeholder: 'Email',
                  placeholderStyle: GlobalRemitTypography.body(context)
                      .copyWith(color: GlobalRemitColors.gray2(context)),
                  prefix: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      CupertinoIcons.mail,
                      color: GlobalRemitColors.gray2(context),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  decoration: BoxDecoration(
                    color: GlobalRemitColors.secondaryBackground(context),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  enabled: !_isLoading,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _passwordController,
                  placeholder: 'Password',
                  placeholderStyle: GlobalRemitTypography.body(context)
                      .copyWith(color: GlobalRemitColors.gray2(context)),
                  prefix: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      CupertinoIcons.lock,
                      color: GlobalRemitColors.gray2(context),
                    ),
                  ),
                  suffix: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Icon(
                      CupertinoIcons.eye_slash,
                      color: GlobalRemitColors.gray2(context),
                    ),
                  ),
                  obscureText: true,
                  decoration: BoxDecoration(
                    color: GlobalRemitColors.secondaryBackground(context),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 24),
                CupertinoButton.filled(
                  onPressed: _isLoading ? null : _login,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  borderRadius: BorderRadius.circular(13),
                  child: _isLoading
                      ? const CupertinoActivityIndicator()
                      : Text(
                          'Sign In',
                          style: GlobalRemitTypography.body(context)
                              .copyWith(color: Colors.white),
                        ),
                ),
                const SizedBox(height: 16),
                CupertinoButton(
                  onPressed: () {
                    // TODO: Navigate to forgot password
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GlobalRemitTypography.body(context)
                        .copyWith(color: GlobalRemitColors.primaryBlue(context)),
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
