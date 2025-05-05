import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'change_password_screen.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool biometricEnabled = false;
  bool twoFactorEnabled = true;
  bool transactionAlertsEnabled = true;
  bool isFaceIdSupported = false;
  bool isTouchIdSupported = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final available = await auth.getAvailableBiometrics();
      setState(() {
        isFaceIdSupported = available.contains(BiometricType.face);
        isTouchIdSupported = available.contains(BiometricType.fingerprint);
      });
    } catch (e) {
      // Handle errors or unavailable biometrics
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Security'),
        backgroundColor: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white,
        border: null,
      ),
      backgroundColor: isDark ? const Color(0xFF000000) : const Color(0xFFF2F2F7),
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 20),
            _CupertinoSettingsSection(
              header: "Authentication",
              tiles: [
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.lock_shield,
                  title: isFaceIdSupported
                      ? "Enable Face ID"
                      : isTouchIdSupported
                          ? "Enable Touch ID"
                          : "Enable Biometrics",
                  trailing: CupertinoSwitch(
                    value: biometricEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        biometricEnabled = value;
                        // TODO: save biometric preference to secure storage/provider
                      });
                    },
                  ),
                ),
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.pencil,
                  title: "Change Password",
                  onTap: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.shield,
                  title: "Two-Factor Authentication",
                  trailing: CupertinoSwitch(
                    value: twoFactorEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        twoFactorEnabled = value;
                        // TODO: Implement 2FA toggle
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _CupertinoSettingsSection(
              header: "Notifications",
              tiles: [
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.bell,
                  title: "Transaction Alerts",
                  trailing: CupertinoSwitch(
                    value: transactionAlertsEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        transactionAlertsEnabled = value;
                        // TODO: Implement alert toggle
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _CupertinoSettingsSection(
              header: "Card Management",
              tiles: [
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.creditcard,
                  title: "Block Card",
                  onTap: () {
                    // TODO: Implement card blocking
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            _CupertinoSettingsSection(
              header: "Help",
              tiles: [
                _CupertinoSettingsTile(
                  icon: CupertinoIcons.question_circle,
                  title: "Security Tips",
                  onTap: () {
                    // TODO: Implement security tips screen
                  },
                ),
              ],
            ),
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
            bottom: 4,
          ),
          child: Text(
            header.toUpperCase(),
            style: TextStyle(
              color: isDark ? CupertinoColors.systemGrey : CupertinoColors.systemGrey,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : CupertinoColors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: List.generate(tiles.length, (i) {
              return Column(
                children: [
                  if (i != 0)
                    Divider(
                      height: 0,
                      indent: 50,
                      color: isDark ? const Color(0xFF38383A) : const Color(0xFFD1D1D6),
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
            Icon(icon, color: CupertinoColors.activeBlue, size: 24),
            const SizedBox(width: 12),
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
