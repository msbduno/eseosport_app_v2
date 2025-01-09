import 'package:eseosport_app/presentation/views/activity/activities_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../home_page.dart';
import '../record/record_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        final user = authViewModel.user;

        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/signin');
          });
          return Container();
        }

        return CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: Text('Profile'),
            backgroundColor: CupertinoColors.white,
            border: null,
          ),
          backgroundColor: CupertinoColors.white,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Box profil utilisateur
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed('/profile2');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: CupertinoColors.systemGrey4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: CupertinoColors.systemGrey6,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  CupertinoIcons.person,
                                  color: CupertinoColors.systemGrey,
                                ),
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
                      GestureDetector(
                        onTap: () async {
                          await authViewModel.logout();
                          Navigator.of(context).pushReplacementNamed('/signin');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: CupertinoColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: CupertinoColors.systemGrey4),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                CupertinoIcons.square_arrow_right,
                                color: CupertinoColors.systemGrey,
                              ),
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
                const Spacer(),
                CustomCupertinoNavBar(
                  currentIndex: 3,
                  onTap: (index) {
                    switch (index) {
                      case 1:
                        Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(
                            builder: (context) => const RecordPage(),
                          ),
                          (route) => false,
                        );
                        break;
                      case 0:
                        Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(
                            builder: (context) => HomePage(),
                          ),
                          (route) => false,
                        );
                        break;
                      case 2:
                        Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(
                            builder: (context) => ActivitiesPage(),
                          ),
                          (route) => false,
                        );
                        break;
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}