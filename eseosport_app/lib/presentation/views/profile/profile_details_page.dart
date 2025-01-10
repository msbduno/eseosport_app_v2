import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../data/models/user_model.dart';
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
  bool _isSaving = false;

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

  Future<void> _saveChanges(BuildContext context, UserModel currentUser) async {
    if (_passwordController.text.isNotEmpty &&
        _passwordController.text != _confirmPasswordController.text) {
      await showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Error'),
          content: const Text('Passwords do not match'),
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

    setState(() => _isSaving = true);

    try {
      final nameParts = _nameController.text.split(' ');
      final String nom = nameParts.first;
      final String prenom = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

      final updatedUser = UserModel(
        id: currentUser.id,
        nom: nom,
        prenom: prenom,
        email: _emailController.text,
        password: _passwordController.text.isNotEmpty
            ? _passwordController.text
            : currentUser.password,
      );

      await Provider.of<AuthViewModel>(context, listen: false)
          .updateUser(updatedUser);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        await showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text('Failed to update profile: ${e.toString()}'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        final user = authViewModel.user;

        if (user == null) {
          return const CupertinoActivityIndicator();
        }

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: const Text('Settings'),
            border: null,
            // chevron back
            leading: CupertinoNavigationBarBackButton(
  previousPageTitle: 'Profile',
  onPressed: () {
    Navigator.pop(context);
  },
),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  CupertinoFormSection.insetGrouped(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  header: const Text('CHANGE USER DETAILS'),
                    backgroundColor: CupertinoColors.systemBackground,
                    children: [
                      _buildFormRow(
                        'Full Name',
                        _nameController,
                        placeholder: '${user.nom} ${user.prenom}',
                        prefix: const Icon(CupertinoIcons.person,
                            color: CupertinoColors.systemGrey),
                      ),
                      _buildFormRow(
                        'Email',
                        _emailController,
                        placeholder: user.email,
                        keyboardType: TextInputType.emailAddress,
                        prefix: const Icon(CupertinoIcons.mail,
                            color: CupertinoColors.systemGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CupertinoFormSection.insetGrouped(
                    backgroundColor: CupertinoColors.systemBackground,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    header: const Text('CHANGE PASSWORD'),
                    children: [
                      _buildFormRow(
                        'New Password',
                        _passwordController,
                        isPassword: true,
                        prefix: const Icon(CupertinoIcons.lock,
                            color: CupertinoColors.systemGrey),
                      ),
                      _buildFormRow(
                        'Confirm Password',
                        _confirmPasswordController,
                        isPassword: true,
                        prefix: const Icon(CupertinoIcons.lock,
                            color: CupertinoColors.systemGrey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        color: const Color(0xFFEE4540),
                        borderRadius: BorderRadius.circular(8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        onPressed: _isSaving
                            ? null
                            : () => _saveChanges(context, user),
                        child: _isSaving
                            ? const CupertinoActivityIndicator(color: CupertinoColors.white)
                            : const Text('Save Changes', style: TextStyle(color: CupertinoColors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFormRow(
      String label,
      TextEditingController controller, {
        String? placeholder,
        bool isPassword = false,
        TextInputType? keyboardType,
        Widget? prefix,
      }) {
    return CupertinoFormRow(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (prefix != null) ...[
            prefix,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: CupertinoTextField.borderless(
              controller: controller,
              placeholder: placeholder,
              obscureText: isPassword,
              keyboardType: keyboardType,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}