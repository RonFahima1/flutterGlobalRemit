import 'package:flutter/material.dart';
import '../../models/chat_message.dart';
import '../../services/support_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/implementation_badge.dart';

class LiveChatScreen extends StatefulWidget {
  static const routeName = '/support/live-chat';

  const LiveChatScreen({Key? key}) : super(key: key);

  @override
  _LiveChatScreenState createState() => _LiveChatScreenState();
}

class _LiveChatScreenState extends State<LiveChatScreen> {
  final SupportService _supportService = SupportService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  List<ChatMessage> _messages = [];
  bool _isConnecting = true;
  bool _isTyping = false;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _initChat();
  }
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  Future<void> _initChat() async {
    try {
      setState(() {
        _isConnecting = true;
        _errorMessage = null;
      });
      
      // In a real app, this would establish a WebSocket connection to the chat server
      await Future.delayed(const Duration(seconds: 2));
      
      // Get initial welcome message
      final initialMessages = await _supportService.initializeChat();
      
      setState(() {
        _messages = initialMessages;
        _isConnecting = false;
      });
      
      // After a short delay, show agent typing indicator
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _isTyping = true;
      });
      
      // After another delay, show the agent response
      await Future.delayed(const Duration(seconds: 2));
      
      final agentMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: 'Hello! How can I help you today with your Global Remit account?',
        sender: MessageSender.agent,
        timestamp: DateTime.now(),
        status: MessageStatus.delivered,
        agentName: 'Sarah',
      );
      
      setState(() {
        _messages.add(agentMessage);
        _isTyping = false;
      });
      
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to connect to chat: ${e.toString()}';
        _isConnecting = false;
      });
    }
  }
  
  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    
    final newMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _messageController.text.trim(),
      sender: MessageSender.user,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );
    
    setState(() {
      _messages.add(newMessage);
      _messageController.clear();
    });
    
    _scrollToBottom();
    
    // Simulate message sending
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        final index = _messages.indexWhere((msg) => msg.id == newMessage.id);
        if (index != -1) {
          _messages[index] = _messages[index].copyWith(status: MessageStatus.sent);
        }
      });
    });
    
    // Simulate agent typing
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isTyping = true;
      });
    });
    
    // Simulate agent response
    Future.delayed(const Duration(seconds: 3), () {
      final response = _getAgentResponse(newMessage.content);
      
      final agentMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response,
        sender: MessageSender.agent,
        timestamp: DateTime.now(),
        status: MessageStatus.delivered,
        agentName: 'Sarah',
      );
      
      setState(() {
        _messages.add(agentMessage);
        _isTyping = false;
      });
      
      _scrollToBottom();
    });
  }
  
  String _getAgentResponse(String message) {
    // A simple response generator based on keywords
    final lowerMessage = message.toLowerCase();
    
    if (lowerMessage.contains('transfer') || lowerMessage.contains('send money')) {
      return 'To make a transfer, go to the Transfer Money section on the dashboard. You can send money internationally or domestically from there. Is there a specific country you want to send money to?';
    } else if (lowerMessage.contains('fee') || lowerMessage.contains('cost') || lowerMessage.contains('charge')) {
      return 'Our fees vary based on the transfer amount, destination country, and payment method. You can see the exact fee for your transfer before you confirm it. For most common destinations, fees start as low as \$1.99.';
    } else if (lowerMessage.contains('card') || lowerMessage.contains('virtual card')) {
      return 'You can manage your virtual and physical cards in the Cards section. From there, you can view card details, freeze/unfreeze cards, and adjust spending limits. Would you like me to guide you through setting up a new virtual card?';
    } else if (lowerMessage.contains('verify') || lowerMessage.contains('verification') || lowerMessage.contains('kyc')) {
      return 'To complete account verification, go to Profile > KYC Verification. You'll need to upload a valid ID document and proof of address. This usually takes 1-2 business days to process. Has your verification been pending for longer than that?';
    } else if (lowerMessage.contains('problem') || lowerMessage.contains('issue') || lowerMessage.contains('help')) {
      return 'I\'m sorry to hear you\'re having issues. Can you please provide more details about the problem you\'re experiencing so I can better assist you?';
    } else {
      return 'Thank you for your message. How else can I assist you with your Global Remit account today?';
    }
  }
  
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }
  
  Widget _buildChatBubble(ChatMessage message) {
    final isUser = message.sender == MessageSender.user;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Text(
                message.agentName?[0] ?? 'A',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primary : Colors.grey[200],
                borderRadius: BorderRadius.circular(16).copyWith(
                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser && message.agentName != null) ...[
                    Text(
                      message.agentName!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  Text(
                    message.content,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 10,
                          color: isUser ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.status == MessageStatus.sending
                              ? Icons.access_time
                              : message.status == MessageStatus.sent
                                  ? Icons.check
                                  : Icons.done_all,
                          size: 12,
                          color: Colors.white70,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  
  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: const Text(
              'S',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(16).copyWith(
                bottomLeft: const Radius.circular(4),
                bottomRight: const Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(),
                const SizedBox(width: 2),
                _buildDot(delay: 300),
                const SizedBox(width: 2),
                _buildDot(delay: 600),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDot({int delay = 0}) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        borderRadius: BorderRadius.circular(4),
      ),
      child: PulseAnimation(delay: delay),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Live Chat Support'),
            Text(
              _isConnecting ? 'Connecting...' : 'Online',
              style: TextStyle(
                fontSize: 12,
                color: _isConnecting ? Colors.orange : Colors.green,
              ),
            ),
          ],
        ),
        actions: const [
          ImplementationBadge(
            isImplemented: true,
            implementationDate: 'Now',
          ),
        ],
      ),
      body: SafeArea(
        child: _errorMessage != null
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
                      onPressed: _initChat,
                      child: const Text('Reconnect'),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  if (_isConnecting)
                    const LinearProgressIndicator()
                  else
                    const SizedBox(height: 2),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(bottom: 16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildChatBubble(_messages[index]);
                      },
                    ),
                  ),
                  if (_isTyping) _buildTypingIndicator(),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, -1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.attach_file),
                          onPressed: () {
                            // In a real app, this would open the file picker
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('File attachment would open here'),
                              ),
                            );
                          },
                        ),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          color: AppColors.primary,
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Animation for typing indicator
class PulseAnimation extends StatefulWidget {
  final int delay;

  const PulseAnimation({Key? key, this.delay = 0}) : super(key: key);

  @override
  _PulseAnimationState createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(),
    );
  }
}