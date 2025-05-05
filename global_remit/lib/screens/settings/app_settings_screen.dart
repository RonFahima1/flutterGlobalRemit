import 'package:flutter/material.dart';
import '../../services/settings_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/implementation_badge.dart';

class AppSettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const AppSettingsScreen({Key? key}) : super(key: key);

  @override
  _AppSettingsScreenState createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  final SettingsService _settingsService = SettingsService();
  
  bool _isLoading = true;
  String? _errorMessage;
  
  // App settings
  ThemeMode _themeMode = ThemeMode.system;
  String _selectedLanguage = 'English';
  bool _notificationsEnabled = true;
  bool _soundsEnabled = true;
  bool _hapticFeedbackEnabled = true;
  
  // Currency settings
  String _selectedCurrency = 'USD';
  
  // Privacy settings
  bool _analyticsEnabled = true;
  bool _locationEnabled = true;
  
  @override
  void initState() {
    super.initState();
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      // In a real app, this would load the settings from shared preferences or backend
      final settings = await _settingsService.getAppSettings();
      
      setState(() {
        _themeMode = settings.themeMode;
        _selectedLanguage = settings.language;
        _notificationsEnabled = settings.notificationsEnabled;
        _soundsEnabled = settings.soundsEnabled;
        _hapticFeedbackEnabled = settings.hapticFeedbackEnabled;
        _selectedCurrency = settings.currency;
        _analyticsEnabled = settings.analyticsEnabled;
        _locationEnabled = settings.locationEnabled;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load settings: ${e.toString()}';
        _isLoading = false;
      });
    }
  }
  
  Future<void> _saveSettings() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // In a real app, this would save the settings to shared preferences or backend
      await _settingsService.saveAppSettings(
        themeMode: _themeMode,
        language: _selectedLanguage,
        notificationsEnabled: _notificationsEnabled,
        soundsEnabled: _soundsEnabled,
        hapticFeedbackEnabled: _hapticFeedbackEnabled,
        currency: _selectedCurrency,
        analyticsEnabled: _analyticsEnabled,
        locationEnabled: _locationEnabled,
      );
      
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Settings saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to save settings: ${e.toString()}';
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
  
  void _setThemeMode(ThemeMode? themeMode) {
    if (themeMode != null) {
      setState(() {
        _themeMode = themeMode;
      });
    }
  }
  
  void _setLanguage(String? language) {
    if (language != null) {
      setState(() {
        _selectedLanguage = language;
      });
    }
  }
  
  void _setCurrency(String? currency) {
    if (currency != null) {
      setState(() {
        _selectedCurrency = currency;
      });
    }
  }
  
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 8.0, left: 16.0, right: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
    );
  }
  
  Widget _buildSettingItem({
    required String title,
    String? subtitle,
    required Widget trailing,
    VoidCallback? onTap,
    IconData? icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: AppColors.primary,
                size: 24,
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
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
  
  Widget _buildThemeSelector() {
    return _buildSettingItem(
      title: 'Theme',
      subtitle: _themeMode == ThemeMode.system
          ? 'System default'
          : _themeMode == ThemeMode.light
              ? 'Light'
              : 'Dark',
      icon: Icons.brightness_4,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Select Theme'),
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('System default'),
                value: ThemeMode.system,
                groupValue: _themeMode,
                onChanged: (value) {
                  Navigator.pop(context);
                  _setThemeMode(value);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Light'),
                value: ThemeMode.light,
                groupValue: _themeMode,
                onChanged: (value) {
                  Navigator.pop(context);
                  _setThemeMode(value);
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark'),
                value: ThemeMode.dark,
                groupValue: _themeMode,
                onChanged: (value) {
                  Navigator.pop(context);
                  _setThemeMode(value);
                },
              ),
            ],
          ),
        );
      },
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
    );
  }
  
  Widget _buildLanguageSelector() {
    return _buildSettingItem(
      title: 'Language',
      subtitle: _selectedLanguage,
      icon: Icons.language,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Select Language'),
            children: [
              RadioListTile<String>(
                title: const Text('English'),
                value: 'English',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  Navigator.pop(context);
                  _setLanguage(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('Spanish'),
                value: 'Spanish',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  Navigator.pop(context);
                  _setLanguage(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('French'),
                value: 'French',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  Navigator.pop(context);
                  _setLanguage(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('German'),
                value: 'German',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  Navigator.pop(context);
                  _setLanguage(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('Chinese'),
                value: 'Chinese',
                groupValue: _selectedLanguage,
                onChanged: (value) {
                  Navigator.pop(context);
                  _setLanguage(value);
                },
              ),
            ],
          ),
        );
      },
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
    );
  }
  
  Widget _buildCurrencySelector() {
    return _buildSettingItem(
      title: 'Default Currency',
      subtitle: _selectedCurrency,
      icon: Icons.monetization_on,
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            title: const Text('Select Currency'),
            children: [
              RadioListTile<String>(
                title: const Text('USD - US Dollar'),
                value: 'USD',
                groupValue: _selectedCurrency,
                onChanged: (value) {
                  Navigator.pop(context);
                  _setCurrency(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('EUR - Euro'),
                value: 'EUR',
                groupValue: _selectedCurrency,
                onChanged: (value) {
                  Navigator.pop(context);
                  _setCurrency(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('GBP - British Pound'),
                value: 'GBP',
                groupValue: _selectedCurrency,
                onChanged: (value) {
                  Navigator.pop(context);
                  _setCurrency(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('JPY - Japanese Yen'),
                value: 'JPY',
                groupValue: _selectedCurrency,
                onChanged: (value) {
                  Navigator.pop(context);
                  _setCurrency(value);
                },
              ),
              RadioListTile<String>(
                title: const Text('CAD - Canadian Dollar'),
                value: 'CAD',
                groupValue: _selectedCurrency,
                onChanged: (value) {
                  Navigator.pop(context);
                  _setCurrency(value);
                },
              ),
            ],
          ),
        );
      },
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
    );
  }
  
  Widget _buildNotificationToggle() {
    return _buildSettingItem(
      title: 'Notifications',
      subtitle: _notificationsEnabled ? 'Enabled' : 'Disabled',
      icon: Icons.notifications,
      trailing: Switch(
        value: _notificationsEnabled,
        onChanged: (value) {
          setState(() {
            _notificationsEnabled = value;
          });
        },
        activeColor: AppColors.primary,
      ),
    );
  }
  
  Widget _buildSoundsToggle() {
    return _buildSettingItem(
      title: 'Sounds',
      subtitle: _soundsEnabled ? 'Enabled' : 'Disabled',
      icon: Icons.volume_up,
      trailing: Switch(
        value: _soundsEnabled,
        onChanged: (value) {
          setState(() {
            _soundsEnabled = value;
          });
        },
        activeColor: AppColors.primary,
      ),
    );
  }
  
  Widget _buildHapticFeedbackToggle() {
    return _buildSettingItem(
      title: 'Haptic Feedback',
      subtitle: _hapticFeedbackEnabled ? 'Enabled' : 'Disabled',
      icon: Icons.vibration,
      trailing: Switch(
        value: _hapticFeedbackEnabled,
        onChanged: (value) {
          setState(() {
            _hapticFeedbackEnabled = value;
          });
        },
        activeColor: AppColors.primary,
      ),
    );
  }
  
  Widget _buildAnalyticsToggle() {
    return _buildSettingItem(
      title: 'Analytics',
      subtitle: 'Allow us to collect anonymous usage data to improve the app',
      icon: Icons.analytics,
      trailing: Switch(
        value: _analyticsEnabled,
        onChanged: (value) {
          setState(() {
            _analyticsEnabled = value;
          });
        },
        activeColor: AppColors.primary,
      ),
    );
  }
  
  Widget _buildLocationToggle() {
    return _buildSettingItem(
      title: 'Location Services',
      subtitle: 'Allow app to access your location for nearby features',
      icon: Icons.location_on,
      trailing: Switch(
        value: _locationEnabled,
        onChanged: (value) {
          setState(() {
            _locationEnabled = value;
          });
        },
        activeColor: AppColors.primary,
      ),
    );
  }
  
  Widget _buildAboutButton() {
    return _buildSettingItem(
      title: 'About',
      subtitle: 'App version, legal information, and credits',
      icon: Icons.info,
      onTap: () {
        Navigator.pushNamed(context, '/settings/about');
      },
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
    );
  }
  
  Widget _buildSecurityButton() {
    return _buildSettingItem(
      title: 'Security',
      subtitle: 'Manage security settings and preferences',
      icon: Icons.security,
      onTap: () {
        Navigator.pushNamed(context, '/profile/security-settings');
      },
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey[400],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: const [
          ImplementationBadge(
            isImplemented: true,
            implementationDate: 'Now',
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
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
                          onPressed: _loadSettings,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Appearance'),
                        _buildDivider(),
                        _buildThemeSelector(),
                        _buildLanguageSelector(),
                        
                        _buildSectionHeader('Preferences'),
                        _buildDivider(),
                        _buildCurrencySelector(),
                        _buildNotificationToggle(),
                        _buildSoundsToggle(),
                        _buildHapticFeedbackToggle(),
                        
                        _buildSectionHeader('Privacy'),
                        _buildDivider(),
                        _buildAnalyticsToggle(),
                        _buildLocationToggle(),
                        
                        _buildSectionHeader('Other'),
                        _buildDivider(),
                        _buildSecurityButton(),
                        _buildAboutButton(),
                        
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _saveSettings,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Save Settings',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        Center(
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Reset Settings'),
                                  content: const Text('Are you sure you want to reset all settings to default values?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _loadSettings();
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                      child: const Text('Reset'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: const Text('Reset to Default'),
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
      ),
    );
  }
}