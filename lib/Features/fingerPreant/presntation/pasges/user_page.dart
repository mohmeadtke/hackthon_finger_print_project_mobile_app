import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackthon_app/Features/fingerPreant/data/dataSource/check_the%20token_data_source.dart';
import 'package:hackthon_app/Features/fingerPreant/domain/entity/user_entity.dart';
import 'package:hackthon_app/core/storage/local_storage.dart';
import '../stateMangmeant/lang/lang_bloc.dart';
import '../stateMangmeant/lang/app_strings.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  UserEntity? user;
  bool isLoading = true;
  String? errorMessage;

  final CheckTheTokenDataSource _dataSource = CheckTheTokenDataSource();
  final LocalStorageImpl _localStorage = LocalStorageImpl();

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _fadeController.forward();
    _slideController.forward();

    _loadUserData();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final token = await _localStorage.getToken();
      if (token == null) {
        setState(() {
          isLoading = false;
          errorMessage = "No token found. Please login again.";
        });
        return;
      }

      // Call API to get user data
      final result = await _dataSource.getMe(token);

      result.fold(
        (failure) {
          setState(() {
            isLoading = false;
            errorMessage = failure.message;
          });
        },
        (userData) {
          setState(() {
            isLoading = false;
            user = userData;
          });
        },
      );
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error loading user data: $e";
      });
    }
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
          backgroundColor: const Color(0xFF0F172A),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
           
            title: Text(
              AppStrings.profile(isEnglish),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: _buildBody(isEnglish),
        );
      },
    );
  }

  Widget _buildBody(bool isEnglish) {
    if (isLoading) {
      return _buildLoadingWidget(isEnglish);
    } else if (user != null) {
      return _buildUserProfile(user!, isEnglish);
    } else {
      return _buildErrorWidget(
        errorMessage ?? AppStrings.unknownError(isEnglish),
        isEnglish,
      );
    }
  }

  Widget _buildLoadingWidget(bool isEnglish) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const CircularProgressIndicator(
              color: Color(0xFF3B82F6),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.loadingProfile(isEnglish),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfile(UserEntity user, bool isEnglish) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                  ),
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.person, size: 60, color: Colors.white),
              ),

              const SizedBox(height: 32),

              _buildInfoCard(
                icon: Icons.person_outline,
                title: AppStrings.fullName(isEnglish),
                value: user.name,
                color: const Color(0xFF10B981),
              ),

              const SizedBox(height: 16),

              _buildInfoCard(
                icon: Icons.email_outlined,
                title: AppStrings.emailAddress(isEnglish),
                value: user.email,
                color: const Color(0xFF3B82F6),
              ),

              const Spacer(),

              ElevatedButton.icon(
                onPressed: () async {
                  await _localStorage.removeToken();
                  if (mounted) {
                    Navigator.of(
                      context,
                    ).pushNamedAndRemoveUntil('/home', (route) => false);
                  }
                },
                icon: const Icon(Icons.logout),
                label: Text(AppStrings.logout(isEnglish)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.security, color: Colors.amber[300], size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        AppStrings.securityInfo(isEnglish),
                        style: TextStyle(
                          color: Colors.amber[200],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message, bool isEnglish) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppStrings.errorLoadingProfile(isEnglish),
              style: TextStyle(
                color: Colors.red[300],
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _loadUserData();
              },
              icon: const Icon(Icons.refresh),
              label: Text(AppStrings.retry(isEnglish)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
