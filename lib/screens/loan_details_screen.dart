import 'package:flutter/material.dart';
import 'package:loan_eligibility/models/applicant.dart';
import 'package:loan_eligibility/models/loan_application.dart';
import 'package:loan_eligibility/theme/app_theme.dart';
import 'package:loan_eligibility/widgets/custom_text_field.dart';
import 'package:loan_eligibility/widgets/dropdown_field.dart';
import 'package:loan_eligibility/widgets/summary_card.dart';

String formatCurrency(double amount) {
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

class LoanDetailsScreen extends StatefulWidget {
  final Applicant applicant;
  final LoanApplication financialData;
  final VoidCallback onBack;
  final Function(LoanApplication completeData) onCheckEligibility;
  final VoidCallback onLoadDemo;

  const LoanDetailsScreen({
    super.key,
    required this.applicant,
    required this.financialData,
    required this.onBack,
    required this.onCheckEligibility,
    required this.onLoadDemo,
  });

  @override
  State<LoanDetailsScreen> createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _loanType;
  late final TextEditingController _loanAmountController;
  String? _loanTenure;
  String? _loanPurpose;

  @override
  void initState() {
    super.initState();
    final init = widget.financialData;
    _loanAmountController = TextEditingController(
      text: init.requestedAmount > 0 ? init.requestedAmount.toInt().toString() : '',
    );
    _loanType = init.loanType.isNotEmpty ? init.loanType : null;
    _loanTenure = init.loanTenure.isNotEmpty ? init.loanTenure : null;
    _loanPurpose = init.loanPurpose.isNotEmpty ? init.loanPurpose : null;

    _loanAmountController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    super.dispose();
  }

  void _loadDemo() {
    widget.onLoadDemo();
    setState(() {
      _loanType = 'Business Loan';
      _loanAmountController.text = '1500000';
      _loanTenure = '5 Years';
      _loanPurpose = 'Business Expansion';
    });
  }

  void _onCheckEligibility() {
    if (_formKey.currentState?.validate() ?? false) {
      final completeData = widget.financialData.copyWith(
        loanType: _loanType,
        requestedAmount: double.parse(_loanAmountController.text.trim()),
        loanTenure: _loanTenure,
        loanPurpose: _loanPurpose,
      );
      widget.onCheckEligibility(completeData);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enteredAmount = double.tryParse(_loanAmountController.text.trim()) ?? 0;

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
                          'Loan Details',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryNavy,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Specify your required financing parameters',
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
                        'Step 3 of 3',
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
                        DropdownField(
                          label: 'Loan Type',
                          value: _loanType,
                          items: const [
                            'Personal Loan',
                            'Home Loan',
                            'Car Loan',
                            'Education Loan',
                            'Business Loan',
                          ],
                          prefixIcon: Icons.category_outlined,
                          onChanged: (val) => setState(() => _loanType = val),
                          validator: (val) => val == null ? 'Please select loan category' : null,
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          controller: _loanAmountController,
                          label: 'Requested Loan Amount',
                          hint: 'e.g., 1500000',
                          prefixText: '₹ ',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.currency_rupee,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Requested loan amount is required';
                            final val = double.tryParse(value.trim());
                            if (val == null || val <= 0) {
                              return 'Must be a valid positive amount';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        DropdownField(
                          label: 'Loan Tenure',
                          value: _loanTenure,
                          items: const [
                            '1 Year',
                            '3 Years',
                            '5 Years',
                            '10 Years',
                            '15 Years',
                            '20 Years',
                          ],
                          prefixIcon: Icons.calendar_today_outlined,
                          onChanged: (val) => setState(() => _loanTenure = val),
                          validator: (val) => val == null ? 'Please select preferred tenure' : null,
                        ),
                        const SizedBox(height: 18),
                        DropdownField(
                          label: 'Loan Purpose',
                          value: _loanPurpose,
                          items: const [
                            'Business Expansion',
                            'Home Purchase',
                            'Vehicle Purchase',
                            'Education',
                            'Personal Expenses',
                            'Other',
                          ],
                          prefixIcon: Icons.lightbulb_outline,
                          onChanged: (val) => setState(() => _loanPurpose = val),
                          validator: (val) => val == null ? 'Please select loan purpose' : null,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SummaryCard(
                  title: 'Application Summary',
                  items: {
                    'Applicant Name': widget.applicant.fullName.isNotEmpty ? widget.applicant.fullName : 'Not provided',
                    'Annual Income': formatCurrency(widget.financialData.annualIncome),
                    'Credit Score': widget.financialData.creditScore.toString(),
                    'Loan Amount': enteredAmount > 0 ? formatCurrency(enteredAmount) : 'Not entered',
                    'Loan Type': _loanType ?? 'Not selected',
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton.icon(
                    onPressed: _loadDemo,
                    icon: const Icon(Icons.flash_on, size: 18),
                    label: const Text('Load Demo Loan Details (₹15L Business Loan)'),
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
                      onPressed: _onCheckEligibility,
                      icon: const Icon(Icons.assessment_outlined),
                      label: const Text('Check Eligibility'),
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

