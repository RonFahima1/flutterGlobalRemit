// Helper methods for the Dashboard screen
  
  // Format date for UI display
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateOnly = DateTime(date.year, date.month, date.day);
    
    if (dateOnly == today) {
      return 'Today';
    } else if (dateOnly == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMM d').format(date);
    }
  }
  
  // Get icon for transfer method
  IconData _getTransferIcon(String transferMethod) {
    switch (transferMethod) {
      case 'Bank Transfer':
        return Icons.account_balance;
      case 'Mobile Money':
        return Icons.phone_android;
      case 'Cash Pickup':
        return Icons.money;
      case 'International Wire':
        return Icons.public;
      case 'QR Code':
        return Icons.qr_code;
      default:
        return Icons.send;
    }
  }
  
  // Get color for transfer method icon
  Color _getTransferIconColor(String transferMethod) {
    switch (transferMethod) {
      case 'Bank Transfer':
        return Colors.blue[700]!;
      case 'Mobile Money':
        return Colors.green[700]!;
      case 'Cash Pickup':
        return Colors.amber[700]!;
      case 'International Wire':
        return Colors.purple[700]!;
      case 'QR Code':
        return Colors.teal[700]!;
      default:
        return Theme.of(context).primaryColor;
    }
  }
  
  // Get initials from name
  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
  
  // Get avatar color based on name
  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue[700]!,
      Colors.green[700]!,
      Colors.orange[700]!,
      Colors.purple[700]!,
      Colors.red[700]!,
      Colors.teal[700]!,
    ];
    
    int hashCode = name.hashCode;
    if (hashCode < 0) hashCode = -hashCode;
    return colors[hashCode % colors.length];
  }