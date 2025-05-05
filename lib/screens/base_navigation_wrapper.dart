import 'package:flutter/material.dart';

class BaseNavigationWrapper extends StatelessWidget {
  final String title;
  final int selectedIndex;
  final Widget? appBarLeading;
  final List<Widget>? appBarActions;
  final ValueChanged<int>? onTabSelected;
  final Widget? child;

  const BaseNavigationWrapper({
    super.key, 
    this.title = 'Dashboard',
    this.selectedIndex = 0,
    this.appBarLeading,
    this.appBarActions,
    this.onTabSelected,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: appBarLeading,
        title: Text(title),
        actions: appBarActions,
        elevation: 0,
      ),
      body: child ?? Builder(
        builder: (context) {
          // Render different content based on the title
          switch (title) {
            case 'Home':
            case 'Dashboard':
              return _buildDashboard(context);
            case 'Transfers':
              return _buildTransfers(context);
            case 'Activity':
              return _buildActivity(context);
            case 'Profile':
              return _buildProfile(context);
            default:
              return _buildDashboard(context);
          }
        },
      ),
    );
  }

  Widget _buildDashboard(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Text(
            'Welcome back, John',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Here\'s your financial summary',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          
          // Balance cards section
          isSmallScreen
              ? Column(
                  children: [
                    _buildBalanceCard(
                      context,
                      'Total Balance',
                      5280.42,
                      'USD',
                      [
                        theme.colorScheme.primary,
                        theme.colorScheme.primary.withOpacity(0.7),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildBalanceCard(
                      context,
                      'Sent This Month',
                      1250.00,
                      'USD',
                      [
                        theme.colorScheme.secondary,
                        theme.colorScheme.secondary.withOpacity(0.7),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildBalanceCard(
                        context,
                        'Total Balance',
                        5280.42,
                        'USD',
                        [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withOpacity(0.7),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildBalanceCard(
                        context,
                        'Sent This Month',
                        1250.00,
                        'USD',
                        [
                          theme.colorScheme.secondary,
                          theme.colorScheme.secondary.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ],
                ),
          
          const SizedBox(height: 24),
          
          // Summary cards
          Text(
            'Account Summary',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          isSmallScreen
              ? Column(
                  children: [
                    _buildSummaryCard(
                      context,
                      'Transfers',
                      '12',
                      'Last 30 days',
                      Icons.swap_horiz,
                      theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryCard(
                      context,
                      'Recipients',
                      '8',
                      'Active',
                      Icons.people,
                      theme.colorScheme.tertiary,
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryCard(
                      context,
                      'Saved',
                      '\$120.50',
                      'vs. bank rates',
                      Icons.savings,
                      theme.colorScheme.secondary,
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        context,
                        'Transfers',
                        '12',
                        'Last 30 days',
                        Icons.swap_horiz,
                        theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        context,
                        'Recipients',
                        '8',
                        'Active',
                        Icons.people,
                        theme.colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSummaryCard(
                        context,
                        'Saved',
                        '\$120.50',
                        'vs. bank rates',
                        Icons.savings,
                        theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
          
          const SizedBox(height: 24),
          
          // Recent transactions
          Text(
            'Recent Transactions',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          _buildRecentTransactionsList(context),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(
    BuildContext context,
    String title,
    double amount,
    String currencyCode,
    List<Color> gradientColors,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\$${amount.toStringAsFixed(2)} $currencyCode',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                size: 14,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsList(BuildContext context) {
    // Placeholder for recent transactions
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 5,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Theme.of(context).dividerColor,
        ),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_outward,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            title: Text('Transfer to Maria'),
            subtitle: Text('May ${15 - index}, 2023'),
            trailing: Text(
              '-\$${(100 + index * 25).toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransfers(BuildContext context) {
    return const Center(
      child: Text('Transfers Screen - Coming Soon'),
    );
  }

  Widget _buildActivity(BuildContext context) {
    return const Center(
      child: Text('Activity Screen - Coming Soon'),
    );
  }

  Widget _buildProfile(BuildContext context) {
    return const Center(
      child: Text('Profile Screen - Coming Soon'),
    );
  }
}
