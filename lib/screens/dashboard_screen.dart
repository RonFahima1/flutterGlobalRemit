import 'package:flutter/material.dart';
import '../models/beneficiary.dart';
import '../models/transfer.dart';
import '../services/transfer_service.dart';
import '../utils/progress_tracker.dart';
import '../widgets/implementation_progress_badge.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _isLoading = false;
  List<Transfer> _recentTransfers = [];
  List<Beneficiary> _topBeneficiaries = [];
  
  // Screen implementation information
  final int _screenNumber = 7;
  final String _screenName = 'Dashboard/Home Screen';
  bool _showProgress = false;
  
  final TransferService _transferService = TransferService();
  
  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }
  
  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Load recent transfers
      final transfers = await _transferService.getTransferHistory();
      
      // Load beneficiaries
      final beneficiaries = await _transferService.getBeneficiaries();
      
      setState(() {
        _recentTransfers = transfers.take(3).toList();
        
        // Sort by favorite status and then by most recent
        _topBeneficiaries = beneficiaries
          ..sort((a, b) {
            if (a.isFavorite && !b.isFavorite) return -1;
            if (!a.isFavorite && b.isFavorite) return 1;
            return b.createdAt.compareTo(a.createdAt);
          });
        
        _topBeneficiaries = _topBeneficiaries.take(4).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // In a real app, show an error dialog or snackbar
      print('Error loading dashboard data: $e');
    }
  }
  
  void _toggleProgressDisplay() {
    setState(() {
      _showProgress = !_showProgress;
    });
  }
  
  void _navigateToTransfer() {
    Navigator.of(context).pushNamed('/transfer-money');
  }
  
  void _navigateToManageBeneficiaries() {
    Navigator.of(context).pushNamed('/beneficiaries');
  }
  
  void _navigateToTransferHistory() {
    Navigator.of(context).pushNamed('/transfer-history');
  }
  
  void _navigateToCards() {
    Navigator.of(context).pushNamed('/cards');
  }
  
  @override
  Widget build(BuildContext context) {
    // Get the phase name for this screen
    final phaseName = AppProgressTracker.getPhaseForScreen(_screenNumber) ?? 'Unknown';
    
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Global Remit'),
            Text(
              'Screen ${_screenNumber}/41',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        actions: [
          // Progress button
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Show Implementation Progress',
            onPressed: _toggleProgressDisplay,
          ),
          // Notifications button
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadDashboardData,
          child: Column(
            children: [
              // Implementation progress tracking information
              if (_showProgress)
                _buildProgressTracker(phaseName),
              
              // Main dashboard content
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Implementation progress overview
                            const ImplementationProgressOverview(compact: true),
                            
                            const SizedBox(height: 24),
                            
                            // Welcome message
                            const Text(
                              'Welcome Back, User!',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            // Quick actions
                            _buildQuickActions(),
                            
                            const SizedBox(height: 24),
                            
                            // Recent transfers
                            _buildRecentTransfers(),
                            
                            const SizedBox(height: 24),
                            
                            // Top beneficiaries
                            _buildTopBeneficiaries(),
                            
                            const SizedBox(height: 24),
                            
                            // Implementation progress details
                            _buildImplementationProgress(),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF0066CC),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Color(0xFF0066CC),
                    size: 36,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'User Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'user@example.com',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(
            icon: Icons.home_outlined,
            title: 'Home',
            onTap: () {
              Navigator.of(context).pop();
            },
            completed: true,
          ),
          _buildDrawerItem(
            icon: Icons.account_balance_outlined,
            title: 'Account Overview',
            onTap: () {},
            completed: true,
          ),
          _buildDrawerItem(
            icon: Icons.credit_card_outlined,
            title: 'Cards',
            onTap: _navigateToCards,
            completed: true,
          ),
          _buildDrawerItem(
            icon: Icons.swap_horiz_outlined,
            title: 'Transfers',
            onTap: _navigateToTransfer,
            inProgress: true,
          ),
          _buildDrawerItem(
            icon: Icons.history_outlined,
            title: 'Transaction History',
            onTap: _navigateToTransferHistory,
            completed: true,
          ),
          _buildDrawerItem(
            icon: Icons.people_outline,
            title: 'Beneficiaries',
            onTap: _navigateToManageBeneficiaries,
            pending: true,
          ),
          _buildDrawerItem(
            icon: Icons.attach_money_outlined,
            title: 'Deposit & Withdrawal',
            onTap: () {},
            pending: true,
          ),
          _buildDrawerItem(
            icon: Icons.person_outline,
            title: 'Profile & KYC',
            onTap: () {},
            pending: true,
          ),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {},
            pending: true,
          ),
          _buildDrawerItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
            pending: true,
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {},
          ),
        ],
      ),
    );
  }
  
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool completed = false,
    bool inProgress = false,
    bool pending = false,
  }) {
    Widget? trailing;
    
    if (completed) {
      trailing = const Icon(Icons.check_circle, color: Colors.green, size: 16);
    } else if (inProgress) {
      trailing = const Icon(Icons.pending, color: Color(0xFFFFB800), size: 16);
    } else if (pending) {
      trailing = const Icon(Icons.circle_outlined, color: Colors.grey, size: 16);
    }
    
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: trailing,
      onTap: onTap,
    );
  }
  
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              title: 'Send Money',
              icon: Icons.send,
              color: const Color(0xFF0066CC),
              onTap: _navigateToTransfer,
              status: 'IN PROGRESS',
            ),
            _buildActionCard(
              title: 'Add Beneficiary',
              icon: Icons.person_add,
              color: const Color(0xFFFFB800),
              onTap: _navigateToManageBeneficiaries,
              status: 'PENDING',
            ),
            _buildActionCard(
              title: 'Cards',
              icon: Icons.credit_card,
              color: Colors.green,
              onTap: _navigateToCards,
              status: 'COMPLETED',
            ),
            _buildActionCard(
              title: 'Transaction History',
              icon: Icons.history,
              color: Colors.purple,
              onTap: _navigateToTransferHistory,
              status: 'COMPLETED',
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    String? status,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: color,
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            if (status != null)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: status == 'COMPLETED' 
                        ? Colors.green 
                        : status == 'IN PROGRESS' 
                            ? const Color(0xFFFFB800) 
                            : Colors.grey,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildRecentTransfers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transfers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: _navigateToTransferHistory,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _recentTransfers.isEmpty
            ? _buildEmptyState(
                icon: Icons.history,
                message: 'No recent transfers',
              )
            : Column(
                children: _recentTransfers.map((transfer) {
                  // Get the status color
                  Color statusColor;
                  switch (transfer.status) {
                    case TransferStatus.completed:
                      statusColor = Colors.green;
                      break;
                    case TransferStatus.processing:
                      statusColor = const Color(0xFFFFB800);
                      break;
                    case TransferStatus.failed:
                      statusColor = Colors.red;
                      break;
                    default:
                      statusColor = Colors.grey;
                  }
                  
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Status indicator
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Icon(
                              transfer.status == TransferStatus.completed
                                  ? Icons.check_circle
                                  : transfer.status == TransferStatus.processing
                                      ? Icons.pending
                                      : Icons.error,
                              color: statusColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          
                          // Transfer details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ref: ${transfer.referenceNumber}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${transfer.fromCurrency} to ${transfer.toCurrency}',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  transfer.statusText,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Amount
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${transfer.fromCurrency} ${transfer.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${transfer.toCurrency} ${transfer.convertedAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }
  
  Widget _buildTopBeneficiaries() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Your Beneficiaries',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: _navigateToManageBeneficiaries,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Manage'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _topBeneficiaries.isEmpty
            ? _buildEmptyState(
                icon: Icons.people,
                message: 'No beneficiaries',
              )
            : SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _topBeneficiaries.length + 1, // +1 for add button
                  itemBuilder: (context, index) {
                    if (index == _topBeneficiaries.length) {
                      // Add button
                      return _buildAddBeneficiaryButton();
                    }
                    
                    // Beneficiary card
                    final beneficiary = _topBeneficiaries[index];
                    return _buildBeneficiaryCard(beneficiary);
                  },
                ),
              ),
      ],
    );
  }
  
  Widget _buildBeneficiaryCard(Beneficiary beneficiary) {
    // Generate avatar color based on beneficiary id
    final int hashCode = beneficiary.id.hashCode;
    final List<Color> colors = [
      const Color(0xFF4ECDC4),
      const Color(0xFFFF6B6B),
      const Color(0xFFFFD166),
      const Color(0xFF06D6A0),
      const Color(0xFF118AB2),
      const Color(0xFF073B4C),
      const Color(0xFF7678ED),
      const Color(0xFFF08080),
      const Color(0xFF8675A9),
      const Color(0xFF3AAFA9),
    ];
    final Color avatarColor = colors[hashCode.abs() % colors.length];
    
    // Generate initials from name
    final nameParts = beneficiary.name.split(' ');
    String initials;
    if (nameParts.length > 1) {
      initials = '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    } else {
      initials = nameParts[0].substring(0, 1).toUpperCase();
    }
    
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: () => _navigateToTransfer(),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            // Avatar with initials
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: avatarColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Name
            Text(
              beneficiary.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            
            // Bank/Country
            Text(
              beneficiary.bankName ?? beneficiary.country ?? '',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            
            // Favorite indicator
            if (beneficiary.isFavorite)
              Icon(
                Icons.star,
                color: Colors.amber.shade600,
                size: 14,
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAddBeneficiaryButton() {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: _navigateToManageBeneficiaries,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.add,
                color: Color(0xFF0066CC),
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Add New',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Color(0xFF0066CC),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState({
    required IconData icon,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildImplementationProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Implementation Progress',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        const ImplementationProgressOverview(),
      ],
    );
  }
  
  Widget _buildProgressTracker(String phaseName) {
    return Container(
      color: const Color(0xFFF0F7FF),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppProgressTracker.getScreenStatusIcon(_screenNumber),
              const SizedBox(width: 8),
              Text(
                'Screen #$_screenNumber: $_screenName',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppProgressTracker.getScreenStatusColor(_screenNumber),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  AppProgressTracker.getScreenStatusText(_screenNumber),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Phase: $phaseName (${AppProgressTracker.getPhaseProgress(phaseName)} completed)',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ProgressIndicator(
                  value: AppProgressTracker.getPhaseCompletionPercentage(phaseName),
                  color: const Color(0xFF0066CC),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(AppProgressTracker.getPhaseCompletionPercentage(phaseName) * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Overall App Progress: ${AppProgressTracker.completedScreens}/${AppProgressTracker.totalScreens} screens (${(AppProgressTracker.getOverallCompletionPercentage() * 100).toInt()}%)',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          ProgressIndicator(
            value: AppProgressTracker.getOverallCompletionPercentage(),
            color: const Color(0xFFFFB800),
          ),
        ],
      ),
    );
  }
}

/// A custom progress indicator widget
class ProgressIndicator extends StatelessWidget {
  final double value;
  final Color color;
  
  const ProgressIndicator({
    Key? key,
    required this.value,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        widthFactor: value.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}