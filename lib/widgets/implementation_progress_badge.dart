import 'package:flutter/material.dart';
import '../utils/progress_tracker.dart';

/// A widget that displays the implementation status of a screen
class ImplementationProgressBadge extends StatelessWidget {
  final int screenNumber;
  final bool showText;
  final bool large;

  const ImplementationProgressBadge({
    Key? key,
    required this.screenNumber,
    this.showText = true,
    this.large = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String statusText = AppProgressTracker.getScreenStatusText(screenNumber);
    final Color statusColor = AppProgressTracker.getScreenStatusColor(screenNumber);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Status icon
        AppProgressTracker.getScreenStatusIcon(screenNumber),
        
        // Status text (optional)
        if (showText) ...[
          const SizedBox(width: 6),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: large ? 8 : 6,
              vertical: large ? 4 : 2,
            ),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: Colors.white,
                fontSize: large ? 12 : 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          
          // Screen number (only if showing text and large version)
          if (large) ...[
            const SizedBox(width: 8),
            Text(
              'Screen #$screenNumber',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ],
    );
  }
}

/// A widget that displays the overall implementation progress
class ImplementationProgressOverview extends StatelessWidget {
  final bool compact;

  const ImplementationProgressOverview({
    Key? key, 
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined, color: Color(0xFF0066CC)),
              const SizedBox(width: 8),
              Text(
                'Global Remit Implementation',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: compact ? 15 : 16,
                  color: const Color(0xFF0066CC),
                ),
              ),
            ],
          ),
          
          if (!compact) const SizedBox(height: 16),
          
          // Overall progress
          Row(
            children: [
              Text(
                'Overall Progress:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: compact ? 13 : 14,
                  color: Colors.grey.shade800,
                ),
              ),
              const Spacer(),
              Text(
                '${AppProgressTracker.completedScreens}/${AppProgressTracker.totalScreens} screens',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: compact ? 13 : 14,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Progress bar
          _buildProgressBar(AppProgressTracker.getOverallCompletionPercentage(), const Color(0xFF0066CC)),
          
          if (!compact) ...[
            const SizedBox(height: 16),
            
            // Phase progress sections
            ...AppProgressTracker.phases.entries.map((phase) => _buildPhaseProgress(
              phase.key, 
              AppProgressTracker.getPhaseCompletionPercentage(phase.key),
              phase.value.length,
              compact,
            )),
          ],
          
          // Legend (only in non-compact mode)
          if (!compact) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                _buildLegendItem(
                  icon: Icons.check_circle,
                  color: Colors.green,
                  label: 'Completed',
                ),
                const SizedBox(width: 16),
                _buildLegendItem(
                  icon: Icons.pending,
                  color: const Color(0xFFFFB800),
                  label: 'In Progress',
                ),
                const SizedBox(width: 16),
                _buildLegendItem(
                  icon: Icons.circle_outlined,
                  color: Colors.grey,
                  label: 'Pending',
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
  
  Widget _buildProgressBar(double value, Color color) {
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Stack(
        children: [
          FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            right: 2,
            top: 0,
            bottom: 0,
            child: Center(
              child: Text(
                '${(value * 100).toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPhaseProgress(String phaseName, double progress, int totalScreens, bool compact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              progress >= 1.0 ? Icons.check_circle : Icons.horizontal_split,
              size: compact ? 14 : 16,
              color: progress >= 1.0 ? Colors.green : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                phaseName,
                style: TextStyle(
                  fontSize: compact ? 12 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: compact ? 12 : 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        _buildProgressBar(progress, 
          progress >= 1.0 ? Colors.green : 
          progress > 0 ? const Color(0xFFFFB800) : 
          Colors.grey
        ),
        const SizedBox(height: 12),
      ],
    );
  }
  
  Widget _buildLegendItem({required IconData icon, required Color color, required String label}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}