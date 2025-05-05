import 'package:flutter/material.dart';

class DeliveryOptionSelector extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final Function(String) onOptionSelected;

  const DeliveryOptionSelector({
    Key? key,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (options.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            'No delivery options available for this destination',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Column(
      children: options.map((option) {
        final isSelected = selectedOption == option;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? const Color(0xFF0066CC) : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? const Color(0xFFF0F7FF) : Colors.white,
          ),
          child: InkWell(
            onTap: () => onOptionSelected(option),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFDCEAFF) : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIconForDeliveryOption(option),
                      color: isSelected ? const Color(0xFF0066CC) : Colors.grey.shade600,
                      size: 18,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Option text
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                        color: isSelected ? const Color(0xFF0066CC) : Colors.black87,
                      ),
                    ),
                  ),
                  
                  // Radio button
                  Radio<String>(
                    value: option,
                    groupValue: selectedOption,
                    onChanged: (value) {
                      if (value != null) {
                        onOptionSelected(value);
                      }
                    },
                    activeColor: const Color(0xFF0066CC),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
  
  IconData _getIconForDeliveryOption(String option) {
    final lowerOption = option.toLowerCase();
    
    if (lowerOption.contains('instant')) {
      return Icons.flash_on_outlined;
    } else if (lowerOption.contains('express')) {
      return Icons.speed_outlined;
    } else if (lowerOption.contains('imps') || lowerOption.contains('rtgs') || lowerOption.contains('neft')) {
      return Icons.swap_horiz;
    } else if (lowerOption.contains('standard')) {
      return Icons.access_time_outlined;
    } else {
      return Icons.local_shipping_outlined;
    }
  }
}
