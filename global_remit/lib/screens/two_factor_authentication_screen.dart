import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/implementation_progress_badge.dart';
import 'dashboard_screen.dart';

class TwoFactorAuthenticationScreen extends StatefulWidget {
  final String phoneNumber;
  final String email;
  final bool isInitialSetup;

  const TwoFactorAuthenticationScreen({
    Key? key,
    required this.phoneNumber,
    required this.email,
    this.isInitialSetup = false,
  }) : super(key: key);

  @override
  _TwoFactorAuthenticationScreenState createState() =>
      _TwoFactorAuthenticationScreenState();
}

class _TwoFactorAuthenticationScreenState
    extends State<TwoFactorAuthenticationScreen> {
  final int _codeLength = 6;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  bool _isLoading = false;
  bool _isResendingCode = false;
  bool _enableResend = false;
  int _resendTimer = 30;
  Timer? _timer;
  String _verificationMethod = 'sms'; // 'sms' or 'email'

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers and focus nodes
    for (int i = 0; i < _codeLength; i++) {
      _controllers.add(TextEditingController());
      _focusNodes.add(FocusNode());
    }
    
    // Start the resend timer
    _startResendTimer();
  }

  @override
  void dispose() {
    // Clean up controllers and focus nodes
    for (int i = 0; i < _codeLength; i++) {
      _controllers[i].dispose();
      _focusNodes[i].dispose();
    }
    
    // Cancel timer
    _timer?.cancel();
    
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _enableResend = false;
      _resendTimer = 30;
    });
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        setState(() {
          _enableResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  Future<void> _verifyCode() async {
    // Get the code from all text fields
    String code = _controllers.map((controller) => controller.text).join();
    
    // Validate code
    if (code.length != _codeLength) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all digits of the verification code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // In a real app, we would call an API to verify the code
      await Future.delayed(const Duration(seconds: 2));

      if (code == '123456') { // Mock verification
        if (!mounted) return;
        if (widget.isInitialSetup) {
          // Navigate to setup complete screen or similar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Two-factor authentication set up successfully'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          // Navigate to dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const DashboardScreen(),
            ),
          );
        }
      } else {
        // Show error message
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid verification code. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        
        // Clear the code fields
        for (var controller in _controllers) {
          controller.clear();
        }
        
        // Set focus to the first field
        FocusScope.of(context).requestFocus(_focusNodes[0]);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error verifying code: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendCode() async {
    if (!_enableResend) return;

    setState(() {
      _isResendingCode = true;
    });

    try {
      // In a real app, this would call an API to resend the code
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;
      
      // Restart the timer
      _startResendTimer();
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verification code sent to ${_verificationMethod == 'sms' ? 'your phone' : 'your email'}'
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error resending code: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isResendingCode = false;
        });
      }
    }
  }

  void _switchVerificationMethod() {
    setState(() {
      _verificationMethod = _verificationMethod == 'sms' ? 'email' : 'sms';
      
      // Clear existing code
      for (var controller in _controllers) {
        controller.clear();
      }
      
      // Reset focus
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    });
    
    // Restart timer and simulate sending new code
    _startResendTimer();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Verification code sent to ${_verificationMethod == 'sms' ? 'your phone' : 'your email'}'
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maskPhone = widget.phoneNumber.replaceRange(
      3,
      widget.phoneNumber.length - 3,
      '****',
    );
    
    final maskEmail = widget.email.replaceRange(
      2,
      widget.email.indexOf('@'),
      '*****',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verification'),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ImplementationProgressBadge(
              currentPhase: 1,
              totalPhases: 7,
              currentStep: 6,
              totalSteps: 7,
              isInProgress: false,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Security icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.security,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Title
                const Text(
                  'Two-Factor Authentication',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                // Description
                Text(
                  _verificationMethod == 'sms'
                    ? 'We\'ve sent a verification code to $maskPhone'
                    : 'We\'ve sent a verification code to $maskEmail',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Code entry fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_codeLength, (index) {
                    return _buildCodeDigitField(index);
                  }),
                ),
                const SizedBox(height: 24),
                
                // Verify button
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Verify',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 16),
                
                // Resend code
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Didn\'t receive the code?'),
                    TextButton(
                      onPressed: _enableResend ? _resendCode : null,
                      child: _isResendingCode
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              _enableResend
                                  ? 'Resend'
                                  : 'Resend in $_resendTimer s',
                            ),
                    ),
                  ],
                ),
                
                // Switch method
                TextButton(
                  onPressed: () => _switchVerificationMethod(),
                  child: Text(
                    _verificationMethod == 'sms'
                        ? 'Send code to my email instead'
                        : 'Send code to my phone instead',
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Security info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Security Note',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Two-factor authentication adds an extra layer of security to your account. Every time you sign in, you\'ll need both your password and a verification code.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
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
    );
  }

  Widget _buildCodeDigitField(int index) {
    return Container(
      width: 45,
      height: 45,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        onChanged: (value) {
          if (value.isNotEmpty) {
            // Auto advance to next field
            if (index < _codeLength - 1) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              // Last digit entered, hide keyboard
              FocusScope.of(context).unfocus();
              
              // Auto verify after short delay
              Future.delayed(const Duration(milliseconds: 200), () {
                _verifyCode();
              });
            }
          } else if (index > 0) {
            // If deleting, go back to previous field
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
      ),
    );
  }
}