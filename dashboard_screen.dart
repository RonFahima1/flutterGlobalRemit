import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:global_remit/components/cards/balance_card.dart';
import 'package:global_remit/components/cards/transaction_card.dart';
import 'package:global_remit/components/dashboard/quick_actions.dart';
import 'package:global_remit/components/navigation/ios_tab_bar.dart';

class DashboardScreen extends StatefulWidget {
  /// Callback to toggle theme mode
  final VoidCallback onThemeToggle;

  const DashboardScreen({
    Key? key,
    required this.onThemeToggle,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentTabIndex = 0;
  
  // Mock data for transactions
  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'id': 't1',
      'recipient': 'Maria Rodriguez',
      'amount': 250.00,
      'currency': 'USD',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
      'status': 'completed',
      'recipientImage': 'https://randomuser.me/api/portraits/women/44.jpg',
    },
    {
      'id': 't2',
      'recipient': 'John Smith',
      'amount': 500.00,
      'currency': 'EUR',
      'date': DateTime.now().subtract(const Duration(days: 1)),
      'status': 'processing',
      'recipientImage': 'https://randomuser.me/api/portraits/men/32.jpg',
    },
    {
      'id': 't3',
      'recipient': 'Sophia Chen',
      'amount': 150.00,
      'currency': 'GBP',
      'date': DateTime.now().subtract(const Duration(days: 3)),
      'status': 'completed',
      'recipientImage': 'https://randomuser.me/api/portraits/women/67.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Global Remit'),
        centerTitle: true,
        actions: [
          // Theme toggle button
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light
                  ? CupertinoIcons.moon
                  : CupertinoIcons.sun_max,
            ),
            onPressed: widget.onThemeToggle,
          ),
          // Profile button
          IconButton(
            icon: const Icon(CupertinoIcons.person_circle),
            onPressed: () {
              // Navigate to profile screen
            },
          ),
        ],
      ),
      body: _buildCurrentTabView(),
      bottomNavigationBar: IOSTabBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
          
          // Add haptic feedback
          switch (index) {
            case 0:
              HapticFeedback.lightImpact();
              break;
            default:
              HapticFeedback.selectionClick();
          }
        },
        items: const [
          IOSTabItem(
            icon: CupertinoIcons.home,
            activeIcon: CupertinoIcons.house_fill,
            label: 'Home',
          ),
          IOSTabItem(
            icon: CupertinoIcons.arrow_right_arrow_left,
            activeIcon: CupertinoIcons.arrow_right_arrow_left_circle_fill,
            label: 'Transfer',
          ),
          IOSTabItem(
            icon: CupertinoIcons.chart_bar,
            activeIcon: CupertinoIcons.chart_bar_fill,
            label: 'Activity',
            badgeCount: 3,
          ),
          IOSTabItem(
            icon: CupertinoIcons.person,
            activeIcon: CupertinoIcons.person_fill,
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentTabView() {
    switch (_currentTabIndex) {
      case 0:
        return _buildHomeTab();
      case 1:
        return _buildTransferTab();
      case 2:
        return _buildActivityTab();
      case 3:
        return _buildProfileTab();
      default:
        return _buildHomeTab();
    }
  }

  Widget _buildHomeTab() {
    return RefreshIndicator(
      onRefresh: () async {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: BalanceCard(
                balance: 1250.75,
                currency: 'USD',
                onTap: () {
                  // Navigate to balance details
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: QuickActions(
                onSendMoney: () {
                  // Navigate to send money flow
                  setState(() {
                    _currentTabIndex = 1; // Switch to transfer tab
                  });
                },
                onAddMoney: () {
                  // Navigate to add money flow
                },
                onScanQR: () {
                  // Open QR scanner
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      // Navigate to all transactions
                      setState(() {
                        _currentTabIndex = 2; // Switch to activity tab
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final transaction = _recentTransactions[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TransactionCard(
                    recipientName: transaction['recipient'],
                    amount: transaction['amount'],
                    currency: transaction['currency'],
                    date: transaction['date'],
                    status: transaction['status'],
                    recipientImageUrl: transaction['recipientImage'],
                    onTap: () {
                      // Navigate to transaction details
                    },
                  ),
                );
              },
              childCount: _recentTransactions.length,
            ),
          ),
          // Add some bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferTab() {
    // Placeholder for transfer tab
    return const Center(
      child: Text(
        'Transfer Money',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildActivityTab() {
    // Placeholder for activity tab
    return const Center(
      child: Text(
        'Activity & History',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget _buildProfileTab() {
    // Placeholder for profile tab
    return const Center(
      child: Text(
        'User Profile',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}