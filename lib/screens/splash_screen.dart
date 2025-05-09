import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Timer _timeoutTimer;

  @override
  void initState() {
    super.initState();
    
    // Set up animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    _animationController.forward();
    
    // Add a timeout to prevent infinite loading
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      _navigateToNextScreen(isTimeout: true);
    });
    
    // Check authentication status after animations play
    Timer(const Duration(seconds: 2), _checkAuthAndNavigate);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timeoutTimer.cancel();
    super.dispose();
  }

  Future<void> _checkAuthAndNavigate() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Check if user is already logged in
      final isLoggedIn = await authProvider.isLoggedIn();
      
      // If we haven't timed out yet, navigate accordingly
      if (_timeoutTimer.isActive) {
        _navigateToNextScreen(isLoggedIn: isLoggedIn);
      }
    } catch (e) {
      // If there's an error, navigate to login screen
      if (_timeoutTimer.isActive) {
        _navigateToNextScreen(isError: true);
      }
      debugPrint('Error in splash screen: $e');
    }
  }

  void _navigateToNextScreen({bool isLoggedIn = false, bool isTimeout = false, bool isError = false}) {
    // Cancel the timeout timer if it's still active
    if (_timeoutTimer.isActive) {
      _timeoutTimer.cancel();
    }
    
    // Only navigate if the widget is still mounted
    if (!mounted) return;

    if (isTimeout || isError) {
      // On timeout or error, just go to login
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    // Normal flow: Check if logged in
    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App logo
              Image.asset(
                isDark ? 'assets/images/logo-light.svg.png' : 'assets/images/logo-dark.svg.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 24),
              
              // App name
              Text(
                'Global Remit',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // App Tagline
              Text(
                'Send money globally, instantly',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.normal,
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Loading indicator
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
