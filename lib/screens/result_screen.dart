import 'package:flutter/material.dart';
import 'package:loan_eligibility/models/prediction_result.dart';
import 'package:loan_eligibility/models/applicant.dart';
import 'package:loan_eligibility/models/loan_application.dart';
import 'package:loan_eligibility/widgets/result_card.dart';
import 'package:loan_eligibility/widgets/summary_card.dart';
import 'package:loan_eligibility/theme/app_theme.dart';

String _formatCurrency(double amount) {
  final int intAmount = amount.toInt();
  if (intAmount <= 0) return '₹0';
  final String s = intAmount.toString();
  if (s.length <= 3) return '₹$s';
  final String last3 = s.substring(s.length - 3);
  String leading = s.substring(0, s.length - 3);
  final buffer = StringBuffer();
  for (int i = 0; i < leading.length; i++) {
    if ((leading.length - i) % 2 == 0 && i != 0) {
      buffer.write(',');
    }
    buffer.write(leading[i]);
  }
  return '₹$buffer,$last3';
}

class ResultScreen extends StatelessWidget {
  final PredictionResult result;
  final Applicant applicant;
  final LoanApplication application;
  final VoidCallback onViewDetails;
  final VoidCallback onNewAssessment;

  const ResultScreen({
    super.key,
    required this.result,
    required this.applicant,
    required this.application,
    required this.onViewDetails,
    required this.onNewAssessment,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Loan Assessment Result',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryNavy,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                'Automated initial screening decision-support output',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ResultCard(result: result),
              const SizedBox(height: 24),
              SummaryCard(
                title: 'Applicant Summary',
                items: {
                  'Applicant': applicant.fullName,
                  'Credit Score': application.creditScore.toString(),
                  'Annual Income': _formatCurrency(application.annualIncome),
                  'Requested Loan': _formatCurrency(application.requestedAmount),
                  'Loan Type': application.loanType,
                },
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Key Factors',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryNavy,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (result.positiveFactors.isNotEmpty) ...[
                        Text(
                          'Positive Factors',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.successGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...result.positiveFactors.map((factor) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppTheme.successGreen,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      factor,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 12),
                      ],
                      if (result.concerns.isNotEmpty) ...[
                        Text(
                          'Potential Concerns',
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.warningOrange,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...result.concerns.map((concern) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    color: AppTheme.warningOrange,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      concern,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryNavy.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppTheme.primaryNavy.withValues(alpha: 0.15),
                  ),
                ),
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.lightbulb_outline,
                      color: AppTheme.primaryNavy,
                      size: 24,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recommendation',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryNavy,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            result.recommendation,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF1E293B),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onViewDetails,
                      icon: const Icon(Icons.analytics_outlined),
                      label: const Text('View Assessment Details'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onNewAssessment,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Start New Assessment'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined, size: 18, color: Colors.amber.shade900),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Academic Prototype Notice: This prediction is for decision-support evaluation only. Final approval requires institutional verification.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.amber.shade900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

