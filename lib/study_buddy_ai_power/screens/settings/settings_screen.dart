// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../../services/auth_service.dart';
// import '../../services/permission_service.dart';
// import '../auth/login_screen.dart';
//
// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});
//
//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }
//
// class _SettingsScreenState extends State<SettingsScreen> {
//   final _authService = AuthService();
//   final _permissionService = PermissionService();
//   Map<String, String> _userData = {};
//   bool _isLoading = true;
//   bool _cameraPermissionGranted = false;
//   bool _storagePermissionGranted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     final data = await _authService.getUserData();
//     final cameraGranted = await _permissionService.isCameraPermissionGranted();
//     final storageGranted = await _permissionService.isStoragePermissionGranted();
//
//     setState(() {
//       _userData = data;
//       _cameraPermissionGranted = cameraGranted;
//       _storagePermissionGranted = storageGranted;
//       _isLoading = false;
//     });
//   }
//
//   Future<void> _editProfile() async {
//     final nameController = TextEditingController(text: _userData['name']);
//     final phoneController = TextEditingController(text: _userData['phone']);
//
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text('Edit Profile'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: InputDecoration(
//                 labelText: 'Full Name',
//                 prefixIcon: const Icon(Icons.person, color: Color(0xFF667EEA)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: phoneController,
//               keyboardType: TextInputType.phone,
//               decoration: InputDecoration(
//                 labelText: 'Phone Number',
//                 prefixIcon: const Icon(Icons.phone, color: Color(0xFF667EEA)),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: const BorderSide(color: Color(0xFF667EEA), width: 2),
//                 ),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final success = await _authService.updateProfile(
//                 name: nameController.text,
//                 phone: phoneController.text,
//               );
//
//               if (!mounted) return;
//               Navigator.pop(context);
//
//               if (success) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: const Text('Profile updated successfully'),
//                     backgroundColor: Colors.green.shade400,
//                     behavior: SnackBarBehavior.floating,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                   ),
//                 );
//                 _loadData();
//               }
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF667EEA),
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _changeProfilePicture() async {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Change Profile Picture',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             ListTile(
//               leading: const Icon(Icons.camera_alt, color: Color(0xFF667EEA)),
//               title: const Text('Take Photo'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickProfileImage(fromCamera: true);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.photo_library, color: Color(0xFF667EEA)),
//               title: const Text('Choose from Gallery'),
//               onTap: () async {
//                 Navigator.pop(context);
//                 await _pickProfileImage(fromCamera: false);
//               },
//             ),
//             if (_userData['profileImage']?.isNotEmpty == true)
//               ListTile(
//                 leading: const Icon(Icons.delete, color: Colors.red),
//                 title: const Text('Remove Photo'),
//                 onTap: () async {
//                   Navigator.pop(context);
//                   await _authService.updateProfile(
//                     name: _userData['name']!,
//                     phone: _userData['phone']!,
//                     profileImage: '',
//                   );
//                   _loadData();
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<void> _pickProfileImage({required bool fromCamera}) async {
//     final permissionResult = fromCamera
//         ? await _permissionService.checkAndRequestCameraPermission()
//         : await _permissionService.checkAndRequestStoragePermission();
//
//     if (!permissionResult['granted']) {
//       if (!mounted) return;
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(permissionResult['message']),
//           backgroundColor: Colors.orange.shade600,
//           behavior: SnackBarBehavior.floating,
//           action: permissionResult['openSettings'] == true
//               ? SnackBarAction(
//                   label: 'Settings',
//                   textColor: Colors.white,
//                   onPressed: () => _permissionService.openAppSettings(),
//                 )
//               : null,
//         ),
//       );
//       return;
//     }
//
//     try {
//       final picker = ImagePicker();
//       final XFile? image = await (fromCamera
//           ? picker.pickImage(source: ImageSource.camera)
//           : picker.pickImage(source: ImageSource.gallery));
//
//       if (image == null) return;
//
//       final success = await _authService.updateProfile(
//         name: _userData['name']!,
//         phone: _userData['phone']!,
//         profileImage: image.path,
//       );
//
//       if (!mounted) return;
//
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Profile picture updated'),
//             backgroundColor: Colors.green.shade400,
//             behavior: SnackBarBehavior.floating,
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//           ),
//         );
//         _loadData();
//       }
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Error: $e'),
//           backgroundColor: Colors.red.shade400,
//         ),
//       );
//     }
//   }
//
//   Future<void> _handleCameraPermission() async {
//     final result = await _permissionService.checkAndRequestCameraPermission();
//
//     if (!mounted) return;
//
//     if (result['granted']) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Camera permission granted'),
//           backgroundColor: Colors.green.shade400,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       );
//     } else if (result['openSettings'] == true) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: const Text('Camera Permission Required'),
//           content: const Text(
//             'Camera permission has been permanently denied. Please enable it from app settings to use this feature.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _permissionService.openAppSettings();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF667EEA),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               child: const Text('Open Settings'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(result['message']),
//           backgroundColor: Colors.red.shade400,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       );
//     }
//
//     _loadData();
//   }
//
//   Future<void> _handleStoragePermission() async {
//     final result = await _permissionService.checkAndRequestStoragePermission();
//
//     if (!mounted) return;
//
//     if (result['granted']) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: const Text('Storage permission granted'),
//           backgroundColor: Colors.green.shade400,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       );
//     } else if (result['openSettings'] == true) {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           title: const Text('Storage Permission Required'),
//           content: const Text(
//             'Storage permission has been permanently denied. Please enable it from app settings to use this feature.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 _permissionService.openAppSettings();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF667EEA),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               child: const Text('Open Settings'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(result['message']),
//           backgroundColor: Colors.red.shade400,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         ),
//       );
//     }
//
//     _loadData();
//   }
//
//   Future<void> _logout() async {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         title: const Text('Logout'),
//         content: const Text('Are you sure you want to logout?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               await _authService.logout();
//               if (!mounted) return;
//
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(builder: (_) => const LoginScreen()),
//                 (route) => false,
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//             ),
//             child: const Text('Logout'),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FD),
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Color(0xFF2D3436)),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'Settings',
//           style: TextStyle(
//             color: Color(0xFF2D3436),
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Profile Section
//             Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: const Color(0xFF667EEA),
//                         backgroundImage: _userData['profileImage']?.isNotEmpty == true
//                             ? FileImage(File(_userData['profileImage']!))
//                             : null,
//                         child: _userData['profileImage']?.isEmpty ?? true
//                             ? Text(
//                                 _userData['name']?.isNotEmpty == true
//                                     ? _userData['name']![0].toUpperCase()
//                                     : 'U',
//                                 style: const TextStyle(
//                                   fontSize: 36,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : null,
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: GestureDetector(
//                           onTap: _changeProfilePicture,
//                           child: Container(
//                             padding: const EdgeInsets.all(8),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFF667EEA),
//                               shape: BoxShape.circle,
//                               border: Border.all(color: Colors.white, width: 3),
//                             ),
//                             child: const Icon(
//                               Icons.camera_alt,
//                               color: Colors.white,
//                               size: 20,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     _userData['name'] ?? 'User',
//                     style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2D3436),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     _userData['email'] ?? '',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     _userData['phone'] ?? '',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: _editProfile,
//                     icon: const Icon(Icons.edit, size: 18),
//                     label: const Text('Edit Profile'),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF667EEA),
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // Permissions Section
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF667EEA).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Icon(
//                             Icons.security,
//                             color: Color(0xFF667EEA),
//                             size: 20,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         const Text(
//                           'Permissions',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF2D3436),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(height: 1, color: Colors.grey.shade200),
//                   _buildPermissionTile(
//                     icon: Icons.camera_alt,
//                     title: 'Camera',
//                     subtitle: 'Required to scan notes',
//                     isGranted: _cameraPermissionGranted,
//                     onTap: _handleCameraPermission,
//                   ),
//                   Divider(height: 1, color: Colors.grey.shade200, indent: 68),
//                   _buildPermissionTile(
//                     icon: Icons.photo_library,
//                     title: 'Storage/Photos',
//                     subtitle: 'Required to access gallery',
//                     isGranted: _storagePermissionGranted,
//                     onTap: _handleStoragePermission,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // App Info Section
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF667EEA).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: const Icon(
//                             Icons.info_outline,
//                             color: Color(0xFF667EEA),
//                             size: 20,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         const Text(
//                           'About',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF2D3436),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Divider(height: 1, color: Colors.grey.shade200),
//                   ListTile(
//                     leading: const Icon(Icons.school, color: Color(0xFF667EEA)),
//                     title: const Text('Study Buddy'),
//                     subtitle: const Text('Version 1.0.0'),
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//
//             // Logout Button
//             SizedBox(
//               height: 56,
//               child: ElevatedButton.icon(
//                 onPressed: _logout,
//                 icon: const Icon(Icons.logout),
//                 label: const Text(
//                   'Logout',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.red,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPermissionTile({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required bool isGranted,
//     required VoidCallback onTap,
//   }) {
//     return ListTile(
//       leading: Icon(icon, color: const Color(0xFF667EEA)),
//       title: Text(title),
//       subtitle: Text(subtitle),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: isGranted ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               isGranted ? 'Granted' : 'Denied',
//               style: TextStyle(
//                 color: isGranted ? Colors.green : Colors.red,
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
//         ],
//       ),
//       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
//       onTap: onTap,
//     );
//   }
// }
