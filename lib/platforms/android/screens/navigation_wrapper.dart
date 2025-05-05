import 'package:flutter/material.dart';
import '../../../providers/auth_provider.dart';
import '../../../screens/navigation_content_wrapper.dart';
import 'package:provider/provider.dart';

class AndroidNavigationWrapper extends StatefulWidget {
  const AndroidNavigationWrapper({super.key});

  @override
  State<AndroidNavigationWrapper> createState() => _AndroidNavigationWrapperState();
}

class _AndroidNavigationWrapperState extends State<AndroidNavigationWrapper> {
  int _selectedIndex = 0;
  final List<String> _pageTitles = ['Dashboard', 'Transfers', 'Activity', 'Profile'];

  Widget _getPage(int index) {
    return NavigationContentWrapper(
      title: _pageTitles[index],
      selectedIndex: _selectedIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        centerTitle: false,
        elevation: 0,
        actions: [
          if (_selectedIndex == 3)
            Consumer<AuthProvider>(
              builder: (context, authProvider, _) {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    authProvider.signOut();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                );
              },
            ),
        ],
      ),
      body: _getPage(_selectedIndex),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_outlined),
            selectedIcon: Icon(Icons.swap_horiz),
            label: 'Transfers',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Activity',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1 
        ? FloatingActionButton(
            onPressed: () {
              // Start new transfer
            },
            child: const Icon(Icons.add),
          )
        : null,
    );
  }
}
