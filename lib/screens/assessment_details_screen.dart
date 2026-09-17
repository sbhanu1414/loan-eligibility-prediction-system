import 'package:flutter/material.dart';
import 'package:loan_eligibility/models/prediction_result.dart';
import 'package:loan_eligibility/widgets/assessment_factor_card.dart';
import 'package:loan_eligibility/theme/app_theme.dart';

class AssessmentDetailsScreen extends StatelessWidget {
  final PredictionResult result;
  final VoidCallback onNewAssessment;

  const AssessmentDetailsScreen({
    super.key,
    required this.result,
    required this.onNewAssessment,
  });

  IconData _getIconForFactor(String factor) {
    switch (factor) {
      case 'Credit Profile':
        return Icons.credit_score_outlined;
      case 'Income Profile':
        return Icons.account_balance_wallet_outlined;
      case 'Existing Debt':
        return Icons.payment_outlined;
      case 'Loan Amount':
        return Icons.currency_rupee;
      case 'Employment Stability':
        return Icons.work_outline;
      default:
        return Icons.analytics_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final factors = [
      'Credit Score',
      'Annual Income',
      'Existing Debt',
      'Employment Type',
      'Loan Amount',
      'Loan Tenure',
      'Dependents',
      'Education',
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Assessment Details',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryNavy,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Detailed breakdown of screening parameters and profile scores',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Text(
                'Profile Assessment',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryNavy,
                ),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  final int crossAxisCount = constraints.maxWidth > 520 ? 2 : 1;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      mainAxisExtent: 135,
                    ),
                    itemCount: result.profileBreakdown.length,
                    itemBuilder: (context, index) {
                      final key = result.profileBreakdown.keys.elementAt(index);
                      final rating = result.profileBreakdown[key]!;
                      final score = result.factorScores[key] ?? 75.0;

                      return AssessmentFactorCard(
                        title: key,
                        rating: rating,
                        score: score,
                        icon: _getIconForFactor(key),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                'Assessment Factors',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryNavy,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Features evaluated by the screening model:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: factors
                    .map((factor) => Chip(
                          avatar: const Icon(Icons.check, size: 16, color: AppTheme.primaryNavy),
                          label: Text(
                            factor,
                            style: const TextStyle(
                              color: AppTheme.primaryNavy,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          backgroundColor: AppTheme.primaryNavy.withValues(alpha: 0.06),
                          side: BorderSide(
                            color: AppTheme.primaryNavy.withValues(alpha: 0.2),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.amber.shade900,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'These represent input features evaluated during assessment. Quantitative ML feature importance (SHAP / coefficients) will be available once the Python ML API service is connected.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.amber.shade900,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 36),
              Center(
                child: SizedBox(
                  width: 260,
                  height: 50,
                  child: FilledButton.icon(
                    onPressed: onNewAssessment,
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Start New Assessment'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

