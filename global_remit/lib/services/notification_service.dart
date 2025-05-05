import '../models/notification_item.dart';

class NotificationService {
  // In a real app, this would use a database or API for persistence
  List<NotificationItem> _notifications = [];
  
  NotificationService() {
    // Initialize with some mock data
    _notifications = _generateMockNotifications();
  }
  
  Future<List<NotificationItem>> getNotifications() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // In a real app, this would fetch notifications from a database or API
    return List.from(_notifications);
  }
  
  Future<void> markAsRead(String notificationId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real app, this would update the notification in a database or API
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }
  
  Future<void> markAllAsRead() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In a real app, this would update all notifications in a database or API
    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
  }
  
  Future<void> deleteNotification(String notificationId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real app, this would delete the notification from a database or API
    _notifications.removeWhere((n) => n.id == notificationId);
  }
  
  Future<void> clearAllNotifications() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In a real app, this would delete all notifications from a database or API
    _notifications = [];
  }
  
  Future<void> addNotification(NotificationItem notification) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In a real app, this would add the notification to a database or API
    _notifications.add(notification);
  }
  
  List<NotificationItem> _generateMockNotifications() {
    final now = DateTime.now();
    
    return [
      NotificationItem(
        id: '1',
        title: 'Money Received',
        message: 'You have received \$500.00 from John Doe',
        type: NotificationType.transaction,
        timestamp: now.subtract(const Duration(minutes: 5)),
        reference: 'TX123456789',
        actionText: 'View Transaction',
      ),
      NotificationItem(
        id: '2',
        title: 'Security Alert',
        message: 'Your account was accessed from a new device. If this was not you, please contact support.',
        type: NotificationType.security,
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: true,
        actionText: 'Review Activity',
      ),
      NotificationItem(
        id: '3',
        title: 'Special Offer',
        message: 'Send money to Mexico with 0% fees for the next 48 hours!',
        type: NotificationType.promotion,
        timestamp: now.subtract(const Duration(days: 1)),
        actionText: 'Send Now',
        imageUrl: 'assets/images/promo_mexico.png',
      ),
      NotificationItem(
        id: '4',
        title: 'Transfer Complete',
        message: 'Your transfer of \$200.00 to Maria Garcia has been completed.',
        type: NotificationType.transaction,
        timestamp: now.subtract(const Duration(days: 2)),
        reference: 'TX987654321',
        actionText: 'View Receipt',
      ),
      NotificationItem(
        id: '5',
        title: 'New Feature',
        message: 'You can now send money to friends using just their phone number. Try it today!',
        type: NotificationType.system,
        timestamp: now.subtract(const Duration(days: 3)),
        isRead: true,
        actionText: 'Learn More',
      ),
      NotificationItem(
        id: '6',
        title: 'Account Update Required',
        message: 'Please update your billing information to ensure uninterrupted service.',
        type: NotificationType.security,
        timestamp: now.subtract(const Duration(days: 4)),
        actionText: 'Update Now',
      ),
      NotificationItem(
        id: '7',
        title: 'Weekend Promo',
        message: 'Get 50% off transfer fees this weekend only!',
        type: NotificationType.promotion,
        timestamp: now.subtract(const Duration(days: 5)),
        isRead: true,
        actionText: 'Learn More',
        imageUrl: 'assets/images/weekend_promo.png',
      ),
      NotificationItem(
        id: '8',
        title: 'Card Activated',
        message: 'Your virtual card has been successfully activated and is ready to use.',
        type: NotificationType.system,
        timestamp: now.subtract(const Duration(days: 6)),
        actionText: 'View Card',
      ),
      NotificationItem(
        id: '9',
        title: 'New Login',
        message: 'We detected a new login to your account from New York, USA. If this wasn\'t you, please secure your account immediately.',
        type: NotificationType.security,
        timestamp: now.subtract(const Duration(days: 7)),
        isRead: false,
        actionText: 'Secure Account',
      ),
      NotificationItem(
        id: '10',
        title: 'Scheduled Transfer',
        message: 'Your scheduled transfer of \$350.00 to James Smith will process tomorrow.',
        type: NotificationType.transaction,
        timestamp: now.subtract(const Duration(days: 8)),
        isRead: true,
        reference: 'TX567891234',
        actionText: 'Review Transfer',
      ),
    ];
  }
}