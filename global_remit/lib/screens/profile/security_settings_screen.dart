import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../models/user.dart';
import '../../services/user_service.dart';
import '../../services/auth_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/implementation_badge.dart';

class SecuritySettingsScreen extends StatefulWidget {
  static const routeName = '/profile/security-settings';

  const SecuritySettingsScreen({Key? key}) : super(key: key);

  @override
  _SecuritySettingsScreenState createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  
  bool _isLoading = true;
  String? _errorMessage;
  
  // Security settings
  bool _twoFactorEnabled = false;
  bool _biometricsEnabled = false;
  bool _pinEnabled = false;
  bool _loginNotificationsEnabled = true;
  bool _paymentNotificationsEnabled = true;
  
  @override
  void initState() {
    super.initState();
    _loadSecuritySettings();
  }
  
  Future<void> _loadSecuritySettings() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      // In a real app, this would load the security settings from the backend
      final securitySettings = await _userService.getSecuritySettings();
      
      setState(() {
        _twoFactorEnabled = securitySettings.twoFactorEnabled;
        _biometricsEnabled = securitySettings.biometricsEnabled;
        _pinEnabled = securitySettings.pinEnabled;
        _loginNotificationsEnabled = securitySettings.loginNotificationsEnabled;
        _paymentNotificationsEnabled = securitySettings.paymentNotificationsEnabled;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load security settings: ${e.toString()}';
        _isLoading = false;
      });
    }
  }
  
  Future<void> _toggleTwoFactor(bool value) async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // In a real app, this would toggle 2FA on the backend
      if (value) {
        // Setup 2FA process
        bool success = await _authService.enableTwoFactor();
        if (success) {
          setState(() {
            _twoFactorEnabled = true;
          });
        }
      } else {
        // Confirm with the user before disabling 2FA
        bool confirmed = await _showConfirmDialog(
          'Disable Two-Factor Authentication',
          'This will make your account less secure. Are you sure you want to continue?',
        );
        
        if (confirmed) {
          bool success = await _authService.disableTwoFactor();
          if (success) {
            setState(() {
              _twoFactorEnabled = false;
            });
          }
        }
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update two-factor authentication: ${e.toString()}';
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> _toggleBiometrics(bool value) async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // In a real app, this would toggle biometric authentication
      bool success = await _authService.toggleBiometrics(value);
      
      if (success) {
        setState(() {
          _biometricsEnabled = value;
        });
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update biometric authentication: ${e.toString()}';
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> _togglePin(bool value) async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      if (value) {
        // In a real app, this would open a PIN setup screen
        // For now, we'll just simulate success
        bool success = await _authService.setupPin();
        
        if (success) {
          setState(() {
            _pinEnabled = true;
          });
        }
      } else {
        bool confirmed = await _showConfirmDialog(
          'Disable PIN Authentication',
          'This will remove your PIN code. Are you sure you want to continue?',
        );
        
        if (confirmed) {
          bool success = await _authService.removePin();
          
          if (success) {
            setState(() {
              _pinEnabled = false;
            });
          }
        }
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update PIN: ${e.toString()}';
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> _toggleLoginNotifications(bool value) async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // In a real app, this would update the notification settings on the backend
      bool success = await _userService.updateNotificationSettings(
        loginNotifications: value,
        paymentNotifications: _paymentNotificationsEnabled,
      );
      
      if (success) {
        setState(() {
          _loginNotificationsEnabled = value;
        });
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update notification settings: ${e.toString()}';
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> _togglePaymentNotifications(bool value) async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // In a real app, this would update the notification settings on the backend
      bool success = await _userService.updateNotificationSettings(
        loginNotifications: _loginNotificationsEnabled,
        paymentNotifications: value,
      );
      
      if (success) {
        setState(() {
          _paymentNotificationsEnabled = value;
        });
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to update notification settings: ${e.toString()}';
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<bool> _showConfirmDialog(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Disable'),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }
  
  void _changePassword() {
    // In a real app, this would navigate to a password change screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password change screen would open here'),
      ),
    );
  }
  
  void _viewDevices() {
    // In a real app, this would navigate to a devices management screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Devices management screen would open here'),
      ),
    );
  }
  
  void _viewActivityLog() {
    // In a real app, this would navigate to an activity log screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Activity log screen would open here'),
      ),
    );
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildSwitchItem({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: AppColors.primary,
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: _isLoading ? null : onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionItem({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: AppColors.primary,
              ),
              const SizedBox(width: 16),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Settings'),
        actions: const [
          ImplementationBadge(
            isImplemented: true,
            implementationDate: 'Now',
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading && _errorMessage == null
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadSecuritySettings,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.security,
                                      size: 40,
                                      color: AppColors.primary,
                                    ),
                                    const SizedBox(width: 16),
                                    const Expanded(
                                      child: Text(
                                        'Protect your account with additional security measures',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        _buildSectionHeader('Authentication'),
                        const Divider(),
                        
                        _buildSwitchItem(
                          title: 'Two-Factor Authentication',
                          subtitle: 'Require a verification code when signing in',
                          value: _twoFactorEnabled,
                          onChanged: _toggleTwoFactor,
                          icon: Icons.lock,
                        ),
                        
                        _buildSwitchItem(
                          title: 'Biometric Authentication',
                          subtitle: 'Use fingerprint or face recognition to authenticate',
                          value: _biometricsEnabled,
                          onChanged: _toggleBiometrics,
                          icon: Icons.fingerprint,
                        ),
                        
                        _buildSwitchItem(
                          title: 'PIN Authentication',
                          subtitle: 'Use a PIN code to authenticate sensitive operations',
                          value: _pinEnabled,
                          onChanged: _togglePin,
                          icon: Icons.pin,
                        ),
                        
                        _buildActionItem(
                          title: 'Change Password',
                          subtitle: 'Update your account password',
                          onTap: _changePassword,
                          icon: Icons.password,
                        ),
                        
                        _buildSectionHeader('Privacy & Security'),
                        const Divider(),
                        
                        _buildActionItem(
                          title: 'Connected Devices',
                          subtitle: 'Manage devices connected to your account',
                          onTap: _viewDevices,
                          icon: Icons.devices,
                        ),
                        
                        _buildActionItem(
                          title: 'Activity Log',
                          subtitle: 'View recent account activity',
                          onTap: _viewActivityLog,
                          icon: Icons.history,
                        ),
                        
                        _buildSectionHeader('Notifications'),
                        const Divider(),
                        
                        _buildSwitchItem(
                          title: 'Login Notifications',
                          subtitle: 'Get notified when someone logs into your account',
                          value: _loginNotificationsEnabled,
                          onChanged: _toggleLoginNotifications,
                          icon: Icons.login,
                        ),
                        
                        _buildSwitchItem(
                          title: 'Payment Notifications',
                          subtitle: 'Get notified about payment activities',
                          value: _paymentNotificationsEnabled,
                          onChanged: _togglePaymentNotifications,
                          icon: Icons.payment,
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Red button for emergency actions
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () {
                              // Show dialog to confirm account lock
                              _showConfirmDialog(
                                'Lock Your Account',
                                'This will temporarily lock your account and prevent any transactions. You will need to contact customer support to unlock it.',
                              ).then((confirmed) {
                                if (confirmed) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Account would be locked here'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                }
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Lock Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}