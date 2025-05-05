import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../theme/app_colors.dart';
import '../../widgets/implementation_badge.dart';

class AboutLegalInformationScreen extends StatefulWidget {
  static const routeName = '/settings/about';

  const AboutLegalInformationScreen({Key? key}) : super(key: key);

  @override
  _AboutLegalInformationScreenState createState() => _AboutLegalInformationScreenState();
}

class _AboutLegalInformationScreenState extends State<AboutLegalInformationScreen> {
  bool _isLoading = true;
  String _appVersion = '';
  String _buildNumber = '';
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _loadAppInfo();
  }
  
  Future<void> _loadAppInfo() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      // In a real app, this would use the package_info_plus package
      // to get the app version and build number
      final packageInfo = await Future.delayed(
        const Duration(milliseconds: 500),
        () => {
          'version': '1.0.0',
          'buildNumber': '10',
        },
      );
      
      setState(() {
        _appVersion = packageInfo['version']!;
        _buildNumber = packageInfo['buildNumber']!;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load app information: ${e.toString()}';
        _isLoading = false;
      });
    }
  }
  
  void _openPrivacyPolicy() {
    // In a real app, this would open the privacy policy in a webview or external browser
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Privacy Policy'),
      ),
    );
  }
  
  void _openTermsOfService() {
    // In a real app, this would open the terms of service in a webview or external browser
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening Terms of Service'),
      ),
    );
  }
  
  void _openLicenses() {
    showLicensePage(
      context: context,
      applicationName: 'Global Remit',
      applicationVersion: _appVersion,
      applicationIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/app_icon.png',
          width: 48,
          height: 48,
        ),
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
  
  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
    );
  }
  
  Widget _buildAppInfo() {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Image.asset(
              'assets/images/app_icon.png',
              width: 72,
              height: 72,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Global Remit',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Version $_appVersion (Build $_buildNumber)',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '© ${DateTime.now().year} Global Remit Corp.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
  
  Widget _buildLegalSection() {
    return Column(
      children: [
        _buildSectionHeader('Legal Information'),
        _buildDivider(),
        ListTile(
          leading: Icon(Icons.privacy_tip, color: AppColors.primary),
          title: const Text('Privacy Policy'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _openPrivacyPolicy,
        ),
        _buildDivider(),
        ListTile(
          leading: Icon(Icons.description, color: AppColors.primary),
          title: const Text('Terms of Service'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _openTermsOfService,
        ),
        _buildDivider(),
        ListTile(
          leading: Icon(Icons.policy, color: AppColors.primary),
          title: const Text('Open Source Licenses'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: _openLicenses,
        ),
      ],
    );
  }
  
  Widget _buildContactSection() {
    return Column(
      children: [
        _buildSectionHeader('Contact Us'),
        _buildDivider(),
        ListTile(
          leading: Icon(Icons.email, color: AppColors.primary),
          title: const Text('support@globalremit.com'),
          onTap: () {
            // In a real app, this would open the email client
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Opening email client'),
              ),
            );
          },
        ),
        _buildDivider(),
        ListTile(
          leading: Icon(Icons.phone, color: AppColors.primary),
          title: const Text('+1 (800) 123-4567'),
          subtitle: const Text('Toll-free, 24/7 customer service'),
          onTap: () {
            // In a real app, this would open the phone app
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Opening phone app'),
              ),
            );
          },
        ),
        _buildDivider(),
        ListTile(
          leading: Icon(Icons.public, color: AppColors.primary),
          title: const Text('www.globalremit.com'),
          onTap: () {
            // In a real app, this would open the website in a browser
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Opening website'),
              ),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildSocialMediaSection() {
    return Column(
      children: [
        _buildSectionHeader('Follow Us'),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(Icons.facebook, 'Facebook'),
            const SizedBox(width: 24),
            _buildSocialButton(Icons.toggle_on, 'Twitter'),
            const SizedBox(width: 24),
            _buildSocialButton(Icons.camera_alt, 'Instagram'),
            const SizedBox(width: 24),
            _buildSocialButton(Icons.video_camera_back, 'YouTube'),
          ],
        ),
      ],
    );
  }
  
  Widget _buildSocialButton(IconData icon, String label) {
    return InkWell(
      onTap: () {
        // In a real app, this would open the social media page
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening $label page')),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
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
                          onPressed: _loadAppInfo,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildAppInfo(),
                        const SizedBox(height: 32),
                        _buildLegalSection(),
                        const SizedBox(height: 16),
                        _buildContactSection(),
                        const SizedBox(height: 16),
                        _buildSocialMediaSection(),
                        const SizedBox(height: 32),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            children: [
                              const TextSpan(
                                text: 'Global Remit helps you securely send money to friends and family worldwide. ',
                              ),
                              TextSpan(
                                text: 'Learn more',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Opening about page'),
                                      ),
                                    );
                                  },
                              ),
                            ],
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