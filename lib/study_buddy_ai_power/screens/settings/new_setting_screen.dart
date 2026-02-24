import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:learning_statemanejment/ai_power_app/widget/custom_text.dart';
import 'package:learning_statemanejment/study_buddy_ai_power/utils/apploader.dart';
import 'package:learning_statemanejment/study_buddy_ai_power/widget/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../../services/auth_service.dart';
import '../../services/permission_service.dart';
import '../../services/api_key_service.dart';
import '../auth/login_screen.dart';
import '../help_support/help_support_screen.dart';
import '../legal/privacy_policy_screen.dart';
import '../legal/terms_of_service_screen.dart';
import '../report_bug/report_bug_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _authService = AuthService();
  final _permissionService = PermissionService();
  final _apiKeyService = ApiKeyService();
  Map<String, String> _userData = {};
  bool _isLoading = true;
  bool _cameraPermissionGranted = false;
  bool _storagePermissionGranted = false;
  bool _notificationsEnabled = true;
  bool _studyReminders = true;
  bool _darkMode = false;
  String _selectedLanguage = 'English';
  bool _hasCustomApiKey = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await _authService.getUserData();
    final cameraGranted = await _permissionService.isCameraPermissionGranted();
    final storageGranted = await _permissionService.isStoragePermissionGranted();
    final hasCustomKey = await _apiKeyService.hasCustomApiKey();

    // Load preferences
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _userData = data;
      _cameraPermissionGranted = cameraGranted;
      _storagePermissionGranted = storageGranted;
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _studyReminders = prefs.getBool('study_reminders') ?? true;
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'English';
      _hasCustomApiKey = hasCustomKey;
      _isLoading = false;
    });
  }

  Future<void> _savePreference(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  Future<void> _editProfile() async {
    final nameController = TextEditingController(text: _userData['name']);
    final phoneController = TextEditingController(text: _userData['phone']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const CustomText(text: 'Edit Profile',fontWeight: FontWeight.w600,fontSize: 18,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                //prefixIcon: const Icon(Icons.person, color: Color(0xFF667EEA)),
                //border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                //prefixIcon: const Icon(Icons.phone, color: Color(0xFF667EEA)),
                //border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText(text: 'Cancel',color: Colors.black54,fontWeight: FontWeight.w600,fontSize: 14,),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await _authService.updateProfile(
                name: nameController.text,
                phone: phoneController.text,
              );

              if (!mounted) return;
              Navigator.pop(context);

              if (success) {
                _showSnackBar('Profile updated successfully', Colors.green);
                _loadData();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const CustomText(text: 'Save',fontSize: 14,fontWeight: FontWeight.w600,color: Colors.white,),
          ),
        ],
      ),
    );
  }

  Future<void> _manageApiKey() async {
    final currentKey = await _apiKeyService.getCustomApiKey();
    final apiKeyController = TextEditingController(text: currentKey ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF667EEA).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.key, color: Color(0xFF667EEA), size: 20),
            ),
            const SizedBox(width: 12),
            const CustomText(text: 'Gemini API Key',fontSize: 16,fontWeight: FontWeight.bold,),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_hasCustomApiKey)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: CustomText(
                          text: 'Using custom API key',
                         fontWeight: FontWeight.w500,
                         color: Colors.green, fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              CustomText(
                text: 'Enter your Google Gemini API key to use your own quota. Leave blank to use the default key.',
               fontWeight: FontWeight.w500,
               maxLines: 5,
               fontSize: 12, color: Colors.grey.shade600,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: apiKeyController,
                decoration: InputDecoration(
                  //labelText: 'API Key',
                  hintText: 'Your API Key',
                  //prefixIcon: const Icon(Icons.vpn_key, color: Color(0xFF667EEA),size: 14,),
                  //border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  // focusedBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(12),
                  //   borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
                  // ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.help_outline, size: 16),
                    onPressed: () {
                      _showSnackBar(
                        'Get your API key from Google AI Studio: makersuite.google.com',
                        Colors.blue,
                      );
                    },
                  ),
                ),
              ),

              if (_hasCustomApiKey)
                TextButton(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: const CustomText(text: 'Remove Custom Key?',fontWeight: FontWeight.bold,fontSize: 16,),
                        content: const CustomText(
                            text: 'This will revert to using the default API key.',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          maxLines: 5,
                          color: Colors.grey,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const CustomText(text: 'Cancel',fontSize: 14,color: Colors.black54,fontWeight: FontWeight.w600,),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red,),
                            child: const CustomText(text: 'Remove',fontWeight: FontWeight.w600,color: Colors.white,fontSize: 14,),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await _apiKeyService.removeCustomApiKey();
                      if (!mounted) return;
                      Navigator.pop(context);
                      _showSnackBar('Reverted to default API key', Colors.orange);
                      _loadData();
                    }
                  },
                  child: const CustomText(text: 'Remove API Key', color: Colors.red,fontWeight: FontWeight.w600,),
                ),

              if (!_hasCustomApiKey)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.blue, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomText(
                            text: 'Currently using default API key',
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade700, fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText(text: 'Cancel',color: Colors.black54,fontWeight: FontWeight.w600,),
          ),
          ElevatedButton(
            onPressed: () async {
              final key = apiKeyController.text.trim();

              if (key.isEmpty) {
                // Remove custom key if empty
                await _apiKeyService.removeCustomApiKey();
                if (!mounted) return;
                Navigator.pop(context);
                _showSnackBar('Using default API key', Colors.blue);
                _loadData();
                return;
              }

              // Validate API key
              if (!_apiKeyService.isValidApiKey(key)) {
                _showSnackBar(
                  'Invalid API key format. Should start with "AIzaSy"',
                  Colors.red,
                );
                return;
              }

              // Save API key
              final success = await _apiKeyService.saveApiKey(key);

              if (!mounted) return;
              Navigator.pop(context);

              if (success) {
                _showSnackBar('API key saved successfully', Colors.green);
                _loadData();
              } else {
                _showSnackBar('Failed to save API key', Colors.red);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const CustomText(text: 'Save',fontWeight: FontWeight.w600,fontSize: 14,color: Colors.white,),
          ),
        ],
      ),
    );
  }

  Future<void> _changeProfilePicture() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CustomText(
              text: 'Change Profile Picture',
              fontSize: 18, fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF667EEA),size: 20,),
              title: const CustomText(text: 'Take Photo',fontWeight: FontWeight.w500,color: Colors.black54,),
              onTap: () async {
                Navigator.pop(context);
                await _pickProfileImage(fromCamera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF667EEA),size: 20,),
              title: const CustomText(text: 'Choose from Gallery',fontWeight: FontWeight.w500,color: Colors.black54,),
              onTap: () async {
                Navigator.pop(context);
                await _pickProfileImage(fromCamera: false);
              },
            ),
            if (_userData['profileImage']?.isNotEmpty == true)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red,size: 20,),
                title: const CustomText(text: 'Remove Photo',fontWeight: FontWeight.w500,color: Colors.red,),
                onTap: () async {
                  Navigator.pop(context);
                  await _authService.updateProfile(
                    name: _userData['name']!,
                    phone: _userData['phone']!,
                    profileImage: '',
                  );
                  _loadData();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickProfileImage({required bool fromCamera}) async {
    final permissionResult = fromCamera
        ? await _permissionService.checkAndRequestCameraPermission()
        : await _permissionService.checkAndRequestStoragePermission();

    if (!permissionResult['granted']) {
      if (!mounted) return;
      _showSnackBar(permissionResult['message'], Colors.orange);
      return;
    }

    try {
      final picker = ImagePicker();
      final XFile? image = await (fromCamera
          ? picker.pickImage(source: ImageSource.camera)
          : picker.pickImage(source: ImageSource.gallery));

      if (image == null) return;

      final success = await _authService.updateProfile(
        name: _userData['name']!,
        phone: _userData['phone']!,
        profileImage: image.path,
      );

      if (!mounted) return;

      if (success) {
        _showSnackBar('Profile picture updated', Colors.green);
        _loadData();
      }
    } catch (e) {
      if (!mounted) return;
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  Future<void> _handleCameraPermission() async {
    final result = await _permissionService.checkAndRequestCameraPermission();

    if (!mounted) return;

    if (result['granted']) {
      _showSnackBar('Camera permission granted', Colors.green);
    } else if (result['openSettings'] == true) {
      _showPermissionDialog('Camera');
    } else {
      _showSnackBar(result['message'], Colors.red);
    }

    _loadData();
  }

  Future<void> _handleStoragePermission() async {
    final result = await _permissionService.checkAndRequestStoragePermission();

    if (!mounted) return;

    if (result['granted']) {
      _showSnackBar('Storage permission granted', Colors.green);
    } else if (result['openSettings'] == true) {
      _showPermissionDialog('Storage');
    } else {
      _showSnackBar(result['message'], Colors.red);
    }

    _loadData();
  }

  void _showPermissionDialog(String permissionType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('$permissionType Permission Required'),
        content: Text(
          '$permissionType permission has been permanently denied. Please enable it from app settings to use this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _permissionService.openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const CustomText(text: 'Clear Cache',fontWeight: FontWeight.bold,fontSize: 16,),
        content: const CustomText(
          text: 'Are you sure you want to clear app cache? This will not delete your saved notes.',
          fontWeight: FontWeight.w500,
          color: Colors.black54,
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText(text: 'Cancel',fontSize: 12,fontWeight: FontWeight.w500,),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              // Simulate cache clearing
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear(); // Clear all data
              await Future.delayed(const Duration(milliseconds: 500));
              _showSnackBar('Cache cleared successfully', Colors.green);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const CustomText(text: 'Clear',fontWeight: FontWeight.w500,color: Colors.white,fontSize: 12,),
          ),
        ],
      ),
    );
  }

  Future<void> _rateApp() async {
    // In a real app, this would open the app store
    _showSnackBar('Opening app store...', Colors.blue);
  }

  Future<void> _shareApp() async {
    await Share.share(
      'Check out Study Buddy - Your AI-Powered Study Assistant!\nDownload now and boost your learning.',
      subject: 'Study Buddy App',
    );
  }

  Future<void> _openHelpCenter() async {
    _showSnackBar('Opening help center...', Colors.blue);
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const CustomText(text: 'Logout',color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16,),
        content: const CustomText(
            text: 'Are you sure you want to logout?',
          fontSize: 12,
          color: Colors.black54,
          fontWeight: FontWeight.w500,
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText(text: 'Cancel',fontSize: 14,color: Colors.black54,fontWeight: FontWeight.w600,),
          ),
          ElevatedButton(
            onPressed: () async {
              await _authService.logout();
              if (!mounted) return;

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const CustomText(text: 'Logout',fontWeight: FontWeight.w600,color: Colors.white,fontSize: 14,),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: AppLoader(color: Color(0xFF667EEA))),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: CustomText(
          text: "Settings",
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
        actions: [
          IconButton(onPressed: () {

          }, icon: Icon(Icons.info_outline))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // App Bar with Profile
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Profile Card
                  _buildProfileCard(),
                  const SizedBox(height: 20),

                  // App Preferences
                  _buildSectionCard(
                    title: 'App Preferences',
                    icon: Icons.tune,
                    children: [
                      // _buildSwitchTile(
                      //   icon: Icons.notifications,
                      //   title: 'Notifications',
                      //   subtitle: 'Receive app notifications',
                      //   value: _notificationsEnabled,
                      //   onChanged: (val) {
                      //     setState(() => _notificationsEnabled = val);
                      //     _savePreference('notifications_enabled', val);
                      //   },
                      // ),
                      // _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.alarm,
                        title: 'Study Reminders',
                        subtitle: 'Get reminded to study daily',
                        value: _studyReminders,
                        onChanged: (val) {
                          setState(() => _studyReminders = val);
                          _savePreference('study_reminders', val);
                        },
                      ),
                      _buildDivider(),
                      _buildSwitchTile(
                        icon: Icons.dark_mode,
                        title: 'Dark Mode',
                        subtitle: 'Switch to dark theme',
                        value: _darkMode,
                        onChanged: (val) {
                          setState(() => _darkMode = val);
                          _savePreference('dark_mode', val);
                          _showSnackBar('Restart app to apply theme', Colors.blue);
                        },
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.language,
                        title: 'Language',
                        subtitle: _selectedLanguage,
                        onTap: () => _showLanguageDialog(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Permissions
                  _buildSectionCard(
                    title: 'Permissions',
                    icon: Icons.security,
                    children: [
                      _buildPermissionTile(
                        icon: Icons.camera_alt,
                        title: 'Camera',
                        subtitle: 'Required to scan notes',
                        isGranted: _cameraPermissionGranted,
                        onTap: _handleCameraPermission,
                      ),
                      _buildDivider(),
                      _buildPermissionTile(
                        icon: Icons.photo_library,
                        title: 'Storage/Photos',
                        subtitle: 'Required to access gallery',
                        isGranted: _storagePermissionGranted,
                        onTap: _handleStoragePermission,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Data & Storage
                  _buildSectionCard(
                    title: 'Data & Storage',
                    icon: Icons.storage,
                    children: [
                      _buildNavigationTile(
                        icon: Icons.delete_sweep,
                        title: 'Clear Cache',
                        subtitle: 'Free up storage space',
                        onTap: _clearCache,
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.file_download,
                        title: 'Export Data',
                        subtitle: 'Download your study materials',
                        onTap: () => _showSnackBar('Feature coming soon!', Colors.blue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Support & Feedback
                  _buildSectionCard(
                    title: 'Support & Feedback',
                    icon: Icons.support_agent,
                    children: [
                      _buildNavigationTile(
                        icon: Icons.help_outline,
                        title: 'Help Center',
                        subtitle: 'Get help and support',
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HelpSupportScreen(),)),
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.star_outline,
                        title: 'Rate App',
                        subtitle: 'Share your feedback',
                        onTap: _rateApp,
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.share,
                        title: 'Share App',
                        subtitle: 'Tell your friends about us',
                        onTap: _shareApp,
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.bug_report,
                        title: 'Report a Bug',
                        subtitle: 'Help us improve',
                        onTap: () =>  Navigator.push(context, MaterialPageRoute(builder: (context) => ReportBugScreen(),)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // AI Settings
                  _buildSectionCard(
                    title: 'AI Settings',
                    icon: Icons.smart_toy,
                    children: [
                      _buildNavigationTile(
                        icon: FontAwesomeIcons.key,
                        title: 'Gemini API Key',
                        subtitle: _hasCustomApiKey ? 'Using custom key ✓' : 'Using default key',
                        onTap: _manageApiKey,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Legal
                  _buildSectionCard(
                    title: 'Legal',
                    icon: Icons.gavel,
                    children: [
                      _buildNavigationTile(
                        icon: Icons.privacy_tip,
                        title: 'Privacy Policy',
                        subtitle: 'How we handle your data',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
                        ),
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.description,
                        title: 'Terms of Service',
                        subtitle: 'App usage terms',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TermsOfServiceScreen()),
                        ),
                      ),
                      _buildDivider(),
                      _buildNavigationTile(
                        icon: Icons.info_outline,
                        title: 'About',
                        subtitle: 'Version 1.0.0',
                        onTap: () => _showAboutDialog(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Logout Button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const CustomText(
                        text: 'Logout',
                        fontSize: 16, fontWeight: FontWeight.w500,color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Picture
          Stack(
            children: [
              InstaImageViewer(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xFF667EEA),
                  backgroundImage: _userData['profileImage']?.isNotEmpty == true
                      ? FileImage(File(_userData['profileImage']!))
                      : null,
                  child: _userData['profileImage']?.isEmpty ?? true
                      ? Text(
                    _userData['name']?.isNotEmpty == true
                        ? _userData['name']![0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                      : null,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _changeProfilePicture,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667EEA),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Profile Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: _userData['name'] ?? 'User',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
                const SizedBox(height: 4),
                CustomText(
                    text:_userData['email'] ?? '',
                    fontSize: 13, color: Colors.grey.shade600
                ),
                CustomText(
                  text: _userData['phone'] ?? '',
                  fontSize: 13, color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
          // Edit Button
          IconButton(
            onPressed: _editProfile,
            icon: const Icon(Icons.edit, color: Color(0xFF667EEA),size: 20,),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFF667EEA).withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                // Container(
                //   padding: const EdgeInsets.all(8),
                //   decoration: BoxDecoration(
                //     color: const Color(0xFF667EEA).withOpacity(0.1),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Icon(icon, color: const Color(0xFF667EEA), size: 20),
                // ),
                // const SizedBox(width: 12),
                CustomText(
                  text: title,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF667EEA), size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: title,
                  fontSize: 14, fontWeight: FontWeight.w600,
                ),
                CustomText(
                  text: subtitle,
                  fontWeight: FontWeight.w500,
                  fontSize: 11, color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.8, // Adjust the scale value to make the switch smaller or larger
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF667EEA),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF667EEA), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 14, fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: subtitle,
                    fontWeight: FontWeight.w500,
                    fontSize: 11, color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isGranted,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF667EEA), size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 14, fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: subtitle,
                    fontWeight: FontWeight.w500,
                    fontSize: 11, color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isGranted ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: CustomText(
                text:isGranted ? 'Granted' : 'Denied',
                color: isGranted ? Colors.green : Colors.red,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, color: Colors.grey.shade200, indent: 56);
  }

  void _showLanguageDialog() {
    final languages = ['English', 'Spanish', 'French', 'German', 'Hindi', 'Chinese'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const CustomText(text: 'Select Language',fontWeight: FontWeight.w600,fontSize: 20,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: languages.map((lang) {
            return RadioListTile<String>(
              title: CustomText(text: lang,fontSize: 14,fontWeight: FontWeight.w500,),
              value: lang,
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
                _savePreference('language', value!);
                Navigator.pop(context);
                _showSnackBar('Language changed to $value', Colors.blue);
              },
              activeColor: const Color(0xFF667EEA),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF667EEA).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF667EEA), size: 20),
            ),
            const SizedBox(width: 12),
            const CustomText(text: 'Study Buddy',fontSize: 18,fontWeight: FontWeight.w600,),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText(text: 'Your AI-Powered Study Assistant',fontSize: 16,fontWeight: FontWeight.w500,maxLines: 2,color: Colors.black54,),
            const SizedBox(height: 16),
            CustomText(
              text: 'Version 1.0.0',
             color: Colors.grey.shade600, fontSize: 14,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: 'Powered by Google Gemini',
              color: Colors.grey.shade600, fontSize: 14,
            ),
            const SizedBox(height: 16),
            CustomText(
              text: '© ${DateTime.now().year} Study Buddy. All rights reserved.',
              maxLines: 2,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500, fontSize: 10,
            ),
            const SizedBox(height: 16),
            CustomButton(
              height: 40,
              color: Color(0xFF667EEA),
              fontWeight: FontWeight.w600,
              fontSize: 14,
              text: "Close",
              onTap: () {
                Navigator.pop(context);
            },)
          ],
        ),
      ),
    );
  }
}