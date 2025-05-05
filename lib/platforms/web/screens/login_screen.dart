import 'package:flutter/material.dart';
import '../../base_login_screen.dart';
import '../../../utils/platform_utils.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/colors.dart';

class WebLoginScreen extends StatelessWidget {
  const WebLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left panel with illustration
          Expanded(
            child: Container(
              color: GlobalRemitColors.primaryBlue(context),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.send_money,
                      size: 120,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Global Remit',
                      style: GlobalRemitTypography.largeTitle(context)
                          .copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Send money globally with ease',
                      style: GlobalRemitTypography.body(context)
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right panel with login form
          Expanded(
            child: Container(
              color: GlobalRemitColors.primaryBackground(context),
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(48),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                        const SizedBox(height: 48),
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              children: [
                                _buildEmailField(context),
                                const SizedBox(height: 24),
                                _buildPasswordField(context),
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: double.infinity,
                                  child: _buildLoginButton(context),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: TextButton(
                                    onPressed: () {
                                      // TODO: Navigate to forgot password
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: GlobalRemitTypography.body(context)
                                          .copyWith(color: GlobalRemitColors.primaryBlue(context)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: GlobalRemitTypography.body(context)
            .copyWith(color: GlobalRemitColors.gray2(context)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        prefixIcon: Icon(
          Icons.email,
          color: GlobalRemitColors.gray2(context),
        ),
        enabled: !_isLoading,
        filled: true,
        fillColor: GlobalRemitColors.secondaryBackground(context),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: GlobalRemitTypography.body(context)
            .copyWith(color: GlobalRemitColors.gray2(context)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: GlobalRemitColors.gray2(context),
        ),
        suffixIcon: Icon(
          Icons.visibility_off,
          color: GlobalRemitColors.gray2(context),
        ),
        enabled: !_isLoading,
        filled: true,
        fillColor: GlobalRemitColors.secondaryBackground(context),
      ),
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _login,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
      ),
      child: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : Text(
              'Sign In',
              style: GlobalRemitTypography.body(context)
                  .copyWith(color: Colors.white),
            ),
    );
  }
}
