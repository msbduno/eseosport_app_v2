import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class Profile2Page extends StatefulWidget {
  const Profile2Page({super.key});

  @override
  _Profile2PageState createState() => _Profile2PageState();
}

class _Profile2PageState extends State<Profile2Page> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final user = authViewModel.user;

    _nameController = TextEditingController(text: '${user?.nom} ${user?.prenom}');
    _emailController = TextEditingController(text: user?.email);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        final user = authViewModel.user;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Container(
            // add background color
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Avatar Section
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey.shade100,
                          child: Text(
                            '${user?.nom[0].toUpperCase()}${user?.prenom[0].toUpperCase()}',
                            style: TextStyle(
                              fontSize: 40,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Form Fields
                    _buildTextField(
                      controller: _nameController,
                      icon: Icons.person_outline,
                      label: 'Full Name',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      icon: Icons.mail_outline,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      icon: Icons.lock_outline,
                      label: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      icon: Icons.lock_outline,
                      label: 'Password Again',
                      obscureText: true,
                    ),
                    const SizedBox(height: 32),
                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            minimumSize: const Size(350, 40),
                          ),
                          child: const Text('Save changes'),
                        onPressed: () {
                            Navigator.pushReplacementNamed(context, '/profile');
                            /*
                          if (_formKey.currentState!.validate()) {
                            // TODO: Implement save changes logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }*/
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: 3,
            onTap: (index) {
              if (index == 0) {
                Navigator.pushReplacementNamed(context, '/home');
              } else if (index == 1) {
                Navigator.pushReplacementNamed(context, '/record');
              } else if (index == 2) {
                Navigator.pushReplacementNamed(context, '/activity');
              } else if (index == 3) {
                Navigator.pushReplacementNamed(context, '/profile');
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: label,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (label.toLowerCase().contains('email') &&
              !value.contains('@')) {
            return 'Please enter a valid email';
          }
          if (label == 'Password Again' &&
              value != _passwordController.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
    );
  }
}