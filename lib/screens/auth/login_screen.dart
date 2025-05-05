import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/platform_utils.dart';
import '../../theme/theme_constants.dart';
import '../../theme/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _emailError;
  String? _passwordError;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _emailError = 'Email is required');
    } else if (!email.contains('@')) {
      setState(() => _emailError = 'Please enter a valid email');
    } else {
      setState(() => _emailError = null);
    }
  }

  void _validatePassword() {
    final password = _passwordController.text;
    if (password.isEmpty) {
      setState(() => _passwordError = 'Password is required');
    } else if (password.length < 6) {
      setState(() => _passwordError = 'Password must be at least 6 characters');
    } else {
      setState(() => _passwordError = null);
    }
  }

  Future<void> _login() async {
    _validateEmail();
    _validatePassword();

    if (_emailError == null && _passwordError == null) {
      try {
        await context.read<AuthProvider>().login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
        
        // Navigate to home screen on success
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } catch (e) {
        // Show error message
        if (mounted) {
          if (PlatformUtils.isIOS) {
            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text('Login Failed'),
                content: Text('Login failed: ${e.toString()}'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Login failed: ${e.toString()}'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isTablet = PlatformUtils.isTablet(context);
    final isWeb = PlatformUtils.isWeb;
    final maxWidth = isTablet || isWeb ? 450.0 : size.width;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo and App Name
                  Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.attach_money,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Global Remit',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Send money globally, quickly and securely',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // Email Field
                  if (PlatformUtils.isIOS)
                    CupertinoTextField(
                      controller: _emailController,
                      placeholder: 'Email',
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(CupertinoIcons.mail),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      keyboardType: TextInputType.emailAddress,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _emailError != null 
                              ? CupertinoColors.systemRed 
                              : CupertinoColors.systemGrey4,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onChanged: (_) => _emailError != null ? _validateEmail() : null,
                    )
                  else
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        errorText: _emailError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (_) => _emailError != null ? _validateEmail() : null,
                    ),
                  
                  if (PlatformUtils.isIOS && _emailError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 12),
                      child: Text(
                        _emailError!,
                        style: const TextStyle(
                          color: CupertinoColors.systemRed,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Password Field
                  if (PlatformUtils.isIOS)
                    CupertinoTextField(
                      controller: _passwordController,
                      placeholder: 'Password',
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Icon(CupertinoIcons.lock),
                      ),
                      suffix: CupertinoButton(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(
                          _isPasswordVisible 
                              ? CupertinoIcons.eye_slash 
                              : CupertinoIcons.eye,
                          color: CupertinoColors.systemGrey,
                        ),
                        onPressed: () {
                          setState(() => _isPasswordVisible = !_isPasswordVisible);
                        },
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      obscureText: !_isPasswordVisible,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _passwordError != null 
                              ? CupertinoColors.systemRed 
                              : CupertinoColors.systemGrey4,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onChanged: (_) => _passwordError != null ? _validatePassword() : null,
                    )
                  else
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        errorText: _passwordError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() => _isPasswordVisible = !_isPasswordVisible);
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                      onChanged: (_) => _passwordError != null ? _validatePassword() : null,
                    ),
                  
                  if (PlatformUtils.isIOS && _passwordError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 6, left: 12),
                      child: Text(
                        _passwordError!,
                        style: const TextStyle(
                          color: CupertinoColors.systemRed,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Remember me and Forgot Password
                  Row(
                    children: [
                      if (PlatformUtils.isIOS)
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Row(
                            children: [
                              Icon(
                                _rememberMe 
                                    ? CupertinoIcons.checkmark_square_fill 
                                    : CupertinoIcons.square,
                                color: _rememberMe 
                                    ? theme.colorScheme.primary 
                                    : CupertinoColors.systemGrey,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text('Remember me'),
                            ],
                          ),
                          onPressed: () {
                            setState(() => _rememberMe = !_rememberMe);
                          },
                        )
                      else
                        Row(
                          children: [
                            Checkbox(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() => _rememberMe = value ?? false);
                              },
                            ),
                            const Text('Remember me'),
                          ],
                        ),
                      
                      const Spacer(),
                      
                      if (PlatformUtils.isIOS)
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                        )
                      else
                        TextButton(
                          child: const Text('Forgot Password?'),
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Login Button
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, _) {
                      final isLoading = authProvider.isLoading;
                      
                      if (PlatformUtils.isIOS) {
                        return CupertinoButton(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          color: theme.colorScheme.primary,
                          child: isLoading 
                              ? const CupertinoActivityIndicator(color: Colors.white)
                              : const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          onPressed: isLoading ? null : _login,
                        );
                      } else {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: isLoading ? null : _login,
                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      }
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Sign up link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (PlatformUtils.isIOS)
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                        )
                      else
                        TextButton(
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                        ),
                    ],
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
