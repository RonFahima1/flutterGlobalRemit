import '../models/chat_message.dart';
import '../models/faq.dart';
import '../models/support_topic.dart';

class SupportService {
  // In a real app, this would use a database or API for persistence
  
  Future<List<SupportTopic>> getSupportTopics() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // In a real app, this would fetch support topics from a database or API
    return [
      SupportTopic(
        id: '1',
        title: 'Account & Registration',
        description: 'Manage your account, registration issues, and login help',
        icon: Icons.account_circle,
        tags: ['Account', 'Login', 'Registration', 'Password'],
      ),
      SupportTopic(
        id: '2',
        title: 'Money Transfers',
        description: 'Information about sending money, fees, and transfer times',
        icon: Icons.swap_horiz,
        tags: ['Transfers', 'Fees', 'Exchange Rates', 'Tracking'],
      ),
      SupportTopic(
        id: '3',
        title: 'Cards & Payments',
        description: 'Help with virtual cards, payment methods, and transactions',
        icon: Icons.credit_card,
        tags: ['Cards', 'Payments', 'Transactions'],
      ),
      SupportTopic(
        id: '4',
        title: 'Security & Privacy',
        description: 'Account security, verification, and privacy concerns',
        icon: Icons.security,
        tags: ['Security', 'Privacy', 'Verification', 'KYC'],
      ),
      SupportTopic(
        id: '5',
        title: 'Mobile App',
        description: 'Troubleshooting app issues and feature guidance',
        icon: Icons.smartphone,
        tags: ['App', 'Mobile', 'Technical Issues'],
      ),
      SupportTopic(
        id: '6',
        title: 'Fees & Limits',
        description: 'Information about service fees and transfer limits',
        icon: Icons.attach_money,
        tags: ['Fees', 'Limits', 'Pricing'],
      ),
      SupportTopic(
        id: '7',
        title: 'Business Accounts',
        description: 'Support for business and corporate accounts',
        icon: Icons.business,
        tags: ['Business', 'Corporate', 'B2B'],
      ),
    ];
  }
  
  Future<List<FAQ>> getFAQs() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // In a real app, this would fetch FAQs from a database or API
    return [
      FAQ(
        id: '1',
        question: 'How do I create an account?',
        answer: 'To create an account, download the app from your app store, tap on "Register", and follow the on-screen instructions. You\'ll need to provide some personal information and verification documents to complete the process.',
        category: 'Account',
        relatedLinks: [
          RelatedLink(title: 'Registration Guide', url: '/help/registration'),
          RelatedLink(title: 'Required Documents', url: '/help/documents'),
        ],
      ),
      FAQ(
        id: '2',
        question: 'What are the fees for sending money?',
        answer: 'Fees vary based on the amount you\'re sending, the destination country, and the payment method. You can see the exact fee before confirming any transfer. We offer competitive rates starting from as low as \$1.99 for most corridors.',
        category: 'Fees',
        relatedLinks: [
          RelatedLink(title: 'Fee Calculator', url: '/tools/fee-calculator'),
          RelatedLink(title: 'Fee Schedule', url: '/legal/fees'),
        ],
      ),
      FAQ(
        id: '3',
        question: 'How long do transfers take?',
        answer: 'Transfer times vary depending on the destination and payment method. Domestic transfers are typically completed within minutes. International transfers can take 1-3 business days for bank deposits, but can be instant for mobile wallet transfers in supported countries.',
        category: 'Transfers',
        relatedLinks: [
          RelatedLink(title: 'Transfer Times by Country', url: '/help/transfer-times'),
        ],
      ),
      FAQ(
        id: '4',
        question: 'How do I reset my password?',
        answer: 'To reset your password, go to the login screen and tap on "Forgot Password". Enter your registered email address, and we\'ll send you a password reset link. Follow the instructions in the email to create a new password.',
        category: 'Account',
        relatedLinks: [
          RelatedLink(title: 'Account Security Tips', url: '/help/security'),
        ],
      ),
      FAQ(
        id: '5',
        question: 'Is my personal information secure?',
        answer: 'Yes, we take security very seriously. We use industry-standard encryption to protect your personal and financial information. We also employ multi-factor authentication and regular security audits to ensure the highest level of protection for our users.',
        category: 'Security',
        relatedLinks: [
          RelatedLink(title: 'Security Measures', url: '/legal/security'),
          RelatedLink(title: 'Privacy Policy', url: '/legal/privacy'),
        ],
      ),
      FAQ(
        id: '6',
        question: 'What is KYC and why do I need to complete it?',
        answer: 'KYC (Know Your Customer) is a regulatory requirement that helps prevent fraud and money laundering. We need to verify your identity to comply with these regulations. This typically involves providing a government-issued ID and proof of address.',
        category: 'Security',
        relatedLinks: [
          RelatedLink(title: 'KYC Process', url: '/help/kyc'),
          RelatedLink(title: 'Acceptable Documents', url: '/help/documents'),
        ],
      ),
      FAQ(
        id: '7',
        question: 'How do I track my transfer?',
        answer: 'You can track your transfer in the app under "Transaction History". Select the transfer you want to track to see its current status. You\'ll also receive notifications as your transfer progresses through each stage.',
        category: 'Transfers',
        relatedLinks: [
          RelatedLink(title: 'Transfer Statuses Explained', url: '/help/transfer-status'),
        ],
      ),
      FAQ(
        id: '8',
        question: 'Can I cancel a transfer?',
        answer: 'You can cancel a transfer as long as it hasn\'t been completed yet. Go to "Transaction History", select the transfer you want to cancel, and tap on "Cancel Transfer". If the transfer has already been completed, you\'ll need to contact customer support for assistance.',
        category: 'Transfers',
        relatedLinks: [
          RelatedLink(title: 'Cancellation Policy', url: '/legal/cancellation'),
        ],
      ),
      FAQ(
        id: '9',
        question: 'How do virtual cards work?',
        answer: 'Virtual cards work just like physical cards but exist only digitally. You can use them for online purchases and mobile payments. You can create a virtual card in the app, set spending limits, and freeze/unfreeze it as needed.',
        category: 'Cards',
        relatedLinks: [
          RelatedLink(title: 'Virtual Card Guide', url: '/help/virtual-cards'),
          RelatedLink(title: 'Card Security', url: '/help/card-security'),
        ],
      ),
      FAQ(
        id: '10',
        question: 'What countries can I send money to?',
        answer: 'We currently support money transfers to over 100 countries worldwide. The full list is available in the app when you initiate a transfer. We\'re constantly expanding our coverage to reach more countries and regions.',
        category: 'Transfers',
        relatedLinks: [
          RelatedLink(title: 'Supported Countries', url: '/help/countries'),
        ],
      ),
      FAQ(
        id: '11',
        question: 'What are the transfer limits?',
        answer: 'Transfer limits vary based on your verification level, transfer destination, and payment method. Basic accounts typically have lower limits, while fully verified accounts enjoy higher limits. You can view your current limits in the app under "Account Settings" > "Limits".',
        category: 'Fees',
        relatedLinks: [
          RelatedLink(title: 'Increasing Your Limits', url: '/help/limits'),
        ],
      ),
      FAQ(
        id: '12',
        question: 'How do I add a beneficiary?',
        answer: 'To add a beneficiary, go to "Recipients" in the app and tap on "Add New". Enter the required information (which varies by country and payment method). Once added, you can easily select this beneficiary for future transfers.',
        category: 'Transfers',
        relatedLinks: [
          RelatedLink(title: 'Managing Recipients', url: '/help/recipients'),
        ],
      ),
    ];
  }
  
  Future<List<ChatMessage>> initializeChat() async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));
    
    // In a real app, this would initialize a chat session with the server
    final now = DateTime.now();
    
    return [
      ChatMessage(
        id: '1',
        content: 'Welcome to Global Remit Support! How can we assist you today?',
        sender: MessageSender.system,
        timestamp: now,
        status: MessageStatus.delivered,
      ),
    ];
  }
  
  Future<void> sendChatMessage(String message) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real app, this would send the message to the server
    // and store it in the chat history
  }
}