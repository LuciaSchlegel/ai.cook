import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ai_cook_project/screens/main/main_screen.dart';
import 'package:ai_cook_project/theme.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

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

  final List<String> _genders = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];

  Future<void> _selectDate(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder:
          (BuildContext context) => Container(
            height: 300,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: CupertinoColors.systemBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (_birthDate == null) {
                            setState(() {
                              _birthDate = DateTime.now();
                            });
                          }
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: CupertinoColors.systemBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: _birthDate ?? DateTime.now(),
                      maximumDate: DateTime.now(),
                      minimumYear: 1900,
                      maximumYear: DateTime.now().year,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() {
                          _birthDate = newDate;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _selectGender(BuildContext context) async {
    await showCupertinoModalPopup(
      context: context,
      builder:
          (BuildContext context) => Container(
            height: 250,
            padding: const EdgeInsets.only(top: 6.0),
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: SafeArea(
              top: false,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: CupertinoColors.systemBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (_selectedGender == null) {
                            setState(() {
                              _selectedGender = _genders[0];
                            });
                          }
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(
                            color: CupertinoColors.systemBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      magnification: 1.2,
                      squeeze: 1.2,
                      useMagnifier: true,
                      itemExtent: 44,
                      scrollController: FixedExtentScrollController(
                        initialItem:
                            _selectedGender != null
                                ? _genders.indexOf(_selectedGender!)
                                : 0,
                      ),
                      onSelectedItemChanged: (int selectedIndex) {
                        setState(() {
                          _selectedGender = _genders[selectedIndex];
                        });
                      },
                      children:
                          _genders.map((String gender) {
                            return Center(
                              child: Text(
                                gender,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _submitUserInfo() async {
    setState(() {
      _showValidationErrors = true;
    });

    // Pre-validate the form
    final bool isFormValid = _formKey.currentState!.validate();
    final List<String> validationErrors = [];

    if (!isFormValid) {
      validationErrors.add('Enter your full name');
    }
    if (_birthDate == null) {
      validationErrors.add('Select your date of birth');
    }
    if (_selectedGender == null) {
      validationErrors.add('Select your gender');
    }

    if (validationErrors.isEmpty) {
      try {
        final response = await http.post(
          Uri.parse('${dotenv.env['API_URL']}/user/sign_up'),
          body: {
            'name': _nameController.text,
            'birthDate': _birthDate!.toIso8601String(),
            'gender': _selectedGender!,
            'email': _email,
            'uid': _uid,
          },
        );

        if (response.statusCode == 201) {
          if (context.mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          }
        } else {
          if (context.mounted) {
            String errorMessage = 'An unexpected error occurred';

            try {
              final errorBody = json.decode(response.body);
              errorMessage = errorBody['error'] ?? errorMessage;
            } catch (e) {
              errorMessage = _getErrorMessageFromStatusCode(
                response.statusCode,
              );
            }

            _showErrorDialog(context, errorMessage);
          }
        }
      } catch (e) {
        if (context.mounted) {
          _showErrorDialog(
            context,
            'Unable to connect to the server. Please check your internet connection and try again.',
          );
        }
      }
    } else {
      _showValidationErrorDialog(context, validationErrors);
    }
  }

  String _getErrorMessageFromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'The provided information is incomplete or invalid. Please check your details and try again.';
      case 401:
        return 'Authentication failed. Please try signing in again.';
      case 409:
        return 'A user with this email or ID already exists.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[700], size: 28),
              const SizedBox(width: 8),
              const Text(
                'Error',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.orange,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showValidationErrorDialog(BuildContext context, List<String> errors) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.amber[700],
                size: 28,
              ),
              const SizedBox(width: 8),
              const Text(
                'Missing Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Please complete the following:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ...errors.map((error) => _buildValidationItem(error)),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: AppColors.orange,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildValidationItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 16, color: Colors.red[700]),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
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
            child: Form(
              key: _formKey,
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
                        _buildLabel("Full Name"),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: _inputDecoration('Enter your full name'),
                          validator: (value) {
                            if (!_showValidationErrors) return null;
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildLabel("Date of Birth"),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              border: Border.all(
                                color:
                                    _showValidationErrors && _birthDate == null
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
                                  _birthDate == null
                                      ? 'Select your date of birth'
                                      : DateFormat(
                                        'MMM dd, yyyy',
                                      ).format(_birthDate!),
                                  style: TextStyle(
                                    color:
                                        _birthDate == null
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
                        if (_showValidationErrors && _birthDate == null)
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
                        _buildLabel("Gender"),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => _selectGender(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              border: Border.all(
                                color:
                                    _showValidationErrors &&
                                            _selectedGender == null
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
                                  _selectedGender ?? 'Select your gender',
                                  style: TextStyle(
                                    color:
                                        _selectedGender == null
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
                        if (_showValidationErrors && _selectedGender == null)
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
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _submitUserInfo,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
        letterSpacing: 0.3,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade50,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppColors.orange, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: Colors.red.shade400, width: 2),
      ),
    );
  }
}
