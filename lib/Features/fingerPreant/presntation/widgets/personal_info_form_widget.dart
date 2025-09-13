import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../stateMangmeant/lang/lang_bloc.dart';

class PersonalInfoFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;

  const PersonalInfoFormWidget({
    super.key,
    required this.nameController,
    required this.emailController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangBloc, LangState>(
      builder: (context, langState) {
        bool isEnglish = true;
        if (langState is LangChanged) {
          isEnglish = langState.isEnglish;
        }

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEnglish ? 'Personal Information' : 'المعلومات الشخصية',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 20),

              // Name field
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: isEnglish ? 'Full Name *' : 'الاسم الكامل *',
                  hintText:
                      isEnglish ? 'Enter your full name' : 'أدخل اسمك الكامل',
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Color(0xFF667EEA),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF667EEA),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return isEnglish
                        ? 'Please enter your full name'
                        : 'يرجى إدخال اسمك الكامل';
                  }
                  if (value.trim().length < 2) {
                    return isEnglish
                        ? 'Name must be at least 2 characters long'
                        : 'يجب أن يكون الاسم على الأقل حرفين';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email field
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText:
                      isEnglish
                          ? 'Email Address *'
                          : 'عنوان البريد الإلكتروني *',
                  hintText:
                      isEnglish
                          ? 'Enter your email address'
                          : 'أدخل عنوان بريدك الإلكتروني',
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Color(0xFF667EEA),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF667EEA),
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return isEnglish
                        ? 'Please enter your email address'
                        : 'يرجى إدخال عنوان بريدك الإلكتروني';
                  }
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(value)) {
                    return isEnglish
                        ? 'Please enter a valid email address'
                        : 'يرجى إدخال عنوان بريد إلكتروني صالح';
                  }
                  return null;
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
