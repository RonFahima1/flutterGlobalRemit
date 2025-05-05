import 'package:flutter/material.dart';
import '../models/beneficiary.dart';

/// A widget for selecting a beneficiary from a list of beneficiaries
class BeneficiarySelector extends StatelessWidget {
  final List<Beneficiary> beneficiaries;
  final Beneficiary? selectedBeneficiary;
  final Function(Beneficiary) onBeneficiarySelected;
  final bool isLoading;

  const BeneficiarySelector({
    Key? key,
    required this.beneficiaries,
    required this.selectedBeneficiary,
    required this.onBeneficiarySelected,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (beneficiaries.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_outline, size: 40, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'No beneficiaries yet',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add a new beneficiary to continue',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: beneficiaries.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          color: Colors.grey.shade300,
        ),
        itemBuilder: (context, index) {
          final beneficiary = beneficiaries[index];
          final isSelected = selectedBeneficiary?.id == beneficiary.id;
          
          return InkWell(
            onTap: () => onBeneficiarySelected(beneficiary),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF0F7FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        beneficiary.name.isNotEmpty ? beneficiary.name[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0066CC),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          beneficiary.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          beneficiary.accountNumber,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Radio<String>(
                    value: beneficiary.id,
                    groupValue: selectedBeneficiary?.id,
                    onChanged: (_) => onBeneficiarySelected(beneficiary),
                    activeColor: const Color(0xFF0066CC),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}