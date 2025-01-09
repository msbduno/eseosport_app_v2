import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../viewmodels/auth_viewmodel.dart';

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

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text(
              'Profile',
              style: TextStyle(
                inherit: true,
                color: CupertinoColors.black,
                fontSize: 17,
              ),
            ),
            backgroundColor: CupertinoColors.white,
            border: null,
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          backgroundColor: CupertinoColors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 24),
                    // Avatar Section
                    Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey6,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${user?.nom[0].toUpperCase()}${user?.prenom[0].toUpperCase()}',
                              style: const TextStyle(
                                inherit: true,
                                fontSize: 40,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildTextField(
                      controller: _nameController,
                      placeholder: 'Full Name',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _emailController,
                      placeholder: 'Email',
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _passwordController,
                      placeholder: 'Password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      placeholder: 'Password Again',
                      obscureText: true,
                    ),
                    const SizedBox(height: 32),
                    CupertinoButton.filled(
                      child: const Text('Save changes'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return CupertinoTextField(
      controller: controller,
      placeholder: placeholder,
      obscureText: obscureText,
      keyboardType: keyboardType,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      style: const TextStyle(
        inherit: true,
        color: CupertinoColors.black,
      ),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}