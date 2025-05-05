import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/platform_utils.dart';
import '../../theme/theme_constants.dart';

class BaseLoginScreen extends StatefulWidget {
  const BaseLoginScreen({super.key});

  @override
  State<BaseLoginScreen> createState() => _BaseLoginScreenState();
}

class _BaseLoginScreenState extends State<BaseLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final success = await context.read<AuthProvider>().login(
          email: _emailController.text,
          password: _passwordController.text,
        );

        if (success) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Login failed. Please check your credentials.',
                style: GlobalRemitTypography.body(context)
                    .copyWith(color: GlobalRemitColors.errorRed(context)),
              ),
              backgroundColor: GlobalRemitColors.errorRed(context)
                  .withOpacity(0.1),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'An error occurred. Please try again.',
              style: GlobalRemitTypography.body(context)
                  .copyWith(color: GlobalRemitColors.errorRed(context)),
            ),
            backgroundColor: GlobalRemitColors.errorRed(context)
                .withOpacity(0.1),
          ),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: GlobalRemitTypography.body(context)
            .copyWith(color: GlobalRemitColors.gray2(context)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
        ),
        prefixIcon: Icon(
          Icons.email,
          color: GlobalRemitColors.gray2(context),
        ),
        enabled: !_isLoading,
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
          borderRadius: BorderRadius.circular(13),
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
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
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
                  _buildEmailField(context),
                  const SizedBox(height: 16),
                  _buildPasswordField(context),
                  const SizedBox(height: 24),
                  _buildLoginButton(context),
                  const SizedBox(height: 16),
                  TextButton(
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
      ),
    );
  }
}
