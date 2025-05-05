import 'package:flutter/material.dart';

/// A widget that displays the implementation progress of a feature.
/// Used to track development status across the app.
class ImplementationProgressBadge extends StatelessWidget {
  /// The current phase number (e.g., 1 for Phase 1)
  final int currentPhase;
  
  /// The total number of phases
  final int totalPhases;
  
  /// The current step number within the phase
  final int currentStep;
  
  /// The total number of steps within the phase
  final int totalSteps;
  
  /// Whether the feature is currently in development
  final bool isInProgress;

  const ImplementationProgressBadge({
    Key? key,
    required this.currentPhase,
    required this.totalPhases,
    required this.currentStep,
    required this.totalSteps,
    required this.isInProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String text = isInProgress 
        ? 'In Progress' 
        : 'Implemented';
    
    final Color backgroundColor = isInProgress
        ? Colors.amber.withOpacity(0.2)
        : Colors.green.withOpacity(0.2);
    
    final Color textColor = isInProgress
        ? Colors.amber[800]!
        : Colors.green[800]!;

    return Tooltip(
      message: 'Phase $currentPhase/$totalPhases - Step $currentStep/$totalSteps',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isInProgress ? Icons.pending : Icons.check_circle,
              size: 12.0,
              color: textColor,
            ),
            const SizedBox(width: 4.0),
            Text(
              text,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A widget that displays overall implementation progress of the app.
class AppImplementationProgress extends StatelessWidget {
  /// The number of completed screens
  final int completedScreens;
  
  /// The total number of screens to implement
  final int totalScreens;

  const AppImplementationProgress({
    Key? key,
    required this.completedScreens,
    required this.totalScreens,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentage = (completedScreens / totalScreens * 100).round();

    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Implementation Progress',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    '$percentage%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              '$completedScreens out of $totalScreens screens completed',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.0,
              ),
            ),
            const SizedBox(height: 8.0),
            LinearProgressIndicator(
              value: completedScreens / totalScreens,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
              minHeight: 8.0,
              borderRadius: BorderRadius.circular(4.0),
            ),
          ],
        ),
      ),
    );
  }
}