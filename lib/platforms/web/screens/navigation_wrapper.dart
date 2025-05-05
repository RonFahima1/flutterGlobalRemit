import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../screens/dashboard_screen.dart';
import '../../../screens/transfer_money_screen.dart';
import '../../../screens/international_remittance_screen.dart';
import '../../../screens/transaction_screen.dart';
import '../../../screens/profile_screen.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/colors.dart';
import '../../../providers/theme_provider.dart';
import '../../../providers/auth_provider.dart';

class WebNavigationWrapper extends StatefulWidget {
  const WebNavigationWrapper({super.key});

  @override
  State<WebNavigationWrapper> createState() => _WebNavigationWrapperState();
}

class _WebNavigationWrapperState extends State<WebNavigationWrapper> {
  int _selectedIndex = 0;
  final List<String> _pageNames = ['Dashboard', 'Transfers', 'International', 'Activity', 'Profile'];
  final List<IconData> _unselectedIcons = [
    Icons.dashboard_outlined,
    Icons.send_outlined,
    Icons.public_outlined,
    Icons.receipt_long_outlined,
    Icons.person_outline,
  ];
  final List<IconData> _selectedIcons = [
    Icons.dashboard,
    Icons.send,
    Icons.public,
    Icons.receipt_long,
    Icons.person,
  ];

  // Get the appropriate page based on the selected index
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const TransferMoneyScreen();
      case 2:
        return const InternationalRemittanceScreen();
      case 3:
        return const TransactionScreen(); // Activity/history screen
      case 4:
        return const ProfileScreen();
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    // Get the actual boolean value
    final bool isDark = themeProvider.isDarkMode;
    
    // Resolve background colors based on brightness
    final primaryBackgroundColor = isDark 
        ? GlobalRemitColors.primaryBackgroundDark 
        : GlobalRemitColors.primaryBackgroundLight;
        
    final secondaryBackgroundColor = isDark
        ? GlobalRemitColors.secondaryBackgroundDark
        : GlobalRemitColors.secondaryBackgroundLight;
    
    final bool isExtended = MediaQuery.of(context).size.width > 1200;
    
    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar Navigation
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: primaryBackgroundColor,
            minWidth: 85,
            extended: isExtended,
            labelType: isExtended ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
            destinations: List.generate(_pageNames.length, (index) {
              return NavigationRailDestination(
                icon: Icon(
                  _unselectedIcons[index], 
                  color: _selectedIndex == index ? theme.colorScheme.primary : null
                ),
                selectedIcon: Icon(
                  _selectedIcons[index], 
                  color: theme.colorScheme.primary
                ),
                label: Text(_pageNames[index]),
              );
            }),
          ),
          
          // Vertical Divider
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: isDark ? Colors.white10 : Colors.black12,
          ),
          
          // Main Content Area
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top App Bar
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: secondaryBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 1,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Global Remit',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Text(
                            _pageNames[_selectedIndex],
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Dark Mode Toggle
                          IconButton(
                            icon: Icon(
                              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                            onPressed: () {
                              themeProvider.toggleTheme();
                            },
                          ),
                          const SizedBox(width: 8),
                          // Notifications
                          IconButton(
                            icon: const Icon(Icons.notifications_outlined),
                            tooltip: 'Notifications',
                            onPressed: () {
                              Navigator.of(context).pushNamed('/notifications');
                            },
                          ),
                          const SizedBox(width: 8),
                          // User Profile Menu - Simplified version
                          PopupMenuButton(
                            offset: const Offset(0, 40),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: theme.colorScheme.primary,
                                  child: const Icon(Icons.person, color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'User',
                                  style: theme.textTheme.bodyMedium,
                                ),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'profile',
                                child: Row(
                                  children: [
                                    Icon(Icons.person_outline),
                                    SizedBox(width: 8),
                                    Text('My Profile'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'settings',
                                child: Row(
                                  children: [
                                    Icon(Icons.settings_outlined),
                                    SizedBox(width: 8),
                                    Text('Settings'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'help',
                                child: Row(
                                  children: [
                                    Icon(Icons.help_outline),
                                    SizedBox(width: 8),
                                    Text('Help Center'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'logout',
                                child: Row(
                                  children: [
                                    Icon(Icons.logout),
                                    SizedBox(width: 8),
                                    Text('Log Out'),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) {
                              switch (value) {
                                case 'profile':
                                  Navigator.of(context).pushNamed('/profile');
                                  break;
                                case 'settings':
                                  Navigator.of(context).pushNamed('/settings');
                                  break;
                                case 'help':
                                  Navigator.of(context).pushNamed('/help-center');
                                  break;
                                case 'logout':
                                  final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                  authProvider.signOut();
                                  Navigator.of(context).pushReplacementNamed('/login');
                                  break;
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Page Content
                Expanded(
                  child: Container(
                    color: secondaryBackgroundColor,
                    child: _getPage(_selectedIndex),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
