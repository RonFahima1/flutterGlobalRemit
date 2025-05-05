import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/platform_utils.dart';
import '../../theme/theme_constants.dart';
import '../../theme/colors.dart';

class BaseProfileScreen extends StatelessWidget {
  const BaseProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: GlobalRemitColors.primaryBackground(context),
                  boxShadow: [
                    BoxShadow(
                      color: GlobalRemitColors.gray6(context).withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: GlobalRemitColors.primaryBlue(context)
                          .withOpacity(0.1),
                      backgroundImage: NetworkImage(user?.avatarUrl ?? ''),
                    ),
                    const SizedBox(height: 16),
                    // Name and email
                    Text(
                      user?.name ?? 'User',
                      style: GlobalRemitTypography.title2(context),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: GlobalRemitTypography.body(context)
                          .copyWith(color: GlobalRemitColors.gray2(context)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Settings list
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildSettingsItem(
                    context,
                    icon: Icons.person,
                    title: 'Edit Profile',
                    onTap: () {
                      // TODO: Navigate to edit profile
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.lock,
                    title: 'Security',
                    onTap: () {
                      // TODO: Navigate to security settings
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.payment,
                    title: 'Payment Methods',
                    onTap: () {
                      // TODO: Navigate to payment methods
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.notifications,
                    title: 'Notifications',
                    onTap: () {
                      // TODO: Navigate to notifications
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.language,
                    title: 'Language',
                    onTap: () {
                      // TODO: Navigate to language settings
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    icon: Icons.logout,
                    title: 'Sign Out',
                    onTap: () {
                      context.read<AuthProvider>().signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: GlobalRemitColors.gray2(context),
      ),
      title: Text(
        title,
        style: GlobalRemitTypography.body(context),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: GlobalRemitColors.gray2(context),
      ),
      onTap: onTap,
    );
  }
}
