import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../viewmodels/auth_viewmodel.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/signin');
          },
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 40),
              Text(
                'Create your account',
                style: TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 30,
                ),
              ),
              const SizedBox(height: 20),
              CupertinoTextField(
                controller: _firstNameController,
                placeholder: 'First Name',
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
                controller: _lastNameController,
                placeholder: 'Last Name',
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
                keyboardType: TextInputType.emailAddress,
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
                obscureText: true,
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
                obscureText: true,
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
              const SizedBox(height: 80),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      color: AppTheme.primaryColor,
                      padding: EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 50.0,
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: CupertinoColors.white,
                        ),
                      ),
                      onPressed: () async {
                        if (_emailController.text.isEmpty ||
                            _passwordController.text.isEmpty ||
                            _firstNameController.text.isEmpty ||
                            _lastNameController.text.isEmpty) {
                          Navigator.pushReplacementNamed(context, '/home');
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: const Text('Error'),
                              content:
                              const Text('Please fill in all fields.'),
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
                          Navigator.pushReplacementNamed(context, '/home');
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

                        // Créer un nouveau UserModel avec les noms des champs adaptés
                        final newUser = UserModel(
                          prenom: _firstNameController.text,
                          nom: _lastNameController.text,
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        // Appeler register
                        bool registrationSuccess =
                        await authViewModel.register(newUser);

                        if (registrationSuccess) {
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          Navigator.pushReplacementNamed(context, '/home');
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: const Text('Registration Failed'),
                              content: const Text(
                                  'Please check your information and try again.'),
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
                          'Already have an account?',
                          style:
                          TextStyle(color: CupertinoColors.systemGrey),
                        ),
                        CupertinoButton(
                          child: Text(
                            'Sign In',
                            style: TextStyle(color: AppTheme.primaryColor),
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
    );
  }
}