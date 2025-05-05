import 'package:flutter/material.dart';
import '../models/transfer_method.dart';

class TransferMethodSelector extends StatelessWidget {
  final List<TransferMethod> methods;
  final TransferMethod? selectedMethod;
  final Function(TransferMethod) onMethodSelected;

  const TransferMethodSelector({
    Key? key,
    required this.methods,
    required this.selectedMethod,
    required this.onMethodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (methods.isEmpty) {
      return const Center(
        child: Text('No transfer methods available'),
      );
    }

    return Column(
      children: methods.map((method) => _buildMethodCard(method)).toList(),
    );
  }
  
  Widget _buildMethodCard(TransferMethod method) {
    final bool isSelected = selectedMethod?.id == method.id;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
        onTap: () => onMethodSelected(method),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Method icon with circular background
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE6F0FF) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  method.icon,
                  color: isSelected ? const Color(0xFF0066CC) : Colors.grey.shade700,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Method details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          method.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? const Color(0xFF0066CC) : Colors.black87,
                          ),
                        ),
                        if (method.isPopular) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFB800),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Popular',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fee: \$${method.fee.toStringAsFixed(2)} • ${method.estimatedTime}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (method.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        method.description!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // Checkmark for selected method
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF0066CC),
                  size: 24,
                )
              else
                Icon(
                  Icons.circle_outlined,
                  color: Colors.grey.shade400,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}