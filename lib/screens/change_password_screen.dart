import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorText;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 20.0).animate(
      CurvedAnimation(
        parent: _shakeController,
        curve: Curves.elasticIn,
      ),
    );
  }

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _showError(String text) {
    setState(() {
      _errorText = text;
    });
    _shakeController.forward(from: 0.0);
  }

  Future<void> _handleChangePassword() async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    // Simulate backend delay
    await Future.delayed(const Duration(seconds: 2));

    // Simple validation logic for demo
    if (_currentController.text.isEmpty ||
        _newController.text.isEmpty ||
        _confirmController.text.isEmpty) {
      _showError('Please fill all fields');
      setState(() => _isLoading = false);
      return;
    }
    if (_newController.text != _confirmController.text) {
      _showError('Passwords do not match');
      setState(() => _isLoading = false);
      return;
    }
    if (_newController.text.length < 8) {
      _showError('New password must be at least 8 characters');
      setState(() => _isLoading = false);
      return;
    }
    // Assume success!
    setState(() {
      _isSuccess = true;
      _isLoading = false;
      _errorText = null;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = isDark 
        ? GlobalRemitColors.errorRedDark 
        : GlobalRemitColors.errorRedLight;
        
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Change Password'),
      ),
      backgroundColor: isDark 
          ? GlobalRemitColors.primaryBackgroundDark
          : GlobalRemitColors.primaryBackgroundLight,
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CupertinoTextField(
                    controller: _currentController,
                    obscureText: true,
                    placeholder: 'Current Password',
                    enabled: !_isLoading,
                    keyboardType: TextInputType.visiblePassword,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    style: GlobalRemitTypography.body(context),
                    decoration: BoxDecoration(
                      color: isDark
                          ? GlobalRemitColors.secondaryBackgroundDark
                          : GlobalRemitColors.secondaryBackgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    controller: _newController,
                    obscureText: true,
                    placeholder: 'New Password',
                    enabled: !_isLoading,
                    keyboardType: TextInputType.visiblePassword,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    style: GlobalRemitTypography.body(context),
                    decoration: BoxDecoration(
                      color: isDark
                          ? GlobalRemitColors.secondaryBackgroundDark
                          : GlobalRemitColors.secondaryBackgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  const SizedBox(height: 16),
                  CupertinoTextField(
                    controller: _confirmController,
                    obscureText: true,
                    placeholder: 'Confirm Password',
                    enabled: !_isLoading,
                    keyboardType: TextInputType.visiblePassword,
                    clearButtonMode: OverlayVisibilityMode.editing,
                    style: GlobalRemitTypography.body(context),
                    decoration: BoxDecoration(
                      color: isDark
                          ? GlobalRemitColors.secondaryBackgroundDark
                          : GlobalRemitColors.secondaryBackgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  const SizedBox(height: 24),
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(
                          _errorText == null ? 0 : _shakeAnimation.value * (DateTime.now().millisecond % 2 == 0 ? 1 : -1),
                          0,
                        ),
                        child: child,
                      );
                    },
                    child: _errorText != null
                        ? Text(
                            _errorText!,
                            style: TextStyle(
                              color: errorColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : const SizedBox(height: 20),
                  ),
                  const SizedBox(height: 24),
                  CupertinoButton.filled(
                    borderRadius: BorderRadius.circular(22),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 16),
                    disabledColor: GlobalRemitColors.primaryBlue.withOpacity(0.5),
                    onPressed: _isLoading ? null : _handleChangePassword,
                    child: _isLoading
                        ? const CupertinoActivityIndicator()
                        : const Text(
                            'Change Password',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17),
                          ),
                  ),
                  if (_isSuccess)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        color: GlobalRemitColors.secondaryGreen,
                        size: 48,
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
