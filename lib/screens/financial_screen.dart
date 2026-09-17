import 'package:flutter/material.dart';
import 'package:loan_eligibility/models/loan_application.dart';
import 'package:loan_eligibility/theme/app_theme.dart';
import 'package:loan_eligibility/widgets/custom_text_field.dart';
import 'package:loan_eligibility/widgets/dropdown_field.dart';

class FinancialScreen extends StatefulWidget {
  final LoanApplication? initialData;
  final VoidCallback onBack;
  final Function(LoanApplication) onNext;
  final VoidCallback onLoadDemo;

  const FinancialScreen({
    super.key,
    this.initialData,
    required this.onBack,
    required this.onNext,
    required this.onLoadDemo,
  });

  @override
  State<FinancialScreen> createState() => _FinancialScreenState();
}

class _FinancialScreenState extends State<FinancialScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late final TextEditingController _annualIncomeController;
  late final TextEditingController _monthlyIncomeController;
  late final TextEditingController _existingEmiController;
  late final TextEditingController _creditScoreController;
  late final TextEditingController _employmentDurationController;
  
  String? _existingLoans;

  @override
  void initState() {
    super.initState();
    final init = widget.initialData;
    _annualIncomeController = TextEditingController(
      text: init != null && init.annualIncome > 0 ? init.annualIncome.toInt().toString() : '',
    );
    _monthlyIncomeController = TextEditingController(
      text: init != null && init.monthlyIncome > 0 ? init.monthlyIncome.toInt().toString() : '',
    );
    _existingEmiController = TextEditingController(
      text: init != null && init.existingEMI >= 0 ? init.existingEMI.toInt().toString() : '',
    );
    _creditScoreController = TextEditingController(
      text: init != null && init.creditScore > 0 ? init.creditScore.toString() : '',
    );
    _employmentDurationController = TextEditingController(
      text: init?.employmentDuration ?? '',
    );
    
    _existingLoans = init?.existingLoans;
    if (_existingLoans == 'None' || _existingLoans == '') {
      _existingLoans = null;
    }
  }

  @override
  void dispose() {
    _annualIncomeController.dispose();
    _monthlyIncomeController.dispose();
    _existingEmiController.dispose();
    _creditScoreController.dispose();
    _employmentDurationController.dispose();
    super.dispose();
  }

  void _loadDemo() {
    widget.onLoadDemo();
    setState(() {
      _annualIncomeController.text = '800000';
      _monthlyIncomeController.text = '66667';
      _existingEmiController.text = '12000';
      _creditScoreController.text = '742';
      _existingLoans = 'Personal Loan';
      _employmentDurationController.text = '3 Years';
    });
  }

  void _onNext() {
    if (_formKey.currentState?.validate() ?? false) {
      final partialData = (widget.initialData ?? const LoanApplication()).copyWith(
        annualIncome: double.parse(_annualIncomeController.text.trim()),
        monthlyIncome: double.parse(_monthlyIncomeController.text.trim()),
        existingEMI: double.parse(_existingEmiController.text.trim()),
        creditScore: int.parse(_creditScoreController.text.trim()),
        existingLoans: _existingLoans ?? 'None',
        employmentDuration: _employmentDurationController.text.trim(),
      );
      widget.onNext(partialData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Financial Information',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryNavy,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Income, credit score, and existing liabilities',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryNavy.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'Step 2 of 3',
                        style: TextStyle(
                          color: AppTheme.primaryNavy,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: _annualIncomeController,
                          label: 'Annual Income',
                          hint: 'e.g., 800000',
                          prefixText: '₹ ',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.currency_rupee,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Annual income is required';
                            final val = double.tryParse(value.trim());
                            if (val == null || val <= 0) return 'Must be a valid positive amount';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          controller: _monthlyIncomeController,
                          label: 'Monthly Income',
                          hint: 'e.g., 66667',
                          prefixText: '₹ ',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.account_balance_wallet_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Monthly income is required';
                            final val = double.tryParse(value.trim());
                            if (val == null || val <= 0) return 'Must be a valid positive amount';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          controller: _existingEmiController,
                          label: 'Existing Monthly EMI',
                          hint: 'e.g., 12000 (0 if none)',
                          prefixText: '₹ ',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.payment_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Existing EMI is required (enter 0 if none)';
                            final val = double.tryParse(value.trim());
                            if (val == null || val < 0) return 'Must be 0 or a positive amount';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          controller: _creditScoreController,
                          label: 'Credit Score',
                          hint: '300 – 900',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.credit_score_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Credit score is required';
                            final val = int.tryParse(value.trim());
                            if (val == null || val < 300 || val > 900) return 'Credit score must be between 300 and 900';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        DropdownField(
                          label: 'Existing Loans',
                          value: _existingLoans,
                          items: const ['None', 'Personal Loan', 'Home Loan', 'Vehicle Loan', 'Multiple Loans'],
                          prefixIcon: Icons.account_balance_outlined,
                          onChanged: (val) => setState(() => _existingLoans = val),
                          validator: (val) => val == null ? 'Please specify existing loan category' : null,
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          controller: _employmentDurationController,
                          label: 'Employment Duration',
                          hint: 'e.g., 3 Years',
                          prefixIcon: Icons.access_time,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Employment duration is required';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.lightbulb_outline, size: 20, color: Colors.blue.shade800),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'These values are used as input features for the eligibility model.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton.icon(
                    onPressed: _loadDemo,
                    icon: const Icon(Icons.flash_on, size: 18),
                    label: const Text('Load Demo Financials (₹8L Income, 742 CIBIL)'),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: widget.onBack,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Back'),
                    ),
                    FilledButton.icon(
                      onPressed: _onNext,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Next Step'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

