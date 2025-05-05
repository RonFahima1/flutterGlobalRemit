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
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: Text(
            'No delivery options available for this destination',
            style: TextStyle(
              color: Colors.grey,
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
        
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isSelected ? const Color(0xFF0066CC) : Colors.grey.shade300,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          color: isSelected ? const Color(0xFFF0F7FF) : Colors.white,
          child: InkWell(
            onTap: () => onOptionSelected(option),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Option icon based on delivery type
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFE6F0FF) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      _getIconForDeliveryOption(option),
                      color: isSelected ? const Color(0xFF0066CC) : Colors.grey.shade700,
                      size: 20,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Option text
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
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
      return Icons.flash_on;
    } else if (lowerOption.contains('express')) {
      return Icons.directions_run;
    } else if (lowerOption.contains('imps') || lowerOption.contains('rtgs') || lowerOption.contains('neft')) {
      return Icons.swap_horiz;
    } else {
      return Icons.schedule;  // Standard delivery
    }
  }
}