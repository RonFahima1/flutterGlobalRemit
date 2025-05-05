import 'package:flutter/material.dart';
import '../widgets/implementation_progress_badge.dart';
import 'login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({Key? key}) : super(key: key);

  @override
  _OnboardingScreensState createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 4;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to Global Remit',
      description: 'The easiest way to send money worldwide with competitive rates and fast delivery.',
      image: 'assets/images/onboarding_globe.png',
      color: Colors.blue[700]!,
      icon: Icons.public,
    ),
    OnboardingPage(
      title: 'Fast & Secure Transfers',
      description: 'Send money to friends and family with just a few taps. Secure and reliable, every time.',
      image: 'assets/images/onboarding_security.png',
      color: Colors.green[700]!,
      icon: Icons.security,
    ),
    OnboardingPage(
      title: 'Multiple Payment Options',
      description: 'Bank transfers, mobile money, cash pickup, and QR code payments - we've got you covered.',
      image: 'assets/images/onboarding_payment.png',
      color: Colors.orange[700]!,
      icon: Icons.payment,
    ),
    OnboardingPage(
      title: 'Track Your Transfers',
      description: 'Real-time updates for all your transactions. Know exactly when your money arrives.',
      image: 'assets/images/onboarding_track.png',
      color: Colors.purple[700]!,
      icon: Icons.track_changes,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasCompletedOnboarding', true);
  }

  void _onNextPressed() {
    if (_currentPage < _numPages - 1) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() async {
    await _markOnboardingComplete();
    if (!mounted) return;
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Skip button
          TextButton(
            onPressed: _finishOnboarding,
            child: const Text(
              'Skip',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: ImplementationProgressBadge(
              currentPhase: 1,
              totalPhases: 7,
              currentStep: 5,
              totalSteps: 7,
              isInProgress: false,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Page view
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _buildPage(_pages[index]);
              },
            ),
          ),
          
          // Bottom navigation
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Page indicator
                Row(
                  children: _buildPageIndicator(),
                ),
                
                // Next button
                ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32.0,
                      vertical: 16.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    _currentPage < _numPages - 1 ? 'Next' : 'Get Started',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image or icon
          page.image != null
              ? Image.asset(
                  page.image!,
                  height: 220.0,
                )
              : Container(
                  width: 180.0,
                  height: 180.0,
                  decoration: BoxDecoration(
                    color: page.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(90.0),
                  ),
                  child: Icon(
                    page.icon,
                    size: 100.0,
                    color: page.color,
                  ),
                ),
          const SizedBox(height: 48.0),
          
          // Title
          Text(
            page.title,
            style: const TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16.0),
          
          // Description
          Text(
            page.description,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _numPages; i++) {
      indicators.add(
        Container(
          width: i == _currentPage ? 16.0 : 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            color: i == _currentPage 
                ? Theme.of(context).primaryColor 
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      );
    }
    return indicators;
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final String? image;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    this.image,
    required this.icon,
    required this.color,
  });
}