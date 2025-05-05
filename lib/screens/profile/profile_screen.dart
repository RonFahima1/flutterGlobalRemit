import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
// import your reusable card, button, etc. from components/ as needed

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.user ??
        User(
          id: 'u1',
          name: 'John Appleseed',
          email: 'john@icloud.com',
          avatarUrl: 'https://avatars.githubusercontent.com/u/1?v=4',
        );

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Profile"),
        backgroundColor: isDark 
            ? GlobalRemitColors.secondaryBackgroundDark
            : GlobalRemitColors.secondaryBackgroundLight,
        border: null,
      ),
      backgroundColor: isDark 
          ? GlobalRemitColors.primaryBackgroundDark
          : GlobalRemitColors.primaryBackgroundLight,
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
                    backgroundColor: GlobalRemitColors.primaryBlue(context).withOpacity(0.1),
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: GlobalRemitTypography.title2(context),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: GlobalRemitTypography.subhead(context)
                        .copyWith(color: isDark
                            ? GlobalRemitColors.gray2Dark
                            : GlobalRemitColors.gray2Light),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Grouped settings section
            _CupertinoSettingsSection(
              header: "Account",
              tiles: [
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.person_crop_circle,
                  title: "Edit Profile",
                  onTap: () {
                    // TODO: go to edit profile
                  },
                ),
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.lock,
                  title: "Security",
                  onTap: () {
                    // TODO: go to security screen
                  },
                ),
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.creditcard,
                  title: "Payment Methods",
                  onTap: () {
                    // TODO: go to payment methods
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            _CupertinoSettingsSection(
              header: "App",
              tiles: [
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.doc_text,
                  title: "Privacy Policy",
                  onTap: () {
                    // TODO: go to privacy policy screen
                  },
                ),
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.question_circle,
                  title: "Help Center",
                  onTap: () {
                    // TODO: go to help center screen
                  },
                ),
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.bell,
                  title: "Notifications",
                  trailing: CupertinoSwitch(
                    value: true,
                    onChanged: (val) {
                      // TODO: notification toggle
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Sign out
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: CupertinoButton(
                color: isDark 
                    ? GlobalRemitColors.errorRedDark
                    : GlobalRemitColors.errorRedLight,
                borderRadius: BorderRadius.circular(22),
                child: const Text("Sign Out"),
                onPressed: () {
                  auth.signOut();
                  // TODO: Navigate to login
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// Move helper widgets to a separate file for reuse if needed.
class _CupertinoSettingsSection extends StatelessWidget {
  final String header;
  final List<Widget> tiles;
  const _CupertinoSettingsSection({
    Key? key,
    required this.header,
    required this.tiles,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 24,
            bottom: 4,
          ),
          child: Text(
            header,
            style: GlobalRemitTypography.footnote(context).copyWith(
              color: isDark
                  ? GlobalRemitColors.gray2Dark
                  : GlobalRemitColors.gray2Light,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? GlobalRemitColors.secondaryBackgroundDark
                : GlobalRemitColors.secondaryBackgroundLight,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                ),
            ],
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Column(
            children: List.generate(tiles.length, (i) {
              return Column(
                children: [
                  if (i != 0)
                    Divider(
                      height: 0,
                      indent: 50,
                      color: isDark
                          ? GlobalRemitColors.gray4Dark
                          : GlobalRemitColors.gray3Light,
                      thickness: 0.7,
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
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      color: Colors.transparent,
      borderRadius: BorderRadius.zero,
      child: Container(
        height: 56,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Icon(icon, color: GlobalRemitColors.primaryBlue(context), size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GlobalRemitTypography.body(context),
              ),
            ),
            if (trailing != null)
              trailing!
            else
              Icon(
                CupertinoIcons.right_chevron,
                size: 18,
                color: isDark
                    ? GlobalRemitColors.gray3Dark
                    : GlobalRemitColors.gray3Light,
              ),
          ],
        ),
      ),
    );
  }
}
