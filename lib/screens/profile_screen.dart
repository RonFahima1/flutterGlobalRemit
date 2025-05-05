import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Profile"),
        backgroundColor: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white,
        border: null,
      ),
      backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 24),
            // Avatar + user info
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: CupertinoColors.systemBlue.withOpacity(0.1),
                    backgroundImage: NetworkImage(authProvider.user?.avatarUrl ?? ''),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authProvider.user?.name ?? 'User',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authProvider.user?.email ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Account Section
            _CupertinoSettingsSection(
              header: "Account",
              tiles: [
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.lock_fill,
                  title: "Security",
                  onTap: () {
                    Navigator.pushNamed(context, '/security');
                  },
                ),
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.bell_fill,
                  title: "Notifications",
                  onTap: () {
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.globe,
                  title: "Language",
                  onTap: () {
                    // Handle language change
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Support Section
            _CupertinoSettingsSection(
              header: "Support",
              tiles: [
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.question_circle_fill,
                  title: "Help Center",
                  onTap: () {
                    Navigator.pushNamed(context, '/help-center');
                  },
                ),
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.doc_text_fill,
                  title: "Privacy Policy",
                  onTap: () {
                    Navigator.pushNamed(context, '/privacy-policy');
                  },
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Sign out button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoButton(
                color: CupertinoColors.destructiveRed,
                borderRadius: BorderRadius.circular(8),
                child: const Text("Sign Out"),
                onPressed: () {
                  authProvider.signOut();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _CupertinoSettingsSection extends StatelessWidget {
  final String header;
  final List<Widget> tiles;
  
  const _CupertinoSettingsSection({
    required this.header,
    required this.tiles,
  });
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            bottom: 8,
          ),
          child: Text(
            header.toUpperCase(),
            style: TextStyle(
              fontSize: 13,
              color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 1,
                  offset: const Offset(0, 1),
                ),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: List.generate(tiles.length, (i) {
              return Column(
                children: [
                  if (i != 0)
                    Divider(
                      height: 0,
                      indent: 54,
                      color: isDark ? const Color(0xFF38383A) : const Color(0xFFE5E5EA),
                      thickness: 0.5,
                    ),
                  tiles[i],
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _CupertinoSettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  
  const _CupertinoSettingsTile({
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: CupertinoColors.systemBlue, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? CupertinoColors.white : CupertinoColors.black,
                ),
              ),
            ),
            if (trailing != null)
              trailing!
            else
              Icon(
                CupertinoIcons.chevron_right,
                size: 16,
                color: isDark ? const Color(0xFF8E8E93) : const Color(0xFFC7C7CC),
              ),
          ],
        ),
      ),
    );
  }
}
