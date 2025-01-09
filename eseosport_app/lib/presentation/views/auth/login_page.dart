import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../viewmodels/auth_viewmodel.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Create your account',
                style:
                    TextStyle(color: CupertinoColors.systemGrey, fontSize: 30)),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(
                CupertinoIcons.back,
                color: CupertinoColors.systemGrey,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/signin');
              },
            ),
          ),
          SliverFillRemaining(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 20),
                    CupertinoTextField(
                      controller: _nameController,
                      placeholder: 'Full Name',
                      placeholderStyle: TextStyle(
                        color: CupertinoColors.systemGrey,
                      ),
                      style: TextStyle(color: CupertinoColors.systemGrey),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.systemGrey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CupertinoTextField(
                      controller: _surnameController,
                      placeholder: 'Surname',
                      placeholderStyle: TextStyle(
                        color: CupertinoColors.systemGrey,
                      ),
                      style: TextStyle(color: CupertinoColors.systemGrey),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.systemGrey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CupertinoTextField(
                      controller: _emailController,
                      placeholder: 'Email',
                      placeholderStyle: TextStyle(
                        color: CupertinoColors.systemGrey,
                      ),
                      style: TextStyle(color: CupertinoColors.systemGrey),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.systemGrey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CupertinoTextField(
                      controller: _passwordController,
                      placeholder: 'Password',
                      placeholderStyle: TextStyle(
                        color: CupertinoColors.systemGrey,
                      ),
                      style: TextStyle(color: CupertinoColors.systemGrey),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.systemGrey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    const SizedBox(height: 10),
                    CupertinoTextField(
                      controller: _confirmPasswordController,
                      placeholder: 'Confirm Password',
                      placeholderStyle: TextStyle(
                        color: CupertinoColors.systemGrey,
                      ),
                      style: TextStyle(color: CupertinoColors.systemGrey),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.systemGrey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    const SizedBox(height: 110),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CupertinoButton(
                            color: AppTheme.primaryColor,
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 50.0),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: CupertinoColors
                                    .white, // Change this color as needed
                              ),
                            ),
                            onPressed: () async {
                              if (_emailController.text.isEmpty ||
                                  _passwordController.text.isEmpty) {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'Email and password cannot be empty.'),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text('OK'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }

                              if (_passwordController.text !=
                                  _confirmPasswordController.text) {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                    title: const Text('Error'),
                                    content: const Text(
                                        'Passwords do not match. Please try again.'),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text('OK'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }

                              bool loginSuccess = await authViewModel.login(
                                _emailController.text,
                                _passwordController.text,
                              );
                              if (loginSuccess) {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              } else {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (context) => CupertinoAlertDialog(
                                    title: const Text('Login Failed'),
                                    content: const Text(
                                        'Please check your credentials.'),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text('OK'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account ?',
                                style: TextStyle(
                                    color: CupertinoColors.systemGrey),
                              ),
                              CupertinoButton(
                                child: Text(
                                  'Sign In',
                                  style:
                                      TextStyle(color: AppTheme.primaryColor),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/signin');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
