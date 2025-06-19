import 'package:ai_cook_project/dialogs/status_dialogs.dart';
import 'package:ai_cook_project/screens/main/main_screen.dart';
import 'package:ai_cook_project/screens/userInfo/services/submit_service.dart';
import 'package:ai_cook_project/screens/userInfo/widgets/form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ai_cook_project/theme.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  DateTime? _birthDate;
  String? _selectedGender;
  final String? _email = FirebaseAuth.instance.currentUser?.email;
  final String? _uid = FirebaseAuth.instance.currentUser?.uid;
  bool _showValidationErrors = false;

  Future<void> _handleSubmit() async {
    setState(() {
      _showValidationErrors = true;
    });

    final service = UserInfoService(
      formKey: _formKey,
      nameController: _nameController,
      birthDate: _birthDate,
      selectedGender: _selectedGender,
      email: _email,
      uid: _uid,
    );

    final result = await service.submitUserInfo();

    if (!mounted) return;

    if (result.success) {
      debugPrint('User info submitted successfully');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    } else if (result.validationErrors != null) {
      showValidationErrorDialog(context, result.validationErrors!);
    } else if (result.errorMessage != null) {
      showErrorDialog(context, result.errorMessage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                UserInfoForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  birthDate: _birthDate,
                  selectedGender: _selectedGender,
                  email: _email,
                  uid: _uid,
                  showValidationErrors: _showValidationErrors,
                  onBirthDateChanged:
                      (newDate) => setState(() => _birthDate = newDate),
                  onGenderChanged:
                      (newGender) =>
                          setState(() => _selectedGender = newGender),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      elevation: 2,
                      shadowColor: AppColors.orange.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
