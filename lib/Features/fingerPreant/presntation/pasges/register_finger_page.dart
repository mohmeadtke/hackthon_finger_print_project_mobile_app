import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entity/finger_print_entity.dart';
import '../stateMangmeant/bloc/finger_bloc.dart';
import '../stateMangmeant/lang/lang_bloc.dart';
import '../stateMangmeant/lang/app_strings.dart';
import '../widgets/image_picker_widget.dart';
import '../widgets/personal_info_form_widget.dart';
import 'startup_page.dart';

class FingerPage extends StatefulWidget {
  const FingerPage({super.key});

  @override
  State<FingerPage> createState() => _FingerPageState();
}

class _FingerPageState extends State<FingerPage> with TickerProviderStateMixin {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _nameController.addListener(() => setState(() {}));
    _emailController.addListener(() => setState(() {}));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  void _showImageSourceDialog(bool isEnglish) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppStrings.selectImageSource(isEnglish),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSourceOption(
                      icon: Icons.camera_alt,
                      label: AppStrings.camera(isEnglish),
                      color: const Color(0xFF3498DB),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    _buildSourceOption(
                      icon: Icons.photo_library,
                      label: AppStrings.gallery(isEnglish),
                      color: const Color(0xFF9B59B6),
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendFingerprint() {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Please fill in all required fields');
      return;
    }

    if (_selectedImage != null) {
    
      context.read<FingerBloc>().add(
        RegisterFingerEvent(
          fingerPrintEntity: FingerPrintEntity(
            name: _nameController.text,
            email: _emailController.text,
            fingerPrintImage: _selectedImage!,
          ),
        ),
      );
    } else {
      _showErrorSnackBar('Please select an image first');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFFE74C3C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: const Color(0xFF27AE60),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildSimpleCircle(bool isCompleted) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted ? const Color(0xFF27AE60) : Colors.grey[300],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangBloc, LangState>(
      builder: (context, langState) {
        bool isEnglish = true;
        if (langState is LangChanged) {
          isEnglish = langState.isEnglish;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FA),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              AppStrings.fingerprintScanner(isEnglish),
              style: const TextStyle(
                color: Color(0xFF2C3E50),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: BlocListener<FingerBloc, FingerState>(
            listener: (context, state) {
              if (state is FingerSuccess) {
                _showSuccessSnackBar(AppStrings.success(isEnglish));
                setState(() {
                  _selectedImage = null;
                });

                if (state.message.contains("Fingerprint uploaded") &&
                    state.message.contains("successfully")) {
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const StartupPage(),
                        ),
                      );
                    }
                  });
                }
              } else if (state is FingerFailure) {
                _showErrorSnackBar(state.errorMessage);
              }
            },
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),

                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF667EEA),
                                    Color(0xFF764BA2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xFF667EEA,
                                    ).withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.fingerprint,
                                    size: 64,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    AppStrings.secureAnalysis(isEnglish),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    AppStrings.uploadDescription(isEnglish),
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 32),

                            PersonalInfoFormWidget(
                              nameController: _nameController,
                              emailController: _emailController,
                            ),

                            const SizedBox(height: 32),

                            ImagePickerWidget(
                              selectedImage: _selectedImage,
                              onTap: () => _showImageSourceDialog(isEnglish),
                            ),

                            const SizedBox(height: 32),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildSimpleCircle(
                                  _nameController.text.isNotEmpty,
                                ),
                                const SizedBox(width: 12),
                                _buildSimpleCircle(
                                  _emailController.text.isNotEmpty,
                                ),
                                const SizedBox(width: 12),
                                _buildSimpleCircle(_selectedImage != null),
                              ],
                            ),

                            const SizedBox(height: 20),

                            BlocBuilder<FingerBloc, FingerState>(
                              builder: (context, state) {
                                final isLoading = state is FingerLoading;
                                final hasAllRequiredData =
                                    _selectedImage != null &&
                                    _nameController.text.isNotEmpty &&
                                    _emailController.text.isNotEmpty;

                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed:
                                        (isLoading || !hasAllRequiredData)
                                            ? null
                                            : _sendFingerprint,
                                    icon:
                                        isLoading
                                            ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Colors.white),
                                              ),
                                            )
                                            : const Icon(Icons.send),
                                    label: Text(
                                      isLoading
                                          ? AppStrings.processing(isEnglish)
                                          : hasAllRequiredData
                                          ? AppStrings.sendFingerprintData(
                                            isEnglish,
                                          )
                                          : AppStrings.completeAllFields(
                                            isEnglish,
                                          ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          hasAllRequiredData
                                              ? const Color(0xFF27AE60)
                                              : Colors.grey[400],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      elevation: hasAllRequiredData ? 2 : 0,
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            BlocBuilder<FingerBloc, FingerState>(
                              builder: (context, state) {
                                if (state is FingerLoading) {
                                  return Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFF39C12,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(
                                          0xFFF39C12,
                                        ).withOpacity(0.3),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Color(0xFFF39C12),
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            AppStrings.processing(isEnglish),
                                            style: const TextStyle(
                                              color: Color(0xFFF39C12),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
