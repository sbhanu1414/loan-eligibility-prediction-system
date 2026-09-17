import 'package:flutter/material.dart';
import 'package:loan_eligibility/models/prediction_result.dart';
import 'package:loan_eligibility/theme/app_theme.dart';

class ResultCard extends StatelessWidget {
  final PredictionResult result;

  const ResultCard({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEligible = result.isEligible;
    final Color color = isEligible ? AppTheme.successGreen : AppTheme.errorRed;
    final Color bgColor = isEligible 
        ? AppTheme.successGreen.withValues(alpha: 0.08) 
        : AppTheme.errorRed.withValues(alpha: 0.08);
    
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              isEligible ? Icons.verified : Icons.cancel_outlined,
              color: color,
              size: 54,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isEligible ? 'ELIGIBLE' : 'NOT ELIGIBLE',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${(result.probability * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.primaryNavy,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Eligibility Probability',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline, size: 16, color: AppTheme.primaryNavy),
                const SizedBox(width: 6),
                Text(
                  'Model Prediction (NOT Bank Approval)',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryNavy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

