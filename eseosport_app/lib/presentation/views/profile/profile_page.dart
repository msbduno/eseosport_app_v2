import 'package:eseosport_app/presentation/views/profile/profile_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../home_page.dart';
import '../record/record_page.dart';
import '../activity/activities_page.dart';

class ProfilePage extends StatelessWidget {
  Future<bool> _showLogoutDialog(BuildContext context) async {
    return await showCupertinoDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: const Text('Confirmation'),
                content: const Text('Are you sure you want to log out?'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: const Text('Cancel', style: TextStyle(color: CupertinoColors.systemGrey)),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: const Text('Log Out'),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              );
            }) ??
        false;
  }

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
            backgroundColor: CupertinoColors.systemBackground,
            border: null,
          ),
          backgroundColor: CupertinoColors.systemBackground,
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Photo de profil
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey6,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              CupertinoIcons.person_fill,
                              size: 40,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Nom et email
                          Text(
                            '${user.nom} ${user.prenom}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            user.email ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Settings button
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              // In ProfilePage
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => Profile2Page(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: CupertinoColors.systemGrey5),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemGrey6,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.gear,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Settings',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: CupertinoColors.label,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    CupertinoIcons.chevron_right,
                                    color: CupertinoColors.systemGrey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Logout button
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              final shouldLogout =
                                  await _showLogoutDialog(context);
                              if (shouldLogout) {
                                await authViewModel.logout();
                                Navigator.of(context)
                                    .pushReplacementNamed('/signin');
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: CupertinoColors.systemGrey5),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: CupertinoColors.systemGrey6,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      CupertinoIcons.square_arrow_right,
                                      color: CupertinoColors.systemGrey,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Log Out',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: CupertinoColors.label,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomCupertinoNavBar(
                  currentIndex: 3,
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(builder: (context) => HomePage()),
                          (route) => false,
                        );
                        break;
                      case 1:
                        Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(
                              builder: (context) => const RecordPage()),
                          (route) => false,
                        );
                        break;
                      case 2:
                        Navigator.of(context).pushAndRemoveUntil(
                          CupertinoPageRoute(
                              builder: (context) => ActivitiesPage()),
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
