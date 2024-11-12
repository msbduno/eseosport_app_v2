import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_bottom_nav_bar.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        final user = authViewModel.user;

        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/signin');
          });
          return Container();
        }

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: false,
            title: const Text(
              'Profile',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Name: ${user.nom}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Surname: ${user.prenom}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Email: ${user.email}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Log Out'),
                  onPressed: () {
                    authViewModel.logout();
                    Navigator.pushReplacementNamed(context, '/signin');
                  },
                ),
              ],
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
}