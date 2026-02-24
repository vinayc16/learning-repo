import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyUserProfileImage = 'user_profile_image';
  static const String _keyUsersData = 'users_data'; // JSON string of all users

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Register new user
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Get existing users
    final usersJson = prefs.getString(_keyUsersData) ?? '{}';
    final users = Map<String, dynamic>.from(
      usersJson.isEmpty || usersJson == '{}' 
        ? {} 
        : Map<String, dynamic>.from(
            (await Future.value(usersJson))
                .split('|||')
                .fold<Map<String, dynamic>>({}, (map, user) {
              if (user.isEmpty) return map;
              final parts = user.split(':::');
              if (parts.length >= 4) {
                map[parts[1]] = {
                  'name': parts[0],
                  'email': parts[1],
                  'phone': parts[2],
                  'password': parts[3],
                  'profileImage': parts.length > 4 ? parts[4] : '',
                };
              }
              return map;
            })
        )
    );

    // Check if email already exists
    if (users.containsKey(email)) {
      return {'success': false, 'message': 'Email already registered'};
    }

    // Add new user
    users[email] = {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'profileImage': '',
    };

    // Save users data
    final usersString = users.entries
        .map((e) => '${e.value['name']}:::${e.value['email']}:::${e.value['phone']}:::${e.value['password']}:::${e.value['profileImage']}')
        .join('|||');
    
    await prefs.setString(_keyUsersData, usersString);

    // Log in the user
    await _setUserData(
      userId: email,
      name: name,
      email: email,
      phone: phone,
    );

    return {'success': true, 'message': 'Registration successful'};
  }

  // Login user
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_keyUsersData) ?? '';
    
    if (usersJson.isEmpty) {
      return {'success': false, 'message': 'No users found. Please register.'};
    }

    // Parse users
    final users = usersJson.split('|||').fold<Map<String, dynamic>>({}, (map, user) {
      if (user.isEmpty) return map;
      final parts = user.split(':::');
      if (parts.length >= 4) {
        map[parts[1]] = {
          'name': parts[0],
          'email': parts[1],
          'phone': parts[2],
          'password': parts[3],
          'profileImage': parts.length > 4 ? parts[4] : '',
        };
      }
      return map;
    });

    // Check credentials
    if (!users.containsKey(email)) {
      return {'success': false, 'message': 'User not found'};
    }

    final userData = users[email]!;
    if (userData['password'] != password) {
      return {'success': false, 'message': 'Invalid password'};
    }

    // Set user data
    await _setUserData(
      userId: email,
      name: userData['name'],
      email: userData['email'],
      phone: userData['phone'],
      profileImage: userData['profileImage'],
    );

    return {'success': true, 'message': 'Login successful'};
  }

  // Set user data in SharedPreferences
  Future<void> _setUserData({
    required String userId,
    required String name,
    required String email,
    required String phone,
    String? profileImage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserId, userId);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserPhone, phone);
    if (profileImage != null) {
      await prefs.setString(_keyUserProfileImage, profileImage);
    }
  }

  // Get current user data
  Future<Map<String, String>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString(_keyUserId) ?? '',
      'name': prefs.getString(_keyUserName) ?? '',
      'email': prefs.getString(_keyUserEmail) ?? '',
      'phone': prefs.getString(_keyUserPhone) ?? '',
      'profileImage': prefs.getString(_keyUserProfileImage) ?? '',
    };
  }

  // Update user profile
  Future<bool> updateProfile({
    required String name,
    required String phone,
    String? profileImage,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_keyUserEmail) ?? '';
    
    if (email.isEmpty) return false;

    // Update in users data
    final usersJson = prefs.getString(_keyUsersData) ?? '';
    if (usersJson.isEmpty) return false;

    final users = usersJson.split('|||').fold<Map<String, dynamic>>({}, (map, user) {
      if (user.isEmpty) return map;
      final parts = user.split(':::');
      if (parts.length >= 4) {
        map[parts[1]] = {
          'name': parts[0],
          'email': parts[1],
          'phone': parts[2],
          'password': parts[3],
          'profileImage': parts.length > 4 ? parts[4] : '',
        };
      }
      return map;
    });

    if (!users.containsKey(email)) return false;

    // Update user data
    users[email]!['name'] = name;
    users[email]!['phone'] = phone;
    if (profileImage != null) {
      users[email]!['profileImage'] = profileImage;
    }

    // Save updated users
    final usersString = users.entries
        .map((e) => '${e.value['name']}:::${e.value['email']}:::${e.value['phone']}:::${e.value['password']}:::${e.value['profileImage']}')
        .join('|||');
    
    await prefs.setString(_keyUsersData, usersString);

    // Update current user data
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserPhone, phone);
    if (profileImage != null) {
      await prefs.setString(_keyUserProfileImage, profileImage);
    }

    return true;
  }

  // Logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserPhone);
    await prefs.remove(_keyUserProfileImage);
  }
}
