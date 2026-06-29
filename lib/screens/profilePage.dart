import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:romaquest/screens/homepage.dart';
import 'package:romaquest/theme/app_tokens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  File? _profileImage;
  int _batteryLevel = 0;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profileImagePath');
    if (imagePath != null) {
      setState(() {
        _profileImage = File(imagePath);
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImagePath', pickedFile.path);
    }
  }

  Future<void> _getBatteryLevel() async {
    final battery = Battery();
    final batteryLevel = await battery.batteryLevel;
    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: AppBorders.sheet,
                boxShadow: AppShadows.soft,
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 54,
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : const AssetImage('assets/images/profilepic.jpg')
                                as ImageProvider,
                      ),
                      Material(
                        color: theme.colorScheme.secondary,
                        shape: const CircleBorder(),
                        child: IconButton(
                          onPressed: _pickImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          tooltip: 'Edit profile photo',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Edit Profile',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Update your profile image and local account details.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: AppBorders.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account details',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      },
                      child: const Text('Save Profile'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: AppBorders.card,
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(
                      Icons.battery_6_bar_rounded,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Battery Level',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '$_batteryLevel%',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
