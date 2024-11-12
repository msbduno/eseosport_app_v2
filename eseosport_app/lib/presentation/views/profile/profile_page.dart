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
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Box profil utilisateur
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/profile2');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.shade100,
                          child: const Icon(Icons.person_outline, color: Colors.grey),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${user.nom} ${user.prenom}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Box déconnexion
                InkWell(
                  onTap: () async {
                    await authViewModel.logout();
                    Navigator.pushReplacementNamed(context, '/signin');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.logout, color: Colors.grey),
                        SizedBox(width: 12),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
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