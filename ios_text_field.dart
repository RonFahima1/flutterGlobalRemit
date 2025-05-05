import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A text field component that follows iOS design guidelines
/// with animated label and iOS-style interactions
class IOSTextField extends StatefulWidget {
  /// The label text for the field
  final String label;
  
  /// The hint text shown when the field is empty
  final String? placeholder;
  
  /// The controller for the text field
  final TextEditingController? controller;
  
  /// The focus node for the text field
  final FocusNode? focusNode;
  
  /// The keyboard type for the text field
  final TextInputType keyboardType;
  
  /// Whether the text field is obscured (for passwords)
  final bool obscureText;
  
  /// The text input action
  final TextInputAction textInputAction;
  
  /// Callback when text is submitted
  final ValueChanged<String>? onSubmitted;
  
  /// Callback when text changes
  final ValueChanged<String>? onChanged;
  
  /// Validation error message
  final String? errorText;
  
  /// Whether the text field is enabled
  final bool enabled;
  
  /// Maximum number of lines
  final int? maxLines;
  
  /// Minimum number of lines
  final int? minLines;
  
  /// Text input formatters
  final List<TextInputFormatter>? inputFormatters;
  
  /// Prefix widget
  final Widget? prefix;
  
  /// Suffix widget
  final Widget? suffix;
  
  /// Auto-validation mode
  final AutovalidateMode? autovalidateMode;
  
  /// Validator function
  final FormFieldValidator<String>? validator;
  
  /// Text capitalization
  final TextCapitalization textCapitalization;
  
  /// Auto-correct
  final bool autocorrect;
  
  /// Enable suggestions
  final bool enableSuggestions;
  
  /// Content padding
  final EdgeInsetsGeometry? contentPadding;

  const IOSTextField({
    Key? key,
    required this.label,
    this.placeholder,
    this.controller,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.textInputAction = TextInputAction.done,
    this.onSubmitted,
    this.onChanged,
    this.errorText,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.inputFormatters,
    this.prefix,
    this.suffix,
    this.autovalidateMode,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.contentPadding,
  }) : super(key: key);

  @override
  State<IOSTextField> createState() => _IOSTextFieldState();
}

class _IOSTextFieldState extends State<IOSTextField> with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  late AnimationController _animationController;
  late Animation<double> _labelAnimation;
  bool _isFocused = false;
  String? _errorText;
  
  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _controller = widget.controller ?? TextEditingController();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _labelAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    // Initialize animation state based on whether text exists
    if (_controller.text.isNotEmpty) {
      _animationController.value = 1.0;
    }
    
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleTextChange);
  }
  
  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.removeListener(_handleFocusChange);
    _controller.removeListener(_handleTextChange);
    _animationController.dispose();
    super.dispose();
  }
  
  @override
  void didUpdateWidget(IOSTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.errorText != oldWidget.errorText) {
      setState(() {
        _errorText = widget.errorText;
      });
    }
    
    if (widget.focusNode != oldWidget.focusNode) {
      oldWidget.focusNode?.removeListener(_handleFocusChange);
      _focusNode = widget.focusNode ?? _focusNode;
      _focusNode.addListener(_handleFocusChange);
    }
    
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleTextChange);
      _controller = widget.controller ?? _controller;
      _controller.addListener(_handleTextChange);
      
      // Update animation state based on new controller
      if (_controller.text.isNotEmpty) {
        _animationController.value = 1.0;
      } else if (!_isFocused) {
        _animationController.value = 0.0;
      }
    }
  }
  
  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
    
    if (_focusNode.hasFocus) {
      _animationController.forward();
      HapticFeedback.selectionClick();
    } else if (_controller.text.isEmpty) {
      _animationController.reverse();
    }
    
    // Validate on focus lost if autovalidateMode is onUserInteraction
    if (!_focusNode.hasFocus && 
        widget.autovalidateMode == AutovalidateMode.onUserInteraction &&
        widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(_controller.text);
      });
    }
  }
  
  void _handleTextChange() {
    if (_controller.text.isNotEmpty && _animationController.value == 0.0) {
      _animationController.forward();
    } else if (_controller.text.isEmpty && !_isFocused) {
      _animationController.reverse();
    }
    
    if (widget.onChanged != null) {
      widget.onChanged!(_controller.text);
    }
    
    // Validate on text change if autovalidateMode is onUserInteraction
    if (widget.autovalidateMode == AutovalidateMode.onUserInteraction &&
        widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(_controller.text);
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Colors
    final Color primaryColor = Theme.of(context).primaryColor;
    final Color errorColor = Theme.of(context).colorScheme.error;
    final Color backgroundColor = isDark 
        ? const Color(0xFF2C2C2E) // Tertiary background dark
        : const Color(0xFFE5E5EA); // Tertiary background light
    final Color disabledColor = isDark 
        ? Colors.grey[800]! 
        : Colors.grey[300]!;
    
    // Text colors
    final Color labelColor = _isFocused 
        ? primaryColor 
        : (isDark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6));
    final Color textColor = isDark ? Colors.white : Colors.black;
    final Color placeholderColor = isDark 
        ? Colors.white.withOpacity(0.3) 
        : Colors.black.withOpacity(0.3);
    
    // Border colors
    final Color borderColor = _errorText != null 
        ? errorColor 
        : (_isFocused ? primaryColor : Colors.transparent);
    
    // Determine if we should show the error
    final bool hasError = _errorText != null || widget.errorText != null;
    final String? displayErrorText = _errorText ?? widget.errorText;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            // Text field container
            Container(
              decoration: BoxDecoration(
                color: widget.enabled ? backgroundColor : disabledColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: widget.enabled ? borderColor : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  if (widget.prefix != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: widget.prefix!,
                    ),
                  Expanded(
                    child: Padding(
                      padding: widget.contentPadding ?? 
                          EdgeInsets.fromLTRB(
                            widget.prefix != null ? 8 : 16, 
                            24, 
                            widget.suffix != null ? 8 : 16, 
                            16
                          ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: TextStyle(
                          fontSize: 17,
                          color: widget.enabled ? textColor : textColor.withOpacity(0.5),
                          letterSpacing: -0.41,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintText: widget.placeholder,
                          hintStyle: TextStyle(
                            fontSize: 17,
                            color: placeholderColor,
                            letterSpacing: -0.41,
                          ),
                        ),
                        keyboardType: widget.keyboardType,
                        textInputAction: widget.textInputAction,
                        obscureText: widget.obscureText,
                        onSubmitted: widget.onSubmitted,
                        enabled: widget.enabled,
                        maxLines: widget.maxLines,
                        minLines: widget.minLines,
                        inputFormatters: widget.inputFormatters,
                        textCapitalization: widget.textCapitalization,
                        autocorrect: widget.autocorrect,
                        enableSuggestions: widget.enableSuggestions,
                      ),
                    ),
                  ),
                  if (widget.suffix != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: widget.suffix!,
                    ),
                ],
              ),
            ),
            
            // Animated label
            AnimatedBuilder(
              animation: _labelAnimation,
              builder: (context, child) {
                return Positioned(
                  left: 16,
                  top: Tween<double>(
                    begin: 20, // Center position
                    end: 8,   // Top position
                  ).evaluate(_labelAnimation),
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: Tween<double>(
                        begin: 17, // Normal size
                        end: 13,   // Small size
                      ).evaluate(_labelAnimation),
                      color: hasError 
                          ? errorColor 
                          : (_isFocused ? primaryColor : labelColor),
                      fontWeight: _isFocused ? FontWeight.w500 : FontWeight.normal,
                      letterSpacing: -0.41,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        
        // Error text
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              displayErrorText!,
              style: TextStyle(
                fontSize: 13,
                color: errorColor,
                letterSpacing: -0.08,
              ),
            ),
          ),
      ],
    );
  }
}