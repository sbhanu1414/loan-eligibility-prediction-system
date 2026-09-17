import 'package:flutter/material.dart';
import 'package:loan_eligibility/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onStartAssessment;
  final VoidCallback? onViewDashboard;

  const HomeScreen({
    super.key,
    required this.onStartAssessment,
    this.onViewDashboard,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 680),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const _FinanceIllustration(),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryNavy.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primaryNavy.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.accentBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Academic Decision Support Prototype',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: AppTheme.primaryNavy,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Loan Eligibility Prediction System',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryNavy,
                          letterSpacing: -0.5,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'ML-powered initial loan eligibility assessment',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 28),
                  Card(
                    elevation: 0,
                    color: const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.psychology_outlined,
                              color: AppTheme.primaryNavy,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Evaluate applicant information and receive an ML-based eligibility prediction.',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF1E293B),
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: onStartAssessment,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text(
                        'Start Assessment',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (onViewDashboard != null)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: onViewDashboard,
                        icon: const Icon(Icons.dashboard_outlined),
                        label: const Text('View Analytics Dashboard'),
                      ),
                    ),
                  const SizedBox(height: 24),
                  Text(
                    'Decision-support prototype — final approval requires bank verification.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                  const SizedBox(height: 20),
                  Chip(
                    avatar: const Icon(Icons.science_outlined, size: 16, color: AppTheme.primaryNavy),
                    label: const Text('Demo Mode Active'),
                    backgroundColor: Colors.grey.shade100,
                    side: BorderSide(color: Colors.grey.shade300),
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

class _FinanceIllustration extends StatelessWidget {
  const _FinanceIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 190,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background soft circles
          Container(
            width: 170,
            height: 170,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryNavy.withValues(alpha: 0.05),
            ),
          ),
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryNavy.withValues(alpha: 0.12),
            ),
          ),
          // Main Banking Center Icon
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppTheme.primaryNavy,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryNavy.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.account_balance,
              size: 46,
              color: Colors.white,
            ),
          ),
          // Floating fintech badges
          Positioned(
            top: 12,
            left: 14,
            child: _buildBadge(Icons.credit_score, AppTheme.successGreen),
          ),
          Positioned(
            top: 24,
            right: 12,
            child: _buildBadge(Icons.trending_up, AppTheme.accentBlue),
          ),
          Positioned(
            bottom: 16,
            left: 24,
            child: _buildBadge(Icons.analytics_outlined, AppTheme.warningOrange),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: _buildBadge(Icons.security, AppTheme.primaryNavy),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 18,
        color: color,
      ),
    );
  }
}

