import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms & Conditions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last updated: May 5, 2025',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 32),
            _buildSection(
              title: 'Acceptance of Terms',
              content: '''
By using our app, you agree to be bound by these Terms & Conditions. If you do not agree with any part of these terms, please do not use our app.
''',
            ),
            _buildSection(
              title: 'Account Registration',
              content: '''
To access certain features of our app, you may need to register for an account. You must provide accurate and complete information during registration and update it as necessary.
''',
            ),
            _buildSection(
              title: 'Transaction Rules',
              content: '''
- You must have sufficient funds in your account to complete transactions
- Transactions may be subject to verification and may be delayed for security reasons
- We reserve the right to reject any transaction that appears suspicious or fraudulent
''',
            ),
            _buildSection(
              title: 'Security',
              content: '''
- You are responsible for maintaining the confidentiality of your account credentials
- You must notify us immediately of any unauthorized use of your account
- We use industry-standard security measures to protect your information
''',
            ),
            _buildSection(
              title: 'Limitation of Liability',
              content: '''
- We are not liable for any indirect, incidental, special, or consequential damages
- Our liability is limited to the amount of fees paid by you in the last 12 months
- We are not responsible for any unauthorized access to your account
''',
            ),
            _buildSection(
              title: 'Changes to Terms',
              content: '''
We reserve the right to modify these Terms & Conditions at any time. Your continued use of the app after any changes constitutes your acceptance of the new terms.
''',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(content),
        ],
      ),
    );
  }
}
