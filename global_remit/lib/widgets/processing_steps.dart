import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ProcessingSteps extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const ProcessingSteps({
    Key? key,
    required this.currentStep,
    required this.steps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        // If even, it's a step indicator
        if (index % 2 == 0) {
          final stepIndex = index ~/ 2;
          final isActive = stepIndex <= currentStep;
          final isCurrentStep = stepIndex == currentStep;
          
          return Expanded(
            child: Column(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? AppColors.primary : Colors.grey[300],
                    border: isCurrentStep
                        ? Border.all(color: AppColors.accent, width: 2)
                        : null,
                  ),
                  child: Center(
                    child: isActive
                        ? Icon(
                            stepIndex < currentStep
                                ? Icons.check
                                : Icons.circle,
                            color: Colors.white,
                            size: 14,
                          )
                        : Text(
                            '${stepIndex + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  steps[stepIndex],
                  style: TextStyle(
                    color: isActive ? AppColors.primary : Colors.grey,
                    fontWeight:
                        isCurrentStep ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        } else {
          // It's a connector line
          final previousStepIndex = index ~/ 2;
          final isActive = previousStepIndex < currentStep;
          
          return Expanded(
            child: Container(
              height: 2,
              color: isActive ? AppColors.primary : Colors.grey[300],
            ),
          );
        }
      }),
    );
  }
}