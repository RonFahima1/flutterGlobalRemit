import 'package:flutter/material.dart';
import '../../models/notification_item.dart';
import '../../services/notification_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/implementation_badge.dart';

class NotificationCenterScreen extends StatefulWidget {
  static const routeName = '/notifications';

  const NotificationCenterScreen({Key? key}) : super(key: key);

  @override
  _NotificationCenterScreenState createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> with SingleTickerProviderStateMixin {
  final NotificationService _notificationService = NotificationService();
  late TabController _tabController;
  
  bool _isLoading = true;
  List<NotificationItem> _notifications = [];
  List<NotificationItem> _filteredNotifications = [];
  String? _errorMessage;
  
  final List<String> _categories = ['All', 'Transactions', 'Security', 'System', 'Promotions'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadNotifications();
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }
  
  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      _filterNotifications(_tabController.index);
    }
  }
  
  Future<void> _loadNotifications() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      final notifications = await _notificationService.getNotifications();
      
      setState(() {
        _notifications = notifications;
        _filterNotifications(_tabController.index);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load notifications: ${e.toString()}';
        _isLoading = false;
      });
    }
  }
  
  void _filterNotifications(int categoryIndex) {
    setState(() {
      if (categoryIndex == 0) {
        // "All" category
        _filteredNotifications = List.from(_notifications);
      } else {
        final category = _categories[categoryIndex];
        _filteredNotifications = _notifications
            .where((notification) => notification.category == category)
            .toList();
      }
    });
  }
  
  Future<void> _markAllAsRead() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      await _notificationService.markAllAsRead();
      
      setState(() {
        _notifications = _notifications.map((notification) {
          return notification.copyWith(isRead: true);
        }).toList();
        _filterNotifications(_tabController.index);
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All notifications marked as read'),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to mark notifications as read: ${e.toString()}';
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
  
  Future<void> _clearAllNotifications() async {
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Clear All Notifications'),
          content: const Text('Are you sure you want to clear all notifications? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Clear All'),
            ),
          ],
        ),
      );
      
      if (confirmed != true) return;
      
      setState(() {
        _isLoading = true;
      });
      
      await _notificationService.clearAllNotifications();
      
      setState(() {
        _notifications = [];
        _filteredNotifications = [];
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All notifications cleared'),
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to clear notifications: ${e.toString()}';
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
  
  Future<void> _markAsRead(NotificationItem notification) async {
    try {
      await _notificationService.markAsRead(notification.id);
      
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == notification.id);
        if (index != -1) {
          _notifications[index] = notification.copyWith(isRead: true);
          _filterNotifications(_tabController.index);
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to mark notification as read: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  Future<void> _deleteNotification(NotificationItem notification) async {
    try {
      await _notificationService.deleteNotification(notification.id);
      
      setState(() {
        _notifications.removeWhere((n) => n.id == notification.id);
        _filterNotifications(_tabController.index);
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification deleted'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete notification: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _onNotificationTap(NotificationItem notification) {
    // Mark as read when tapped
    if (!notification.isRead) {
      _markAsRead(notification);
    }
    
    // Navigate based on notification type
    switch (notification.type) {
      case NotificationType.transaction:
        // Navigate to transaction details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigating to transaction: ${notification.reference}')),
        );
        break;
      case NotificationType.security:
        // Navigate to security settings
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Navigating to security settings')),
        );
        break;
      case NotificationType.promotion:
        // Navigate to promotion details
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Viewing promotion: ${notification.title}')),
        );
        break;
      case NotificationType.system:
        // Just show the message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(notification.message)),
        );
        break;
    }
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Notifications',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You don\'t have any notifications in this category',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationsList() {
    if (_filteredNotifications.isEmpty) {
      return _buildEmptyState();
    }
    
    return ListView.separated(
      itemCount: _filteredNotifications.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final notification = _filteredNotifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }
  
  Widget _buildNotificationItem(NotificationItem notification) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _deleteNotification(notification);
      },
      child: InkWell(
        onTap: () => _onNotificationTap(notification),
        child: Container(
          color: notification.isRead ? null : Colors.blue.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationIcon(notification),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatTimestamp(notification.timestamp),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          color: Colors.grey[700],
                        ),
                      ),
                      if (notification.actionText != null) ...[
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () {
                            // Handle action tap
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Action: ${notification.actionText}')),
                            );
                          },
                          child: Text(
                            notification.actionText!,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildNotificationIcon(NotificationItem notification) {
    IconData iconData;
    Color backgroundColor;
    Color iconColor;
    
    switch (notification.type) {
      case NotificationType.transaction:
        iconData = Icons.swap_horiz;
        backgroundColor = Colors.blue.withOpacity(0.1);
        iconColor = Colors.blue;
        break;
      case NotificationType.security:
        iconData = Icons.security;
        backgroundColor = Colors.red.withOpacity(0.1);
        iconColor = Colors.red;
        break;
      case NotificationType.promotion:
        iconData = Icons.local_offer;
        backgroundColor = Colors.orange.withOpacity(0.1);
        iconColor = Colors.orange;
        break;
      case NotificationType.system:
        iconData = Icons.info;
        backgroundColor = Colors.green.withOpacity(0.1);
        iconColor = Colors.green;
        break;
    }
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 20,
      ),
    );
  }
  
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications${unreadCount > 0 ? ' ($unreadCount)' : ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: 'Mark all as read',
            onPressed: _notifications.isEmpty ? null : _markAllAsRead,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Clear all notifications',
            onPressed: _notifications.isEmpty ? null : _clearAllNotifications,
          ),
          const ImplementationBadge(
            isImplemented: true,
            implementationDate: 'Now',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _categories.map((category) => Tab(text: category)).toList(),
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.accent,
        ),
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
                          onPressed: _loadNotifications,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: List.generate(
                      _categories.length,
                      (index) => _buildNotificationsList(),
                    ),
                  ),
      ),
    );
  }
}