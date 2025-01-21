import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_theme.dart';
import '../../viewmodels/auth_viewmodel.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[

          SliverFillRemaining(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(height: 60),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            "assets/logo.png",
                            width: 80,
                            height: 80,
                          ),
                        ),
                        // ... logo section ...
                      ],
                    ),
                  ),const SizedBox(height: 90),Text('Sign in to your account', style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 30)),

                    const SizedBox(height: 10),

                    CupertinoTextField(
  controller: _emailController,
  placeholder: 'Your Email',
  placeholderStyle: TextStyle(
    color: CupertinoColors.systemGrey,
  ),
  style: TextStyle(
    color: CupertinoColors.systemGrey // Change this color as needed
  ),
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
                      style: TextStyle(
                          color: CupertinoColors.systemGrey // Change this color as needed
                      ),
                      obscureText: true,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: CupertinoColors.systemGrey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    const SizedBox(height: 150),
                    Center(
                      child: Column(
                        children: [
                          CupertinoButton(
                            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 50.0),
                            color: AppTheme.primaryColor,
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: CupertinoColors.white, // Change this color as needed
                              ),
                            ),
                            onPressed: () async {
  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
    Navigator.pushReplacementNamed(context, '/home');
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: const Text('Email and password cannot be empty.'),
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
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    Navigator.pushReplacementNamed(context, '/home');
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Login Failed'),
        content: const Text('Please check your credentials.'),
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
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Do not have an account ?',
                                style: TextStyle(color: CupertinoColors.systemGrey),
                              ),
                              CupertinoButton(
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(color: AppTheme.primaryColor),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/login');
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