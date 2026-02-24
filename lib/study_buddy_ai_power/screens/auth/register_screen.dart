import 'package:flutter/material.dart';
import '../../../ai_power_app/widget/custom_text.dart';
import '../../services/auth_service.dart';
import '../home/study_buddy_home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await _authService.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const StudyBuddyHomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button
                  // IconButton(
                  //   onPressed: () => Navigator.pop(context),
                  //   icon: const Icon(Icons.arrow_back_ios, size: 20),
                  //   padding: EdgeInsets.zero,
                  //   alignment: Alignment.centerLeft,
                  // ),
                  // const SizedBox(height: 6),

                  // Header
                  Row(
                    children: [
                      const CustomText(
                        text: 'Create Account',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF667EEA),
                      ),
                    ],
                  ),
                  const CustomText(
                    text: 'Sign up to get started with Study Buddy',
                   fontSize: 15, color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 32),

                  // Full Name
                  const CustomText(text: 'Full Name', fontWeight: FontWeight.w600, fontSize: 14),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: _buildInputDecoration('Enter your full name', Icons.person_outline),
                    validator: (val) => val!.isEmpty ? 'Please enter your name' : null,
                  ),
                  const SizedBox(height: 20),

                  // Email Address
                  const CustomText(text: 'Email Address', fontWeight: FontWeight.w600, fontSize: 14),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration('Enter your email', Icons.email_outlined),
                    validator: (val) => val!.contains('@') ? null : 'Enter a valid email',
                  ),
                  const SizedBox(height: 20),

                  // Phone Number
                  const CustomText(text: 'Phone Number', fontWeight: FontWeight.w600, fontSize: 14),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: _buildInputDecoration('Enter phone number', Icons.phone_outlined),
                    validator: (val) => val!.length < 10 ? 'Enter valid phone number' : null,
                  ),
                  const SizedBox(height: 20),

                  // Password
                  const CustomText(text: 'Password', fontWeight: FontWeight.w600, fontSize: 14),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: _buildInputDecoration('Create a password', Icons.lock_outline).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (val) => val!.length < 6 ? 'Min 6 characters' : null,
                  ),
                  const SizedBox(height: 20),

                  // Confirm Password
                  const CustomText(text: 'Confirm Password', fontWeight: FontWeight.w600, fontSize: 14),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: _buildInputDecoration('Confirm your password', Icons.lock_reset_outlined).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, size: 20),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                    validator: (val) => val != _passwordController.text ? 'Passwords do not match' : null,
                  ),
                  const SizedBox(height: 40),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667EEA),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const CustomText(text: 'Register', fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white,),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Login Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CustomText(text: "Already have an account? ",fontWeight: FontWeight.w600,),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const CustomText(
                            text: 'Login',
                            color: Color(0xFF667EEA), fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}