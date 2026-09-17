import 'package:flutter/material.dart';
import 'package:loan_eligibility/theme/app_theme.dart';

class AssessmentFactorCard extends StatelessWidget {
  final String title;
  final String rating;
  final double score;
  final IconData icon;

  const AssessmentFactorCard({
    super.key,
    required this.title,
    required this.rating,
    required this.score,
    required this.icon,
  });

  Color _getRatingColor() {
    switch (rating.toLowerCase()) {
      case 'strong':
        return AppTheme.successGreen;
      case 'good':
        return Colors.blue;
      case 'moderate':
        return AppTheme.warningOrange;
      case 'poor':
        return AppTheme.errorRed;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ratingColor = _getRatingColor();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppTheme.primaryNavy),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  rating,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ratingColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: score / 100,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(ratingColor),
              borderRadius: BorderRadius.circular(4),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${score.toStringAsFixed(1)} / 100',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
