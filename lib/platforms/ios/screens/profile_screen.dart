import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../base_profile_screen.dart';
import '../../../utils/platform_utils.dart';
import '../../../theme/theme_constants.dart';
import '../../../theme/colors.dart';

class IOSProfileScreen extends StatelessWidget {
  const IOSProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Profile',
          style: GlobalRemitTypography.title3(context)
              .copyWith(color: GlobalRemitColors.gray1(context)),
        ),
        backgroundColor: GlobalRemitColors.primaryBackground(context),
        border: const Border(),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: GlobalRemitColors.primaryBackground(context),
                ),
                child: Column(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: GlobalRemitColors.primaryBlue(context)
                          .withOpacity(0.1),
                      backgroundImage: NetworkImage(context.watch<AuthProvider>().user?.avatarUrl ?? ''),
                    ),
                    const SizedBox(height: 16),
                    // Name and email
                    Text(
                      context.watch<AuthProvider>().user?.name ?? 'User',
                      style: GlobalRemitTypography.title2(context),
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
              const SizedBox(height: 16),
              // Settings list
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.person,
                    title: 'Edit Profile',
                    onTap: () {
                      // TODO: Navigate to edit profile
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.lock,
                    title: 'Security',
                    onTap: () {
                      // TODO: Navigate to security settings
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.creditcard,
                    title: 'Payment Methods',
                    onTap: () {
                      // TODO: Navigate to payment methods
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.bell,
                    title: 'Notifications',
                    onTap: () {
                      // TODO: Navigate to notifications
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.globe,
                    title: 'Language',
                    onTap: () {
                      // TODO: Navigate to language settings
                    },
                  ),
                  _buildSettingsItem(
                    context,
                    icon: CupertinoIcons.arrow_right_circle_fill,
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
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: GlobalRemitColors.separator(context),
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: GlobalRemitColors.gray2(context),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: GlobalRemitTypography.body(context),
            ),
            const Spacer(),
            Icon(
              CupertinoIcons.chevron_right,
              color: GlobalRemitColors.gray2(context),
            ),
          ],
        ),
      ),
    );
  }
}
