import 'package:flutter/material.dart';
import 'package:loan_eligibility/theme/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  final VoidCallback? onStartNewAssessment;

  const DashboardScreen({super.key, this.onStartNewAssessment});

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Analytics Dashboard',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryNavy,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Aggregated model prediction activity and metrics',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                  Chip(
                    avatar: const Icon(Icons.token_outlined, size: 16, color: AppTheme.accentBlue),
                    label: const Text('Demo Data'),
                    backgroundColor: AppTheme.primaryNavy.withValues(alpha: 0.06),
                    side: BorderSide(color: AppTheme.primaryNavy.withValues(alpha: 0.2)),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Top Section - Stat Cards
              if (isDesktop)
                Row(
                  children: [
                    Expanded(child: _buildStatCard('Total Assessments', '128', Icons.assessment_outlined, AppTheme.primaryNavy)),
                    const SizedBox(width: 14),
                    Expanded(child: _buildStatCard('Eligible Predictions', '82', Icons.check_circle_outline, AppTheme.successGreen)),
                    const SizedBox(width: 14),
                    Expanded(child: _buildStatCard('Not Eligible Predictions', '46', Icons.cancel_outlined, AppTheme.errorRed)),
                    const SizedBox(width: 14),
                    Expanded(child: _buildStatCard('Average Prediction Score', '76%', Icons.analytics_outlined, AppTheme.warningOrange)),
                  ],
                )
              else
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildStatCard('Total Assessments', '128', Icons.assessment_outlined, AppTheme.primaryNavy)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('Eligible', '82', Icons.check_circle_outline, AppTheme.successGreen)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildStatCard('Not Eligible', '46', Icons.cancel_outlined, AppTheme.errorRed)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildStatCard('Avg Score', '76%', Icons.analytics_outlined, AppTheme.warningOrange)),
                      ],
                    ),
                  ],
                ),
              
              const SizedBox(height: 28),
              
              // Middle Section - Simple bar chart
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Eligible vs Not Eligible Distribution',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryNavy,
                                ),
                          ),
                          Text(
                            'Total: 128',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      _buildBarChartRow('Eligible Decisions: 82', AppTheme.successGreen, 0.64),
                      const SizedBox(height: 16),
                      _buildBarChartRow('Not Eligible Decisions: 46', AppTheme.errorRed, 0.36),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 28),
              
              // Bottom Section - Recent Assessments list
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Assessments',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryNavy,
                        ),
                  ),
                  if (onStartNewAssessment != null)
                    TextButton.icon(
                      onPressed: onStartNewAssessment,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('New Assessment'),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Card(
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildListItem('Bhanu Pratap', 'Business Loan', true, '₹15,00,000', '84%'),
                    const Divider(height: 1),
                    _buildListItem('Rahul Sharma', 'Home Loan', true, '₹25,00,000', '79%'),
                    const Divider(height: 1),
                    _buildListItem('Amit Kumar', 'Personal Loan', false, '₹5,00,000', '42%'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 14),
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartRow(String label, Color color, double fraction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            Text(
              '${(fraction * 100).toInt()}%',
              style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 13),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Container(
                  width: constraints.maxWidth,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                Container(
                  width: constraints.maxWidth * fraction,
                  height: 18,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildListItem(String name, String type, bool isEligible, String amount, String score) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      leading: CircleAvatar(
        backgroundColor: AppTheme.primaryNavy.withValues(alpha: 0.08),
        child: Text(
          name[0],
          style: const TextStyle(color: AppTheme.primaryNavy, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text('$type • Amount: $amount • Score: $score'),
      trailing: Chip(
        label: Text(
          isEligible ? 'Eligible' : 'Not Eligible',
          style: TextStyle(
            color: isEligible ? AppTheme.successGreen : AppTheme.errorRed,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        backgroundColor: (isEligible ? AppTheme.successGreen : AppTheme.errorRed).withValues(alpha: 0.08),
        side: BorderSide(
          color: (isEligible ? AppTheme.successGreen : AppTheme.errorRed).withValues(alpha: 0.2),
        ),
      ),
    );
  }
}

