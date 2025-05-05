import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Privacy Policy'),
        border: null,
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Your Privacy Matters',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'We are fully committed to protecting your privacy and personal data. '
              'We use advanced encryption, do not resell your data, and only collect information necessary to provide our services.',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey,
              ),
            ),
            const SizedBox(height: 24),
            _CupertinoPolicySection(
              title: 'Information We Collect',
              content: 'We collect several types of information from and about users of our app:\n\n'
                  '• Personal Information: When you register for an account, we collect your name, email address, and other information you provide.\n'
                  '• Transaction Information: When you make transactions, we collect information about the transactions including amounts, dates, and recipient information.\n'
                  '• Device Information: We may collect information about your device, including device type, operating system, and IP address.',
            ),
            _CupertinoPolicySection(
              title: 'How We Use Your Information',
              content: 'We use the information we collect to:\n\n'
                  '• Provide and maintain our app\n'
                  '• Process transactions and maintain account security\n'
                  '• Send you notifications about important changes to our app\n'
                  '• Improve our app and develop new features\n'
                  '• Prevent fraud and protect our users',
            ),
            _CupertinoPolicySection(
              title: 'Data Security',
              content: 'We take appropriate security measures to protect against unauthorized access to or unauthorized alteration, '
                  'disclosure, or destruction of data. These include internal reviews of our data collection, storage, and processing '
                  'practices and security measures.',
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Last updated: May 5, 2025',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? CupertinoColors.systemGrey2 : CupertinoColors.systemGrey2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CupertinoPolicySection extends StatelessWidget {
  final String title;
  final String content;
  
  const _CupertinoPolicySection({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.activeBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey,
            ),
          ),
        ],
      ),
    );
  }
}
