import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../screens/base_navigation_wrapper.dart';
import '../../../utils/platform_utils.dart';
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
  final List<String> _pageNames = ['Home', 'Send', 'Receive', 'Profile'];

  Widget _getPage(int index) {
    // Using BaseNavigationWrapper to display the page content
    return BaseNavigationWrapper(pageTitle: _pageNames[index]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
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
            backgroundColor: GlobalRemitColors.primaryBackground(context),
            minWidth: 85,
            extended: MediaQuery.of(context).size.width > 1200,
            labelType: NavigationRailLabelType.none,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined, color: _selectedIndex == 0 ? theme.colorScheme.primary : null),
                selectedIcon: Icon(Icons.home, color: theme.colorScheme.primary),
                label: const Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.send_outlined, color: _selectedIndex == 1 ? theme.colorScheme.primary : null),
                selectedIcon: Icon(Icons.send, color: theme.colorScheme.primary),
                label: const Text('Send'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.receipt_long_outlined, color: _selectedIndex == 2 ? theme.colorScheme.primary : null),
                selectedIcon: Icon(Icons.receipt_long, color: theme.colorScheme.primary),
                label: const Text('Receive'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline, color: _selectedIndex == 3 ? theme.colorScheme.primary : null),
                selectedIcon: Icon(Icons.person, color: theme.colorScheme.primary),
                label: const Text('Profile'),
              ),
            ],
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
                    color: GlobalRemitColors.secondaryBackground(context),
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
                      Text(
                        _pageNames[_selectedIndex],
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          // Dark Mode Toggle - Placeholder for now
                          IconButton(
                            icon: Icon(
                              isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                            onPressed: () {
                              // Toggle theme functionality would go here
                              // For now, this is just a placeholder
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
                              PopupMenuItem(
                                child: const Row(
                                  children: [
                                    Icon(Icons.settings_outlined),
                                    SizedBox(width: 8),
                                    Text('Settings'),
                                  ],
                                ),
                                onTap: () {
                                  // Navigate to settings
                                },
                              ),
                              PopupMenuItem(
                                child: const Row(
                                  children: [
                                    Icon(Icons.logout),
                                    SizedBox(width: 8),
                                    Text('Log Out'),
                                  ],
                                ),
                                onTap: () {
                                  // Sign out functionality
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Page Content
                Expanded(
                  child: Container(
                    color: GlobalRemitColors.secondaryBackground(context),
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
