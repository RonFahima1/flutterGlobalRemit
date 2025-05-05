import 'package:flutter/material.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Common Questions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildQuestionCard(
                    question: 'How do I transfer money?',
                    answer: 'To transfer money, go to the Send Money screen and follow the instructions. You can transfer to any account using their account number or phone number.',
                  ),
                  _buildQuestionCard(
                    question: 'What are the transaction limits?',
                    answer: 'The daily transaction limit is \$5000. You can increase this limit by verifying your account with additional documentation.',
                  ),
                  _buildQuestionCard(
                    question: 'How do I report a problem?',
                    answer: 'You can report any issues by tapping the Report Issue button below. Our support team will get back to you as soon as possible.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Support',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Call Support'),
                    subtitle: const Text('Available 24/7'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Implement call support
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email Support'),
                    subtitle: const Text('Response within 24 hours'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Implement email support
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.chat),
                    title: const Text('Live Chat'),
                    subtitle: const Text('Available 9am-5pm'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // TODO: Implement live chat
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard({required String question, required String answer}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(answer),
          ],
        ),
      ),
    );
  }
}
