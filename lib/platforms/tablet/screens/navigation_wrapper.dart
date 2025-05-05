import 'package:flutter/material.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/theme_provider.dart';
import '../../../screens/base_navigation_wrapper.dart';
import 'package:provider/provider.dart';

class TabletNavigationWrapper extends StatefulWidget {
  const TabletNavigationWrapper({super.key});

  @override
  State<TabletNavigationWrapper> createState() => _TabletNavigationWrapperState();
}

class _TabletNavigationWrapperState extends State<TabletNavigationWrapper> {
  int _selectedIndex = 0;
  final List<String> _pageTitles = ['Dashboard', 'Transfers', 'Activity', 'Profile'];
  final List<IconData> _pageIcons = [
    Icons.dashboard_outlined,
    Icons.swap_horiz_outlined,
    Icons.bar_chart_outlined,
    Icons.person_outline,
  ];
  final List<IconData> _pageActiveIcons = [
    Icons.dashboard,
    Icons.swap_horiz,
    Icons.bar_chart,
    Icons.person,
  ];

  Widget _getPage(int index) {
    return BaseNavigationWrapper(pageTitle: _pageTitles[index]);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode(context);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    
    // For very large tablets, we can use an even wider sidebar
    final sidebarWidth = size.width > 1100 ? 280.0 : 220.0;
    
    return Scaffold(
      body: Row(
        children: [
          // Left sidebar (master view)
          Container(
            width: sidebarWidth,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 2,
                  offset: const Offset(1, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // App title/logo
                Container(
                  padding: const EdgeInsets.all(16),
                  height: 80,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.attach_money,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Global Remit',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Navigation list
                Expanded(
                  child: ListView.builder(
                    itemCount: _pageTitles.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final isSelected = index == _selectedIndex;
                      
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? theme.colorScheme.primary.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListTile(
                          leading: Icon(
                            isSelected ? _pageActiveIcons[index] : _pageIcons[index],
                            color: isSelected 
                                ? theme.colorScheme.primary
                                : isDark ? Colors.white70 : Colors.black54,
                          ),
                          title: Text(
                            _pageTitles[index],
                            style: TextStyle(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : isDark ? Colors.white : Colors.black87,
                              fontWeight: isSelected 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              _selectedIndex = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                
                // User profile section
                Consumer<AuthProvider>(
                  builder: (context, authProvider, _) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: isDark ? Colors.white10 : Colors.black12,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: authProvider.user?.avatarUrl != null 
                                ? NetworkImage(authProvider.user!.avatarUrl!) as ImageProvider
                                : const AssetImage('assets/images/avatar_placeholder.png'),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authProvider.user?.name ?? 'User',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  authProvider.user?.email ?? 'user@example.com',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: isDark ? Colors.white70 : Colors.black54,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout),
                            onPressed: () {
                              authProvider.signOut();
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Main content area (detail view)
          Expanded(
            child: _getPage(_selectedIndex),
          ),
        ],
      ),
    );
  }
}