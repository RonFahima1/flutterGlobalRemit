import 'package:flutter/material.dart';
import '../../base_profile_screen.dart';
import '../../../utils/platform_utils.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/colors.dart';

class WebProfileScreen extends StatelessWidget {
  const WebProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: GlobalRemitTypography.title3(context)
              .copyWith(color: GlobalRemitColors.gray1(context)),
        ),
        backgroundColor: GlobalRemitColors.primaryBackground(context),
        elevation: 1,
      ),
      body: Row(
        children: [
          // Left sidebar
          NavigationRail(
            selectedIndex: 0,
            labelType: NavigationRailLabelType.all,
            backgroundColor: GlobalRemitColors.primaryBackground(context),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.person),
                selectedIcon: Icon(Icons.person),
                label: Text('Profile'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.security),
                selectedIcon: Icon(Icons.security),
                label: Text('Security'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.payment),
                selectedIcon: Icon(Icons.payment),
                label: Text('Payment'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.notifications),
                selectedIcon: Icon(Icons.notifications),
                label: Text('Notifications'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.language),
                selectedIcon: Icon(Icons.language),
                label: Text('Language'),
              ),
            ],
          ),
          // Main content area
          Expanded(
            child: Container(
              color: GlobalRemitColors.secondaryBackground(context),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile header
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: GlobalRemitColors.primaryBackground(context),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: GlobalRemitColors.gray6(context)
                                  .withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Avatar
                            Center(
                              child: CircleAvatar(
                                radius: 60,
                                backgroundColor: GlobalRemitColors.primaryBlue(context)
                                    .withOpacity(0.1),
                                backgroundImage: NetworkImage(context.watch<AuthProvider>().user?.avatarUrl ?? ''),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Name and email
                            Text(
                              context.watch<AuthProvider>().user?.name ?? 'User',
                              style: GlobalRemitTypography.title1(context),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.watch<AuthProvider>().user?.email ?? '',
                              style: GlobalRemitTypography.body(context)
                                  .copyWith(color: GlobalRemitColors.gray2(context)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // TODO: Navigate to edit profile
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Edit Profile',
                                style: GlobalRemitTypography.body(context)
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                context.read<AuthProvider>().signOut();
                                Navigator.pushReplacementNamed(context, '/login');
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Sign Out',
                                style: GlobalRemitTypography.body(context)
                                    .copyWith(color: GlobalRemitColors.errorRed(context)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
