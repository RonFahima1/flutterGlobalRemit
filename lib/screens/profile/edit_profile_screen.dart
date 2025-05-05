import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _avatarPath;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() {
        _avatarPath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Edit Profile"),
        backgroundColor: GlobalRemitColors.secondaryBackground(context),
        border: null,
      ),
      backgroundColor: GlobalRemitColors.primaryBackground(context),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: GlobalRemitSpacing.insetL),
          children: [
            const SizedBox(height: GlobalRemitSpacing.insetXL),
            Center(
              child: GestureDetector(
                onTap: _pickAvatar,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: GlobalRemitColors.primaryBlue.withOpacity(0.1),
                      backgroundImage: _avatarPath != null
                          ? FileImage(
                              File(_avatarPath!),
                            )
                          : null,
                      child: _avatarPath == null
                          ? Icon(CupertinoIcons.person, size: 48, color: GlobalRemitColors.primaryBlue)
                          : null,
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: GlobalRemitColors.primaryBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(CupertinoIcons.camera_fill, color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: GlobalRemitSpacing.insetL),
            CupertinoTextField(
              controller: _nameController,
              placeholder: 'Name',
              padding: const EdgeInsets.symmetric(
                horizontal: GlobalRemitSpacing.insetM,
                vertical: GlobalRemitSpacing.insetS,
              ),
              style: GlobalRemitTypography.body(context),
              decoration: BoxDecoration(
                color: GlobalRemitColors.secondaryBackground(context),
                borderRadius: BorderRadius.circular(GlobalRemitSpacing.borderRadiusM),
              ),
            ),
            const SizedBox(height: GlobalRemitSpacing.insetM),
            CupertinoTextField(
              controller: _emailController,
              placeholder: 'Email',
              padding: const EdgeInsets.symmetric(
                horizontal: GlobalRemitSpacing.insetM,
                vertical: GlobalRemitSpacing.insetS,
              ),
              style: GlobalRemitTypography.body(context),
              decoration: BoxDecoration(
                color: GlobalRemitColors.secondaryBackground(context),
                borderRadius: BorderRadius.circular(GlobalRemitSpacing.borderRadiusM),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: GlobalRemitSpacing.insetXL),
            CupertinoButton.filled(
              borderRadius: BorderRadius.circular(GlobalRemitSpacing.pillButtonRadius),
              onPressed: () {
                // TODO: Integrate with provider/backend for real saving
                Navigator.of(context).pop(); // Go back on save
              },
              child: const Text('Save Changes'),
            ),
            const SizedBox(height: GlobalRemitSpacing.insetM),
            CupertinoButton(
              borderRadius: BorderRadius.circular(GlobalRemitSpacing.pillButtonRadius),
              color: CupertinoColors.systemGrey5.resolveFrom(context),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: CupertinoColors.label)),
            )
          ],
        ),
      ),
    );
  }
}