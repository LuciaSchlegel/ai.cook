import 'package:ai_cook_project/screens/userInfo/helpers/decorations.dart';
import 'package:ai_cook_project/screens/userInfo/logic/selectors.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class UserInfoForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final DateTime? birthDate;
  final String? selectedGender;
  final String email;
  final String uid;
  final bool showValidationErrors;
  final void Function(DateTime) onBirthDateChanged;
  final void Function(String) onGenderChanged;

  const UserInfoForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.birthDate,
    required this.selectedGender,
    required this.email,
    required this.uid,
    required this.showValidationErrors,
    required this.onBirthDateChanged,
    required this.onGenderChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          const Text(
            'Complete Your Profile',
            style: TextStyle(
              fontFamily: 'Casta',
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Please fill in your information to continue',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildLabel("Full Name"),
                const SizedBox(height: 8),
                TextFormField(
                  controller: nameController,
                  decoration: inputDecoration('Enter your full name'),
                  validator: (value) {
                    if (!showValidationErrors) return null;
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                buildLabel("Date of Birth"),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap:
                      () => selectDate(
                        context: context,
                        initialDate: birthDate,
                        onDateSelected: onBirthDateChanged,
                      ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(
                        color:
                            showValidationErrors && birthDate == null
                                ? Colors.red.shade400
                                : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          birthDate == null
                              ? 'Select your date of birth'
                              : DateFormat('MMM dd, yyyy').format(birthDate!),
                          style: TextStyle(
                            color:
                                birthDate == null
                                    ? Colors.grey.shade600
                                    : AppColors.black,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.calendar,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                if (showValidationErrors && birthDate == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      'Please select your date of birth',
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                buildLabel("Gender"),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap:
                      () => selectGender(
                        context: context,
                        selectedGender: selectedGender,
                        onGenderSelected: onGenderChanged,
                      ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.all(
                        color:
                            showValidationErrors && selectedGender == null
                                ? Colors.red.shade400
                                : Colors.grey.shade300,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          selectedGender ?? 'Select your gender',
                          style: TextStyle(
                            color:
                                selectedGender == null
                                    ? Colors.grey.shade600
                                    : AppColors.black,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.chevron_down,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                if (showValidationErrors && selectedGender == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 12),
                    child: Text(
                      'Please select your gender',
                      style: TextStyle(
                        color: Colors.red.shade400,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
